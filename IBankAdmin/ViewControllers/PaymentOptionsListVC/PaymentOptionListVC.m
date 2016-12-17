//
//  PaymentOptionListVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 17.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "PaymentOptionListVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Organization.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface PaymentOptionListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}

@end

@implementation PaymentOptionListVC

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



- (IBAction)AddPaymentOptionButtonOnClick:(id)sender
{
}
@end
