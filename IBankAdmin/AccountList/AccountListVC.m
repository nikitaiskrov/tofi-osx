//
//  AccountListVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "AccountListVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Account.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"

@interface AccountListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}


@end



@implementation AccountListVC

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetAccountList parameterID:-1];
    
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
                                              
                                              [alert runModal];
                                          }
                                          else
                                          {
                                              [DJProgressHUD dismiss];
                                              
                                              NSArray *accountsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"users"];
                                              [iBankSessionManager.Accounts removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < accountsFromServer.count; i++)
                                              {
                                                  Account *account = [[Account alloc] initWIthDictionary:(NSDictionary *)accountsFromServer[i]];
                                                  
                                                  [iBankSessionManager.Accounts addObject:account];
                                              }
                                              
                                              [self.TableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (tableView == self.TableView) ? iBankSessionManager.Accounts.count : 0;
}



- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == self.TableView)
    {
        Account *account = [iBankSessionManager.Accounts objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:account.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return (account.ClientID == -1) ? @"-" : [NSNumber numberWithUnsignedInteger:account.ClientID];
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return account.Username;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return account.Role;
        }
        else if ([tableView tableColumns][4] == tableColumn)
        {
            return account.IsBlockedString;
        }
        else if ([tableView tableColumns][5] == tableColumn)
        {
            if (account.IsBlocked)
            {
                NSDate *date = account.BlockedDate;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *str =  [formatter stringFromDate:date];
                
                return account.DateIsNull ? @"Навсегда" : str;
            }
            else
            {
                return @"-";
            }
        }
        else if ([tableView tableColumns][6] == tableColumn)
        {
            return account.CreatedAt;
        }
        else if ([tableView tableColumns][7] == tableColumn)
        {
            return account.UpdatedAt;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger index = [[notification object] selectedRow];
    if (index >= 0)
    {
        Account *selectedAccount = iBankSessionManager.Accounts[index];
        NSInteger clientID = selectedAccount.ClientID;
        
        if (clientID > 0)
        {
            iBankSessionManager.CurrentEditableUserID = selectedAccount.ClientID;
            iBankSessionManager.CurrentEditableAccountID = selectedAccount.ID;
            lastSelectedRowIndex = [[notification object] selectedRow];
            
            NSStoryboard *sb = [self storyboard];
            id animator = [[MyCustomAnimator alloc] init];
            NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserEdit"];
            
            if (mainWindowRootController == nil)
            {
                mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
            }
            
            [mainWindowRootController presentViewController:userEdit animator:animator];
        }
    }
}

@end
