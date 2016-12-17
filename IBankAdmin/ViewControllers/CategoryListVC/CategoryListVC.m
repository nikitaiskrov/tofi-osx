//
//  CategoryListVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 16.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "CategoryListVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "Category.h"
#import "DJProgressHUD.h"
#import "MyCustomAnimator.h"
#import "UserEdit.h"
#import "LoginVC.h"

@interface CategoryListVC ()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *mainWindowRootController;
    
    NSInteger lastSelectedRowIndex;
}

@end

@implementation CategoryListVC

- (void)viewDidLoad {
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
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetCategoriesList parameterID:-1];
    
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
                                              
                                              NSArray *categoriesFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"categories"];
                                              [iBankSessionManager.Categories removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < categoriesFromServer.count; i++)
                                              {
                                                  Category *category = [[Category alloc] initWIthDictionary:(NSDictionary *)categoriesFromServer[i]];
                                                  
                                                  [iBankSessionManager.Categories addObject:category];
                                              }
                                              
                                              [self.TableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];
}



#pragma mark - TableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.TableView)
    {
        return iBankSessionManager.Categories.count;
    }
    
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableView == self.TableView)
    {
        Category *category = [iBankSessionManager.Categories objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:category.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return category.Name;
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return category.CreatedAt;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return category.UpdatedAt;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
        lastSelectedRowIndex = [[notification object] selectedRow];
        iBankSessionManager.CurrentEditableCategoryID = ((Category *)iBankSessionManager.Categories[lastSelectedRowIndex]).ID;
    
        NSStoryboard *sb = [self storyboard];
        id animator = [[MyCustomAnimator alloc] init];
        NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"OrganizationAddVC"];
    
        if (mainWindowRootController == nil)
        {
            mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
        }
    
        [mainWindowRootController presentViewController:userEdit animator:animator];
}


- (IBAction)BackButtonOnClick:(id)sender
{
    NSStoryboard *sb = [self storyboard];
    id animator = [[MyCustomAnimator alloc] init];
    NSViewController *userEdit = [sb instantiateControllerWithIdentifier:@"OrganizationsListVC"];
    
    if (mainWindowRootController == nil)
    {
        mainWindowRootController = ((LoginVC *)[[NSApplication sharedApplication] mainWindow].contentViewController).MainWindowController;
    }
    
    [mainWindowRootController presentViewController:userEdit animator:animator];

}
@end
