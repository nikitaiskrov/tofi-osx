//
//  UserListVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 31.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UserListVC : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;
- (IBAction)AddNewClientButtonOnClick:(id)sender;

@end
