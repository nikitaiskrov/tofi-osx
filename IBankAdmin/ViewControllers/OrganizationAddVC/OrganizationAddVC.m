//
//  OrganizationAddVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 15.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "OrganizationAddVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Organization.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"


@interface OrganizationAddVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}

@end


@implementation OrganizationAddVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [super viewWillAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetPaymentOptionsList parameterID: -1];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          if (error)
                                          {
                                              [DJProgressHUD dismiss];
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Ошибка"
                                                                               defaultButton:@"OK"
                                                                             alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
                                              
                                              NSLog(@"%@ %@", response, responseObject);

                                              [alert runModal];
                                          }
                                          else
                                          {
                                              [DJProgressHUD dismiss];
                                              
                                              NSArray *paymetnsOptionsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"options"];
                                              [iBankSessionManager.PaymentOptions removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < paymetnsOptionsFromServer.count; i++)
                                              {
                                                  PaymentOption *option = [[PaymentOption alloc] initWIthDictionary:(NSDictionary *)paymetnsOptionsFromServer[i]];
                                                  
                                                  [iBankSessionManager.PaymentOptions addObject:option];
                                              }
                                              
                                              [self.TableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];
}


- (NSMutableArray *)SelectedPaymentsIDs
{
    NSMutableArray *selectedIDs = [NSMutableArray array];
    NSMutableArray *allPaymentOptions = iBankSessionManager.PaymentOptions;
    
    NSUInteger idx = [self.TableView.selectedRowIndexes firstIndex];
    
    while (idx != NSNotFound)
    {
        NSInteger ID = ((PaymentOption *)allPaymentOptions[idx]).ID;
        [selectedIDs addObject:[@(ID) stringValue]];
        idx = [self.TableView.selectedRowIndexes indexGreaterThanIndex:idx];
    }
    
    NSLog(@"%@", selectedIDs);
    return selectedIDs;
}


- (void)SwitchViewControllers
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"OrganizationsListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}



#pragma mark - TableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.TableView)
    {
        return iBankSessionManager.PaymentOptions.count;
    }
    
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == self.TableView)
    {
        PaymentOption *option = [iBankSessionManager.PaymentOptions objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:option.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return option.Type;
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return option.ActionDescription;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return option.Description;
        }
    }
    
    return  nil;
}



#pragma mark - Buttons Actions

- (IBAction)AddOrganizationButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateOrganization parameterID:-1];
    NSDictionary *parameters = @{
                                  @"session" : iBankSessionManager.sessionID,
                                  @"organization":
                                        @{
                                             @"paymentOptionsIds" : [self SelectedPaymentsIDs],
                                             @"categoryId" : [@(iBankSessionManager.CurrentEditableCategoryID) stringValue],
                                             @"name" : self.NameTextField.stringValue,
                                             @"address" : self.AddressTextField.stringValue,
                                             @"phone" : self.PhoneTextField.stringValue
                                          }
                                };


    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          if (error)
                                          {
                                              [DJProgressHUD dismiss];
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Ошибка"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
                                              alert.alertStyle = NSAlertStyleCritical;
                                              
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              [alert runModal];
                                          }
                                          else
                                          {
                                              [DJProgressHUD dismiss];
                                              
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Организация успешно добавлена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];

                                              [self SwitchViewControllers];
                                          }
                                      }];
    
    [dataTask resume];
}

- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"CategoryListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];

}
@end
