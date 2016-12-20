//
//  PaymentOptionEditVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "PaymentOptionEditVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "PaymentOption.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface PaymentOptionEditVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    PaymentOption *option;
    NSInteger currentSelectedTypeIndex;
}

@end

@implementation PaymentOptionEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self PrepareTextFields];
}


- (void)PrepareTextFields
{
    option = nil;
    for (NSInteger i = 0; i < iBankSessionManager.PaymentOptions.count; i++)
    {
        if (((PaymentOption *)iBankSessionManager.PaymentOptions[i]).ID == iBankSessionManager.CurrentEditablePaymentOptionID)
        {
            option = ((PaymentOption *)iBankSessionManager.PaymentOptions[i]);
            break;
        }
    }

    self.NameTextField.stringValue = option.FieldID;
    self.ActionDescriptionTextField.stringValue = option.ActionDescription;
    self.DescriptionTextField.stringValue = option.Description;
//    self.PopUpButton.selectedTag = [self IndexByText:option.Type];
}


- (void)SwitchViewControllers
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"PaymentOptionListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (NSInteger)IndexByText:(NSString *)type
{
    NSInteger index = 0;
    
    if ([type isEqual:@"none"])
    {
        index = 0;
    }
    else if ([type isEqual:@"phone"])
    {
        index = 1;
    }
    else if ([type isEqual:@"number"])
    {
        index = 2;
    }
    else if ([type isEqual:@"email"])
    {
        index = 3;
    }
    
    return index;
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



#pragma mark - Button Acitons

- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"PaymentOptionListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (IBAction)SaveButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:UpdatePaymetOption parameterID:option.ID];
    NSDictionary *parameters = @{
                                 @"session": iBankSessionManager.sessionID,
                                 @"option":
                                     @{
                                         @"field": self.NameTextField.stringValue,
                                         @"type" :  [self TypeByIndex:currentSelectedTypeIndex],
                                         @"actionDescription" :self.ActionDescriptionTextField.stringValue,
                                         @"description" : self.DescriptionTextField.stringValue
                                         }
                                 };
    
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
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
                                              
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Платежная опция успешно обновлена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];

}

- (IBAction)DeleteButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:DeletePaymentOption parameterID:option.ID];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:URLString parameters:nil error:nil];
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
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Платежная опция успешно удалена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                              
                                              [self SwitchViewControllers];
                                          }
                                      }];
    
    [dataTask resume];
}

- (IBAction)TypeButtonSelectedIndexDidChange:(id)sender
{
    currentSelectedTypeIndex = [sender indexOfSelectedItem];
}
@end
