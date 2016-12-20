//
//  MainWindow.m
//  IBankAdmin
//
//  Created by Nikita on 29/11/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "MainWindow.h"
#import "MyCustomAnimator.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "User.h"
#import "Account.h"
#import "DJProgressHUD.h"

@interface MainWindow ()
{
    IBankSessionManager *iBankSessionManager;
}

@end

@implementation MainWindow

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
//    self.view.window.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask;
//    self.view.size =  NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
//    [self setPreferredContentSize:self.view.frame.size];
    self.preferredContentSize = self.view.frame.size;

    [self fetchAccounts];
}


- (void)viewDidAppear
{
    [self setPreferredContentSize:self.view.frame.size];
    //    self.view.window.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask;
    //    self.view.size =  NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
}



- (void)fetchClients
{
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetUsersList parameterID:-1];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          if (error)
                                          {
                                          }
                                          else
                                          {
                                              NSArray *usersFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"clients"];
                                              [iBankSessionManager.Users removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < usersFromServer.count; i++)
                                              {
                                                  User *user = [[User alloc] initWIthDictionary:(NSDictionary *)usersFromServer[i]];
                                                  
                                                  [iBankSessionManager.Users addObject:user];
                                              }
                                          }
                                      }];
    
    [dataTask resume];

}


- (void)fetchAccounts
{
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetAccountList parameterID:-1];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          if (error)
                                          {
                                          }
                                          else
                                          {
                                              NSArray *accountsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"users"];
                                              [iBankSessionManager.Accounts removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < accountsFromServer.count; i++)
                                              {
                                                  Account *account = [[Account alloc] initWIthDictionary:(NSDictionary *)accountsFromServer[i]];
                                                  
                                                  [iBankSessionManager.Accounts addObject:account];
                                              }
                                              
                                              [self fetchClients];
                                          }
                                      }];
    
    [dataTask resume];

}


- (IBAction)ClientsListButtonOnClick:(id)sender
{
//    NSStoryboard *sb = [self storyboard];
//    id animator = [[MyCustomAnimator alloc] init];
//    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserListVC"];
//    
//    [self presentViewController:userEdit animator:animator];
}

- (IBAction)AccountsListButtonOnClick:(id)sender
{
//    NSStoryboard *sb = [self storyboard];
//    id animator = [[MyCustomAnimator alloc] init];
//    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"AccountListVC"];
//    
//    [self presentViewController:userEdit animator:animator];
}

- (IBAction)LogsButtonOnClick:(id)sender
{
//    NSStoryboard *sb = [self storyboard];
//    id animator = [[MyCustomAnimator alloc] init];
//    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@""];
//    
//    [self presentViewController:userEdit animator:animator];
}

- (IBAction)QuitButtonOnClick:(id)sender
{
    for (NSWindow *window in [NSApplication sharedApplication].windows)
    {
        [window close];
    }
    
    [NSApp terminate:self];
}
@end
