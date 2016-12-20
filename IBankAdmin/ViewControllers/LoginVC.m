//
//  LoginVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 30.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "LoginVC.h"
#import "AFNetworking.h"
#import "IBankSessionManager.h"
#import "UserListVC.h"
#import "DJProgressHUD.h"
#import "WindowController.h"

@implementation LoginVC
{
}

@synthesize MainWindowController;
@synthesize Window;


#pragma mark - ViewContoroller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}



#pragma mark - Actions

- (IBAction)AutorizationButtonOnClick:(NSButton *)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];

    IBankSessionManager *iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:SignIn parameterID:-1];
    NSDictionary *parameters = @{
                                    @"username": self.LoginTextField.stringValue,
                                    @"password": self.PasswordTextField.stringValue
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
            
            [alert runModal];
        }
        else
        {
            [DJProgressHUD dismiss];
            
            NSLog(@"%@ %@", response, responseObject);
            iBankSessionManager.sessionID = [(NSDictionary *)responseObject valueForKey:@"session"];
            NSLog(@"%@", iBankSessionManager.sessionID);
            
            //======
            NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
//             self.MainWindowController = [sb instantiateControllerWithIdentifier:@"MainWindowController"];
//            [self presentViewControllerAsSheet:self.MainWindowController];
//            [self presentViewControllerAsModalWindow:self.MainWindowController];
            
//MainWindow
            
            self.Window = [sb instantiateControllerWithIdentifier:@"MainWindow111"]; // instantiate your window controller
            [Window showWindow:self]; // show the window
            [self.view.window close];
            //======
        }
    }];
    
    [dataTask resume];
}


@end
