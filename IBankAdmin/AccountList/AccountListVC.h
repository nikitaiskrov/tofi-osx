//
//  AccountListVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AccountListVC : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;

@end
