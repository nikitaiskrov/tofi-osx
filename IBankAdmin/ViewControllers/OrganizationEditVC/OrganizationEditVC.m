//
//  OrganizationEditVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "OrganizationEditVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Organization.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"


@interface OrganizationEditVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    Organization *organization;
    NSInteger lastSelectedRowIndex;
}

@end

@implementation OrganizationEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [super viewWillAppear];
    
    organization = nil;
    for (NSInteger i = 0; i < iBankSessionManager.Organizations.count; i++)
    {
        if (((Organization *)iBankSessionManager.Organizations[i]).ID == iBankSessionManager.CurrentEditableOrganizationID)
        {
            organization = ((Organization *)iBankSessionManager.Organizations[i]);
            break;
        }
    }
    
    [self PrepareTextFields];

    [self FetchPaymetsOptions];
}


- (void)PrepareTextFields
{
    if (organization != nil)
    {
        self.NameTextField.stringValue = organization.Name;
        self.AddressTextField.stringValue = organization.Address;
        self.PhoneTextField.stringValue = organization.Phone;
    }
}


- (void)FetchPaymetsOptions
{
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

- (IBAction)UpdateOrganizationButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:UpdateOrganization parameterID:organization.ID];
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
    
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Организация успешно обновлена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];                                              
                                          }
                                      }];
    
    [dataTask resume];
}


- (IBAction)BackButtonOnClick:(id)sender
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

- (IBAction)DeleteOrganizationButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:DeleteOrganization parameterID:organization.ID];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:URLString parameters:nil error:nil];
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
                                              
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              iBankSessionManager.CurrentEditableUserID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Организация успешно удалена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                              
                                              [DJProgressHUD dismiss];
                                              
                                              [self SwitchViewControllers];
                                          }
                                      }];
    
    [dataTask resume];
}

@end
