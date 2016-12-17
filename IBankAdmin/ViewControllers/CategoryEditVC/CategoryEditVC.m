//
//  CategoryEditVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 17.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "CategoryEditVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "LoginVC.h"
#import "Category.h"
#import "Organization.h"

@interface CategoryEditVC ()
{
    NSViewController *mainWindowRootController;
    IBankSessionManager *iBankSessionManager;
    Category *category;
    NSInteger lastSelectedRowIndex;
}
@end

@implementation CategoryEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [self PrepareTextFields];
    
    [self FetchOrganizations];
}


- (void)PrepareTextFields
{
    if (iBankSessionManager.Categories.count > 0 && iBankSessionManager.CurrentEditableCategoryID != -1)
    {
        category = nil;
        for (NSInteger i = 0; i < iBankSessionManager.Categories.count; i++)
        {
            if (((Category *)iBankSessionManager.Categories[i]).ID == iBankSessionManager.CurrentEditableCategoryID)
            {
                category = ((Category *)iBankSessionManager.Categories[i]);
                break;
            }
        }
    }
    
    if (category != nil)
    {
        self.NameTextField.stringValue = category.Name;
    }
}

- (void)SwitchViewControllers
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"CategoryListMainVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (void)FetchOrganizations
{
    [super viewWillAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetOrganizationListWithCategoryID parameterID:iBankSessionManager.CurrentEditableCategoryID];
    
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
                                              
                                              NSArray *organizationsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"organizations"];
                                              [iBankSessionManager.Organizations removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < organizationsFromServer.count; i++)
                                              {
                                                  Organization *organization = [[Organization alloc] initWIthDictionary:(NSDictionary *)organizationsFromServer[i]];
                                                  
                                                  [iBankSessionManager.Organizations addObject:organization];
                                              }
                                              
                                              [self.TableView reloadData];
                                              [DJProgressHUD dismiss];
                                          }
                                      }];
    
    [dataTask resume];

}



#pragma mark - TableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.TableView)
    {
        return iBankSessionManager.Organizations.count;
    }
    
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == self.TableView)
    {
        Organization *organization = [iBankSessionManager.Organizations objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return organization.Name;
        }
    }
    
    return  nil;
}



#pragma mark - Button Actions

- (IBAction)BackButtonOnClick:(id)sender
{
    [self SwitchViewControllers];
}


- (IBAction)SaveButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:UpdateCategory parameterID:category.ID];
    NSDictionary *parameters = @{
                                 @"session": iBankSessionManager.sessionID,
                                 @"category":
                                     @{
                                         @"name": self.NameTextField.stringValue,
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
                                              
                                              iBankSessionManager.CurrentEditableUserID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Категория успешно изменена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                          }
                                      }];
    
    [dataTask resume];
}


- (IBAction)DeleteCurrentCategoryButtonOnClick:(id)sender
{
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:DeleteCategory parameterID:category.ID];
    
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
                                              
                                              NSLog(@"%@ %@", response, responseObject);
                                              
                                              iBankSessionManager.CurrentEditableUserID = [[(NSDictionary *)responseObject valueForKey:@"createdId"] integerValue];
                                              NSAlert *alert = [NSAlert alertWithMessageText:@"Категория успешно удалена"
                                                                               defaultButton:@"OK" alternateButton:nil
                                                                                 otherButton:nil
                                                                   informativeTextWithFormat:@""];
                                              alert.alertStyle = NSAlertStyleInformational;
                                              
                                              [alert runModal];
                                              
                                              [DJProgressHUD dismiss];
                                              
                                              [self SwitchViewControllers];
                                          }
                                      }];
    
    [dataTask resume];
}
@end
