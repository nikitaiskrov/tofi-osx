//
//  CreateBankAccountVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "BankAccountVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"
#import "BankAccount.h"
#import "Card.h"

@interface BankAccountVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    BankAccount *account;
    bool isBlocked;
    NSInteger lastSelectedRowIndex;
    NSInteger cashAmount;
}

@end



@implementation BankAccountVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self PrepareTextFields];
    
    [self fetchCards];
}



#pragma mark - TableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (tableView == self.CardsTableView) ? iBankSessionManager.Cards.count : 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.CardsTableView)
    {
        Card *card = [iBankSessionManager.Cards objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return card.LastFourNumbers;
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return card.IsBlocked ? @"Заблокирован" : @"Активен";
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return card.CardType;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return card.ExpiredAt;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger index = [[notification object] selectedRow];
    if (index >= 0)
    {
        Card *selectedCard = iBankSessionManager.Cards[index];
        NSString *cardNumber = selectedCard.LastFourNumbers;
        
    //    if ([cardNumber isMemberOfClass:[NSNull class]])
    //    {
            iBankSessionManager.CurrentEditableCardID = selectedCard.ID;
            
            NSStoryboard *sb = [self storyboard];
            id animator = [[MyCustomAnimator alloc] init];
            NSViewController *cardEdit = [sb instantiateControllerWithIdentifier:@"CardInfoEditVC"];
            
            if (mainWindowRootController == nil)
            {
                mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
            }
            [mainWindowRootController presentViewController:cardEdit animator:animator];
    //    }
    }
}



#pragma mark - PrivateMethods

- (void)PrepareTextFields
{
    account = nil;
    
    for (NSInteger i = 0; i < iBankSessionManager.BankAccounsts.count; i++)
    {
        if (((BankAccount *)iBankSessionManager.BankAccounsts[i]).ID == iBankSessionManager.CurrentEditableBankAccountID)
        {
            account = ((BankAccount *)iBankSessionManager.BankAccounsts[i]);
            break;
        }
    }
    
    self.IDInfoLabel.integerValue = account.ID;
    self.OwnerIDInfoLabel.integerValue = account.OwnerID;
    switch(account.OwnerType)
    {
        case User:
            self.OwnerTypeInfoLabel.stringValue = @"Пользователь";
            break;
        case Organization:
            self.OwnerTypeInfoLabel.stringValue = @"Организация";
            break;
    }
    self.NumberInfoLabel.stringValue = [@(account.Number) stringValue];
    self.DateBlockedInfoLabel.stringValue = account.BlockExpiredAt;
    self.DateCreateInfoLabel.stringValue = account.CreatedAt;
    self.DateUpdateInfoLabel.stringValue = account.UpdatedAt;
    self.BallanceInfoLabel.floatValue = account.Balance;
    self.CurrencyInfoLabel.stringValue = account.Currency;
    
    if (account != nil)
    {
        isBlocked = account.IsBlocked;
        
        [self UptadeAccountUIComponents];
    }
}


- (void)UptadeAccountUIComponents
{
    if (isBlocked)
    {
        self.StatusInfoLabel.textColor = [NSColor redColor];
        self.ChangeStatusButton.title = @"Разблокировать аккаунт";
        self.StatusInfoLabel.stringValue = @"Заблокирован";
    }
    else
    {
        self.StatusInfoLabel.textColor = [NSColor greenColor];
        self.ChangeStatusButton.title = @"Заблокировать аккаунт";
        self.StatusInfoLabel.stringValue = @"Активен";
    }
}


- (void)fetchCards
{
    if (lastSelectedRowIndex > 0)
    {
        [self.CardsTableView deselectRow:lastSelectedRowIndex];
    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetAllCardsForAccount parameterID:iBankSessionManager.CurrentEditableBankAccountID];
    
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
                                              
                                              NSArray *cardsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"cards"];
                                              [iBankSessionManager.Cards removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < cardsFromServer.count; i++)
                                              {
                                                  Card *card = [[Card alloc] initWIthDictionary:(NSDictionary *)cardsFromServer[i]];
                                                  
                                                  [iBankSessionManager.Cards addObject:card];
                                              }
                                              
                                              [self.CardsTableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];

}



#pragma mark - Actions

- (IBAction)BlockBankAccoundButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:ChangeBankAccountStatus parameterID:-1];
    URLString = [URLString stringByAppendingFormat:@"%ld/block", (long)iBankSessionManager.CurrentEditableBankAccountID];
    NSString *newBlockStatus = isBlocked ? @"unblock" : @"block";
    
    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"blockType": newBlockStatus,
                                 @"blockDuration" : @600,
                                 };
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Статус аккаунта изменен"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              
                                              isBlocked = !isBlocked;
                                              [self UptadeAccountUIComponents];
                                          }
                                      }];
    
    [dataTask resume];
}


- (IBAction)AddCardButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateCard parameterID:-1];

    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"card":
                                     @{
                                         @"accountId":[@(iBankSessionManager.CurrentEditableBankAccountID) stringValue]
                                      }
                                 };
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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

                                              iBankSessionManager.CurrentEditableCardID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                                                                            
                                              NSStoryboard *sb = [self storyboard];
                                              id animator = [[MyCustomAnimator alloc] init];
                                              NSViewController *cardEdit = [sb instantiateControllerWithIdentifier:@"CardInfoEditVC"];
                                              
                                              if (mainWindowRootController == nil)
                                              {
                                                  mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
                                              }
                                              [mainWindowRootController presentViewController:cardEdit animator:animator];

//                                              [self fetchCards];
                                          }
                                      }];
    
    [dataTask resume];

}


- (IBAction)AddCashButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateEnrollment parameterID:-1];
    
    cashAmount = self.AddCashTextField.integerValue;
    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"payment":
                                 @{
                                         @"accountId":[@(iBankSessionManager.CurrentEditableBankAccountID) stringValue],
                                         @"amount":[@(cashAmount) stringValue]
                                   }
                                };

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Деньги внесены на счет"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              
                                              self.BallanceInfoLabel.integerValue += cashAmount;
                                          }
                                      }];
    
    [dataTask resume];

}

- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"BankAccountListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}
@end
