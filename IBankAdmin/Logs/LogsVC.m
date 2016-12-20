//
//  LogsVC.m
//  IBankAdmin
//
//  Created by Никита Искров on 27.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "LogsVC.h"
#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import "HistoryLog.h"
#import "DJProgressHUD.h"


@interface LogsVC()
{
    IBankSessionManager *iBankSessionManager;
    NSViewController *rootController;
    
    NSInteger lastSelectedRowIndex;
}

@end

@implementation LogsVC

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    if (lastSelectedRowIndex > 0)
    {
        [self.TableView deselectRow:lastSelectedRowIndex];
    }
    
//    if (rootController == nil)
//    {
//        rootController = (NSViewController *)[[NSApplication sharedApplication] mainWindow].contentViewController;
//    }
    
    [DJProgressHUD showStatus:@"Загрузка" FromView:self.view];
    
    iBankSessionManager = [IBankSessionManager manager];
    NSString *URLString = [iBankSessionManager GetURLWithRequestType:GetAllLogs parameterID:-1];
    
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
                                              
                                              NSArray *logsFromServer = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"logs"];
                                              [iBankSessionManager.Logs removeAllObjects];
                                              
                                              for (NSInteger i = 0; i < logsFromServer.count; i++)
                                              {
                                                  HistoryLog *account = [[HistoryLog alloc] initWIthDictionary:(NSDictionary *)logsFromServer[i]];
                                                  
                                                  [iBankSessionManager.Logs addObject:account];
                                              }
                                              
                                              [self.TableView reloadData];
                                          }
                                      }];
    
    [dataTask resume];
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (tableView == self.TableView) ? iBankSessionManager.Logs.count : 0;
}



- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.TableView)
    {
        HistoryLog *log = [iBankSessionManager.Logs objectAtIndex:row];
        
        if ([tableView tableColumns][0] == tableColumn)
        {
            return [NSNumber numberWithUnsignedInteger:log.ID];
        }
        else if ([tableView tableColumns][1] == tableColumn)
        {
            return (log.UserID == -1) ? @"-" : [NSNumber numberWithUnsignedInteger:log.UserID];
        }
        else if ([tableView tableColumns][2] == tableColumn)
        {
            return log.Type;
        }
        else if ([tableView tableColumns][3] == tableColumn)
        {
            return log.IP;
        }
        else if ([tableView tableColumns][4] == tableColumn)
        {
            return log.CountryCode;
        }
        else if ([tableView tableColumns][5] == tableColumn)
        {
            return log.CountryName;
        }
        else if ([tableView tableColumns][6] == tableColumn)
        {
            return log.RegionName;
        }
        else if ([tableView tableColumns][7] == tableColumn)
        {
            return log.City;
        }
        else if ([tableView tableColumns][8] == tableColumn)
        {
            return log.TimeZone;
        }
        else if ([tableView tableColumns][9] == tableColumn)
        {
            return log.Latitude;
        }
        else if ([tableView tableColumns][10] == tableColumn)
        {
            return log.Longitude;
        }
        else if ([tableView tableColumns][11] == tableColumn)
        {
            return log.CreatedAt;
        }
    }
    
    return  nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    //fix head select
//    iBankSessionManager.CurrentEditableAccountID = [[notification object] selectedRow];
//    lastSelectedRowIndex = [[notification object] selectedRow];
    
//    if (tabViewRootController == nil)
//    {
//        tabViewRootController = (NSTabViewController *)[[NSApplication sharedApplication] mainWindow].contentViewController;
//    }
//    
//    tabViewRootController.selectedTabViewItemIndex = 2;
}


@end
