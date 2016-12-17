//
//  AccountAddVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "AccountAddVC.h"
#import "IBankSessionManager.h"
#import "User.h"
#import "AFNetworking.h"
#import "DJProgressHUD.h"
#import "RandomManager.h"

@interface AccountAddVC ()
{
    IBankSessionManager *iBankSessionManager;
}

@end



@implementation AccountAddVC

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


- (void)PrepareTextFields
{
    self.LoginTextField.stringValue = @"client@gmail.com";
    self.PasswordTextField.stringValue = @"Qwerty_12345";
}



- (IBAction)SaveButtonOnClick:(NSButton *)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreateAccount parameterID:-1];
    NSDictionary *parameters = @{
                                     @"session" : iBankSessionManager.sessionID,
                                     @"username" : self.LoginTextField.stringValue,
                                     @"password" : self.PasswordTextField.stringValue,
                                     @"clientId" : [@(iBankSessionManager.CurrentEditableUserID) stringValue]
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
                                                                                            
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Аккаунт успешно добавлен"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@"%@", [(NSDictionary *)responseObject valueForKey:@"message"]];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];

}
@end
