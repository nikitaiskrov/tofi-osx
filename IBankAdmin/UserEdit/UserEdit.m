//
//  UserEdit.m
//  IBankAdmin
//
//  Created by Никита Искров on 05.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "UserEdit.h"
#import "IBankSessionManager.h"
#import "User.h"
#import "Account.h"
#import "AFNetworking.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"

@interface UserEdit ()
{
    IBankSessionManager *iBankSessionManager;
    BOOL isBlocked;
    Account *account;
    User *user;
    NSViewController *mainWindowRootController;
    NSInteger currentSelectedPopUpMenuButtonIndex;
    NSInteger seconds;
}

@end



@implementation UserEdit

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self PrepareTextFields];
    
    [self ChechAccountToCurrentClent];
}



#pragma mark - PrivateMethods

- (void)PrepareTextFields
{
    if (iBankSessionManager.Users.count > 0 && iBankSessionManager.CurrentEditableUserID != -1)
    {
        user = nil;
        for (NSInteger i = 0; i < iBankSessionManager.Users.count; i++)
        {
            if (((User *)iBankSessionManager.Users[i]).ID == iBankSessionManager.CurrentEditableUserID)
            {
                user = ((User *)iBankSessionManager.Users[i]);
                break;
            }
        }
        
        self.IDTextField.integerValue = user.ID;
        self.LastNameTextField.stringValue = user.SecondName;
        self.FirstNameTextField.stringValue = user.FirstName;
        self.MiddleNameTextField.stringValue = user.MiddleName;
        self.PhoneTextField.stringValue = user.PhoneNumber;
        self.PassportTextField.stringValue = user.PassportNumber;
        self.NationalityTextField.stringValue = user.Nationality;
        self.BirthdayTextField.stringValue = [[iBankSessionManager GetDateFormatter] stringFromDate:user.Birthday];
        self.IdentificationTextField.integerValue = user.Identification;
        self.PlaceOfBirthTextField.stringValue = user.PlaceOfBirth;
        self.DateOfIssueTextField.objectValue = [[iBankSessionManager GetDateFormatter] stringFromDate:user.PassportDateIssuse];
        self.DateOfExpirationTextField.objectValue = [[iBankSessionManager GetDateFormatter] stringFromDate:user.PassportDateExpiry];
        self.AuthorityTextField.stringValue = user.Authority;
        self.DateAddedTextField.objectValue = [[iBankSessionManager GetDateFormatter] stringFromDate:user.CreatedAt];
        self.DateUpdateTextField.objectValue = [[iBankSessionManager GetDateFormatter] stringFromDate:user.UpdatedAt];
        
        
        account = nil;
        for (NSInteger i = 0; i < iBankSessionManager.Accounts.count; i++)
        {
            if (((Account *)iBankSessionManager.Accounts[i]).ClientID == iBankSessionManager.CurrentEditableUserID)
            {
                account = ((Account *)iBankSessionManager.Accounts[i]);
                break;
            }
        }
        iBankSessionManager.CurrentEditableAccountID = account.ID;
        
        if (account != nil)
        {
            self.LoginTextField.stringValue = account.Username;
            isBlocked = account.IsBlocked;
            
            [self UptadeAccountUIComponents];
        }
    }
}


- (void)UptadeAccountUIComponents
{
//    self.StatusChangebleLabel.stringValue = account.IsBlockedString;
    
    if (isBlocked)
    {
        self.StatusChangebleLabel.textColor = [NSColor redColor];
        self.ChangeStatusButton.title = @"Разблокировать";
        
        NSDate *date = account.BlockedDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str =  [formatter stringFromDate:date];
        
        self.StatusChangebleLabel.stringValue = account.DateIsNull ? @"Заблокирован навсегда" : [NSString stringWithFormat:@"Заблокирован до %@", str];
        [self.ChangeStatusTextField setEnabled:false];
    }
    else
    {
        self.StatusChangebleLabel.textColor = [NSColor greenColor];
        self.ChangeStatusButton.title = @"Заблокировать";
        self.StatusChangebleLabel.stringValue = @"Активен";
        [self.ChangeStatusTextField setEnabled:true];
    }
}


