//
//  LogsVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 27.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogsVC : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;

@end
