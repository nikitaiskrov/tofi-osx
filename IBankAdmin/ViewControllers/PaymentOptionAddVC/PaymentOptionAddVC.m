//
//  PaymentOptionAddVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "PaymentOptionAddVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "PaymentOption.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface PaymentOptionAddVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    NSInteger currentSelectedTypeIndex;
}

@end

@implementation PaymentOptionAddVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (NSString *)TypeByIndex:(NSInteger)index
{
    NSString *result = @"";
    
    switch (index)
    {
        case 0:
            result = @"none";
            break;
        case 1:
            result = @"phone";
            break;
        case 2:
            result = @"number";
            break;
        case 3:
            result = @"email";
            break;
        default:
            break;
    }
    
    return result;
}


#pragma mark - Buttons Actions

- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"PaymentOptionListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (IBAction)AddButtonOnCLick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:CreatePaymetOption parameterID:-1];
    NSDictionary *parameters = @{
                                 @"session": iBankSessionManager.sessionID,
                                 @"option":
                                     @{
                                         @"field": self.NameTextField.stringValue,
                                         @"type" : [self TypeByIndex:currentSelectedTypeIndex],
                                         @"actionDescription" :self.ActionDescriptionTextField.stringValue,
                                         @"description" : self.DescriptionTextField.stringValue
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
                                              
                                              iBankSessionManager.CurrentEditableUserID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Платежная опция успешно добавлена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];
}


- (IBAction)TypeButtonSelectedItemDidChange:(id)sender
{
    currentSelectedTypeIndex = [sender indexOfSelectedItem];
}
@end