- (void)ChechAccountToCurrentClent
{
    [self.BankAccountsButton setEnabled:true];

    if (account == nil)
    {
        [self.ChangeStatusTextField setEnabled:false];
        self.ChangeStatusButton.title = @"Cоздать аккаунт";
        self.StatusChangebleLabel.stringValue = @"Не создан для текущего клиента. Для работы с карт-счетами клиента создайте для него аккаунт.";
        [self.BankAccountsButton setEnabled:false];
    }
    else
    {
        [self FetchAccount];
    }
}


- (void)FetchAccount
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetAccountWithID parameterID:iBankSessionManager.CurrentEditableAccountID];
    
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

                                              account = [[Account alloc] initWIthDictionary:(NSDictionary *)responseObject];
                                              isBlocked = account.IsBlocked;
                                              [self UptadeAccountUIComponents];
                                          }
                                      }];
    
    [dataTask resume];
}


- (void)ChangeStatusRequest
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:ChangeAccountStatus parameterID:-1];
    URLString = [URLString stringByAppendingFormat:@"%ld/block", (long)iBankSessionManager.CurrentEditableAccountID];
    NSString *newBlockStatus = isBlocked ? @"unblock" : @"block";
    seconds = self.ChangeStatusTextField.integerValue * 3600;
    
    NSDictionary *parameters = nil;

    
    if (seconds > 0)
    {
        parameters = @{
                       @"session" : iBankSessionManager.sessionID,
                       @"blockType": newBlockStatus,
                       @"blockDuration" : [@(seconds) stringValue]
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Статус аккаунта изменен"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              [alert runModal];
                                              
                                              [self FetchAccount];
//                                              isBlocked = !isBlocked;
//                                              [self UptadeAccountUIComponents];
                                          }
                                      }];
    
    [dataTask resume];
}


- (void)SegueToCreateAccountController
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"AccountAddVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];

}



#pragma mark - actions

- (IBAction)SaveButtonOnClic:(NSButton *)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:PutUserWithID parameterID:self.IDTextField.integerValue];
    NSDictionary *parameters = @{
                                 @"session": iBankSessionManager.sessionID,
                                 @"client":
                                     @{
                                         @"firstName": self.FirstNameTextField.stringValue,
                                         @"middleName": self.MiddleNameTextField.stringValue,
                                         @"secondName": self.LastNameTextField.stringValue,
                                         @"phoneNumber": self.PhoneTextField.stringValue,
                                         @"passportNumber": self.PassportTextField.stringValue,
                                         @"nationality": self.NationalityTextField.stringValue,
                                         @"birthday": self.BirthdayTextField.objectValue,
                                         @"sex": (currentSelectedPopUpMenuButtonIndex == 0) ? @"m" : @"f",
                                         @"identification": self.IdentificationTextField.stringValue,
                                         @"placeOfBirth": self.PlaceOfBirthTextField.stringValue,
                                         @"passportDateOfIssue": self.DateOfIssueTextField.objectValue,
                                         @"passportDateOfExpiry": self.DateOfExpirationTextField.objectValue,
                                         @"authority": self.AuthorityTextField.stringValue
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Сохранение совершено успешно"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];

}


- (IBAction)ChangeStatusButtonOnClick:(id)sender
{
    if (account == nil)
    {
        [self SegueToCreateAccountController];
    }
    else
    {
        [self ChangeStatusRequest];
    }
}


- (IBAction)BankAccountsButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"BankAccountListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (IBAction)PopUpButtonSelectionDidChange:(id)sender
{
    currentSelectedPopUpMenuButtonIndex = [sender indexOfSelectedItem];
}

@end
