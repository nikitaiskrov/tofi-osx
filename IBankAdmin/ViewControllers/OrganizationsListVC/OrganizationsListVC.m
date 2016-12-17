//
//  OrganizationsListVC.m
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "OrganizationsListVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Organization.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface OrganizationsListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}

@end

@implementation OrganizationsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBankSessionManager = [IBankSessionManager manager];
}


- (void)viewWillAppear
{
    [super viewWillAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetOrganizationsList parameterID:-1];
    
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
            return [NSNumber numberWithUnsignedInteger:organization.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:organization.CategoryID];
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return organization.Name;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return organization.Address;
        }
        else if ([tableView tableColumns][4] == tableColumn)
        {
            return organization.Phone;
        }
        else if ([tableView tableColumns][5] == tableColumn)
        {
            return organization.CreatedAt;
        }
        else if ([tableView tableColumns][6] == tableColumn)
        {
            return organization.UpdatedAt;
        }
    }
    
    return  nil;
}



- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // fix head select
//    lastSelectedRowIndex = [[notification object] selectedRow];
//    iBankSessionManager.CurrentEditableUserID = ((User *)iBankSessionManager.Users[lastSelectedRowIndex]).ID;
//    
//    NSStoryboard *sb = [self storyboard];
//    id animator = [[MyCustomAnimator alloc] init];
//    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserEdit"];
//    
//    if (mainWindowRootController == nil)
//    {
//        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
//    }
//    
//    [mainWindowRootController presentViewController:userEdit animator:animator];
}



#pragma mark - Actions

- (IBAction)AddOrganizationButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"CategoryListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}
@end
