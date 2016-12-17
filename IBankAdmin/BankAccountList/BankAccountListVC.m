//
//  BankAccountList.m
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "BankAccountListVC.h"
#import "IBankSessionManager.h"
#import "DJProgressHUD.h"
#import "AFNetworking.h"
#import "BankAccount.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"

@interface BankAccountListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
    NSInteger currentSelectedPopUpMenuButtonIndex;
}

@end



@implementation BankAccountListVC

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    [self fetchBankAccounts];
}



- (void)fetchBankAccounts
{
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetBankAccountsWithOwnerID parameterID:iBankSessionManager.CurrentEditableAccountID];
    
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
                                              
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              NSArray *accountsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"bankAccounts"];
                                              [iBankSessionManager.BankAccounsts removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < accountsFromServer.count; i++)
                                              {
                                                  BankAccount *bankAccount = [[BankAccount alloc] initWIthDictionary:(NSDictionary *)accountsFromServer[i]];
                                                  
                                                  [iBankSessionManager.BankAccounsts addObject:bankAccount];
                                              }
                                              
                                              [self.TableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (tableView == self.TableView) ? iBankSessionManager.BankAccounsts.count : 0;
}



- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.TableView)
    {
        BankAccount *bankAccount = [iBankSessionManager.BankAccounsts objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:bankAccount.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:bankAccount.OwnerID];
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            switch(bankAccount.OwnerType)
            {
                case User:
                    return @"Пользователь";
                    break;
                case Organization:
                    return @"Организация";
                    break;
            }
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:bankAccount.Number];
        }
        else if ([tableView tableColumns][4] == tableColumn)
        {
            return bankAccount.IsBlocked ? @"Заблокирован" : @"Активен";
        }
        else if ([tableView tableColumns][5] == tableColumn)
        {
            return bankAccount.BlockExpiredAt;
        }
        else if ([tableView tableColumns][6] == tableColumn)
        {
            return bankAccount.CreatedAt;
        }
        else if ([tableView tableColumns][7] == tableColumn)
        {
            return bankAccount.UpdatedAt;
        }
        else if ([tableView tableColumns][8] == tableColumn)
        {
            return [NSNumber numberWithFloat:bankAccount.Balance];
        }
        else if ([tableView tableColumns][9] == tableColumn)
        {
            return bankAccount.Currency;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    BankAccount *selectedAccount = iBankSessionManager.BankAccounsts[[[notification object] selectedRow]];
    NSInteger selectedAccountID = selectedAccount.ID;
    
    if (selectedAccountID > 0)
    {
        iBankSessionManager.CurrentEditableBankAccountID = selectedAccountID;
        lastSelectedRowIndex = [[notification object] selectedRow];
        
        NSStoryboard *sb = [self storyboard];
        id animator = [[MyCustomAnimator alloc] init];
        NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"BankAccountVC"];
        
        if (mainWindowRootController == nil)
        {
            mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
        }
        
        [mainWindowRootController presentViewController:userEdit animator:animator];
    }
}


- (IBAction)AddNewBankAccountButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];

    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateBankAccount parameterID:-1];
    
    NSDictionary *parameters = @{
                                 @"session": iBankSessionManager.sessionID,
                                 @"bankAccount":
                                            @{
                                                 @"ownerId": [NSString stringWithFormat:@"%ld", iBankSessionManager.CurrentEditableAccountID],
                                                 @"ownerType": @"user",
                                                 @"currencyId": [NSString stringWithFormat:@"%ld", (currentSelectedPopUpMenuButtonIndex + 1)]
                                              }
                                 };

    
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          if (error)
                                          {
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Ошибка"
                                                                               defaultButton:@"OK"
                                                                             alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
                                              
                                              [alert runModal];
                                          }
                                          else
                                          {
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              [self fetchBankAccounts];
                                          }
                                      }];
    
    [dataTask resume];

}


- (IBAction)PopUpMenuSelectedItemDidChange:(id)sender
{
   currentSelectedPopUpMenuButtonIndex = [sender indexOfSelectedItem];
}


- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserEdit"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}

@end
