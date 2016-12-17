//
//  ClientAddVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "ClientAddVC.h"
#import "IBankSessionManager.h"
#import "User.h"
#import "AFNetworking.h"
#import "DJProgressHUD.h"
#import "RandomManager.h"
#import "UserAddVC.h"
#import "AccountAddVC.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"

@interface ClientAddVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
}

@end



@implementation ClientAddVC
#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self PrepareTextFields];
}



#pragma mark - PrivateMethods

- (void)PrepareTextFields
{
    RandomManager *randomManager = [RandomManager manager];
    
    self.LastNameTextField.stringValue = @"Test";
    self.FirstNameTextField.stringValue = @"Test";
    self.MiddleNameTextField.stringValue = @"Test";
    self.PhoneTextField.stringValue = @"12345432345";
    self.PassportTextField.stringValue = [randomManager randomStringNumberWithLength:10];
    self.NationalityTextField.stringValue = @"Грек";
    self.BirthdayTextField.objectValue = @"1994-10-10";
    self.SexTextField.stringValue = @"m";
    self.IdentificationTextField.stringValue = [randomManager randomStringNumberWithLength:10];
    self.PlaceOfBirthTextField.stringValue = @"Test";
    self.DateOfIssueTextField.objectValue = @"2010-10-10";
    self.DateOfExpirationTextField.objectValue = @"2020-10-10";
    self.AuthorityTextField.stringValue = @"Минский РОВД";
    self.SecretQuestionTextField.objectValue = @"Девичья фамилия матери";
    self.SecretAnswerTextField.objectValue = @"Петрова";
}



- (IBAction)SaveButtonOnClick:(NSButton *)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateClient parameterID:-1];
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
                                         @"birthday": self.BirthdayTextField.stringValue,
                                         @"sex": self.SexTextField.stringValue,
                                         @"identification": self.IdentificationTextField.stringValue,
                                         @"placeOfBirth": self.PlaceOfBirthTextField.stringValue,
                                         @"passportDateOfIssue": self.DateOfIssueTextField.stringValue,
                                         @"passportDateOfExpiry": self.DateOfExpirationTextField.stringValue,
                                         @"authority": self.AuthorityTextField.stringValue,
                                         @"secretQuestion":  self.SecretQuestionTextField.objectValue,
                                         @"secretAnswer": self.SecretAnswerTextField.objectValue
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
                                              
                                              [self SwitchViewControllers];
                                              
                                              iBankSessionManager.CurrentEditableUserID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Клиент успешно добавлен. Создайте для него аккаунт."
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
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
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}



- (void)SwitchViewControllers
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"AccountAddVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


@end
