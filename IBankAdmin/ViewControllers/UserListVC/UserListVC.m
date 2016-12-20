//
//  UserListVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 31.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "UserListVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "User.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface UserListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}

@end



@implementation UserListVC

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];

    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetUsersList parameterID:-1];
    
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
              
              NSArray *usersFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"clients"];
              [iBankSessionManager.Users removeAllObjects];
              
              for (NSInteger i = 0; i < usersFromServer.count; i++)
              {
                  User *user = [[User alloc] initWIthDictionary:(NSDictionary *)usersFromServer[i]];
                  
                  [iBankSessionManager.Users addObject:user];
              }

              [self.TableView reloadData];
          }
      }];
    
    [dataTask resume];
    

}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.TableView)
    {
        return iBankSessionManager.Users.count;
    }
    
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == self.TableView)
    {
        User *user = [iBankSessionManager.Users objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:user.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return user.SecondName;
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return user.FirstName;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return user.MiddleName;
        }
        else if ([tableView tableColumns][4] == tableColumn)
        {
            return user.PhoneNumber;
        }
        else if ([tableView tableColumns][5] == tableColumn)
        {
            return user.PassportNumber;
        }
        else if ([tableView tableColumns][6] == tableColumn)
        {
            return user.Nationality;
        }
        else if ([tableView tableColumns][7] == tableColumn)
        {
            return user.Birthday;
        }
        else if ([tableView tableColumns][8] == tableColumn)
        {
            return user.Sex;
        }
        else if ([tableView tableColumns][9] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:user.Identification];
        }
        else if ([tableView tableColumns][10] == tableColumn)
        {
            return user.PlaceOfBirth;
        }
        else if ([tableView tableColumns][11] == tableColumn)
        {
            return user.PassportDateIssuse;
        }
        else if ([tableView tableColumns][12] == tableColumn)
        {
            return user.PassportDateExpiry;
        }
        else if ([tableView tableColumns][13] == tableColumn)
        {
            return user.Authority;
        }
        else if ([tableView tableColumns][14] == tableColumn)
        {
            return user.CreatedAt;
        }
        else if ([tableView tableColumns][15] == tableColumn)
        {
            return user.UpdatedAt;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger index = [[notification object] selectedRow];
    if (index >= 0)
    {
        lastSelectedRowIndex = index;
        iBankSessionManager.CurrentEditableUserID = ((User *)iBankSessionManager.Users[lastSelectedRowIndex]).ID;
        
        NSStoryboard *sb = [self storyboard];
        id animator = [[MyCustomAnimator alloc] init];
        NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"UserEdit"];
        
        if (mainWindowRootController == nil)
        {
            mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
        }
        
        [mainWindowRootController presentViewController:userEdit animator:animator];
    }
}


- (IBAction)AddNewClientButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"ClientAddVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = [[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];
}


@end
