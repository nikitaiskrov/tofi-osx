//
//  CardInfoEditVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 11.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "CardInfoEditVC.h"
#import "IBankSessionManager.h"
#import "DJProgressHUD.h"
#import "AFNetworking.h"
#import "Card.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"


@interface CardInfoEditVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    NSInteger currentSelectedPopUpMenuButtonIndex;
    Card *card;
    BOOL isBlocked;
    NSInteger blockSeconds;
}

@end

@implementation CardInfoEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewDidAppear
{
    [super viewDidAppear];
    [self fetchCard];
    card = nil;
    for (NSInteger i = 0; i < iBankSessionManager.Cards.count; i++)
    {
        if (((Card *)iBankSessionManager.Cards[i]).ID == iBankSessionManager.CurrentEditableCardID)
        {
            card = ((Card *)iBankSessionManager.Cards[i]);
            break;
        }
    }
    
    if (card != nil)
    {
        NSInteger cardNumber = [card.LastFourNumbers integerValue];
        
        if (cardNumber == 0)
        {
            [self.ChangeStatusButton setEnabled:false];
            [self.BlockOnHoursTextField setEnabled:false];
        }
        else
        {
            [self.CardInfoButton setEnabled:false];
        }
        
        isBlocked = card.IsBlocked;

        [self prepareTextFields];
    }
    else
    {
        [self.ChangeStatusButton setEnabled:false];
        [self.BlockOnHoursTextField setEnabled:false];
    }
}


- (void)prepareTextFields
{
    self.OwnerNameTextField.stringValue = card.OwnerName;
    self.FirstLimitTextField.stringValue = card.CashAmountLimit;
    self.SecondLimitTextField.stringValue = card.CashAttemptsLimit;
    self.ThirdLimitTextField.stringValue = card.CashlessAmountLimit;
    self.FourLimitTextField.stringValue = card.CashlessAttemptsLimit;
    
    [self UpdateCardInfoUIComponents];
}


- (void)UpdateCardInfoUIComponents
{
    if (isBlocked)
    {
        self.StatusLabel.textColor = [NSColor redColor];
        self.StatusLabel.stringValue = @"Заблокирована";
        self.ChangeStatusButton.title = @"Разблокировать";
        
        [self.BlockOnHoursTextField setEnabled:false];
        
        NSDate *date = card.BlockExpiredAt;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str =  [formatter stringFromDate:date];
        
        self.BlockDateLabel.stringValue = card.DateIsNull ? @"Навсегда" : str;
    }
    else
    {
        [self.BlockOnHoursTextField setEnabled:true];
        
        self.StatusLabel.textColor = [NSColor greenColor];
        self.StatusLabel.stringValue = @"Активна";
        self.ChangeStatusButton.title = @"Заблокировать";
        
        self.BlockDateLabel.stringValue = @"-";
    }
}


- (void)fetchCard
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetCardWithID parameterID:iBankSessionManager.CurrentEditableCardID];
    
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
                                              
                                              card = [[Card alloc] initWIthDictionary:(NSDictionary *)responseObject];
                                              isBlocked = card.IsBlocked;
                                              [self UpdateCardInfoUIComponents];
                                          }
                                      }];
    
    [dataTask resume];
}


- (void)createCardInfo
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateCardInfo parameterID:-1];

    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"cardInfo":
                                     @{
                                         @"cardId":[@(iBankSessionManager.CurrentEditableCardID) stringValue],
                                         @"cardTypeId":[@(currentSelectedPopUpMenuButtonIndex + 1) stringValue],
                                         @"ownerName":self.OwnerNameTextField.stringValue
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Информация по карте изменена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              
                                              [self.CardInfoButton setEnabled:false];
                                              [self fetchCard];

                                          }
                                      }];
    
    [dataTask resume];

}


- (void)createCardLimits
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateCardLimits parameterID:-1];

    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"cardLimit":
                                     @{
                                         @"cardId":[@(iBankSessionManager.CurrentEditableCardID) stringValue],
                                         @"cashAmount":self.FirstLimitTextField.stringValue,
                                         @"cashAttempts":self.SecondLimitTextField.stringValue,
                                         @"cashlessAmount":self.ThirdLimitTextField.stringValue,
                                         @"cashlessAttempts":self.FourLimitTextField.stringValue
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Лимиты по карте добавлены"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              [self fetchCard];

                                          }
                                      }];
    
    [dataTask resume];
}


- (void)updateCardLimits
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:UpdateCardLimits parameterID:iBankSessionManager.CurrentEditableCardID];
    
    NSDictionary *parameters = @{
                                 @"session" : iBankSessionManager.sessionID,
                                 @"cardLimit":
                                     @{
                                         @"cashAmount":self.FirstLimitTextField.stringValue,
                                         @"cashAttempts":self.SecondLimitTextField.stringValue,
                                         @"cashlessAmount":self.ThirdLimitTextField.stringValue,
                                         @"cashlessAttempts":self.FourLimitTextField.stringValue
                                         }
                                 };
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Лимиты по карте изменены"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              [self fetchCard];

                                          }
                                      }];
    
    [dataTask resume];
}



#pragma mark - Actions

- (IBAction)CartTypePopUpButtonChange:(id)sender
{
    currentSelectedPopUpMenuButtonIndex = [sender indexOfSelectedItem];
}


- (IBAction)CardInfoSaveChangesButonOnClick:(id)sender
{
    [self createCardInfo];
}


- (IBAction)CardLimitsSaveChangesButtonOnClick:(id)sender
{
    if ([card.CashAttemptsLimit isEqual:@""])
    {
        [self createCardLimits];
    }
    else
    {
        [self updateCardLimits];
    }
}


- (IBAction)BackButtonOnClick:(id)sender
{    
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"BankAccountVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (IBAction)BlockButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:ChageCardStatus parameterID:iBankSessionManager.CurrentEditableCardID];
    NSString *newBlockStatus = isBlocked ? @"unblock" : @"block";
    NSDictionary *parameters = nil;
    blockSeconds = self.BlockOnHoursTextField.integerValue * 3600;
    
    if (self.BlockOnHoursTextField.integerValue > 0)
    {
        parameters = @{
                         @"session" : iBankSessionManager.sessionID,
                         @"blockType": newBlockStatus,
                         @"blockDuration" : [@(blockSeconds) stringValue],
                         };
    }
    else
    {
        parameters = @{
                         @"session" : iBankSessionManager.sessionID,
                         @"blockType": newBlockStatus,
                         };
    }

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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Статус карты изменен"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              
                                              [self fetchCard];
//                                              isBlocked = !isBlocked;
//                                              [self UpdateCardInfoUIComponents];
                                          }
                                      }];
    
    [dataTask resume];
}
@end
