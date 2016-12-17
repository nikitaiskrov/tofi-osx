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
}

@end

@implementation CardInfoEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    card = nil;
    for (NSInteger i = 0; i < iBankSessionManager.Cards.count; i++)
    {
        if (((Card *)iBankSessionManager.Cards[i]).ID == iBankSessionManager.CurrentEditableCardID)
        {
            card = ((Card *)iBankSessionManager.Cards[i]);
            break;
        }
    }
    
    NSString *cardNumber = card.LastFourNumbers;
    
    if (![cardNumber isMemberOfClass:[NSNull class]])
    {
        [self.CardInfoButton setEnabled:false];
    }
    
    [self prepareTextFields];
}


- (void)prepareTextFields
{
    self.OwnerNameTextField.stringValue = card.OwnerName;
    self.FirstLimitTextField.stringValue = card.CashAmountLimit;
    self.SecondLimitTextField.stringValue = card.CashAttemptsLimit;
    self.ThirdLimitTextField.stringValue = card.CashlessAmountLimit;
    self.FourLimitTextField.stringValue = card.CashlessAttemptsLimit;
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Информация по карте изменена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];
}


- (void)updateCardLimits
{
    
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
    if (![card.CashAttemptsLimit  isEqual: @""] ||
        ![card.CashAmountLimit isEqual:@""] ||
        ![card.CashlessAttemptsLimit isEqual:@""] ||
        ![card.CashlessAmountLimit isEqual:@""])
    {
        NSLog(@"Need update");
    }
    else
    {
        [self createCardLimits];
    }
}

- (IBAction)BackButtonOnClick:(id)sender
{    
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"BankAccountVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}
@end