//
//  CategoryListVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 16.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CategoryListVC : NSViewController

@property (weak) IBOutlet NSTableView *TableView;

- (IBAction)BackButtonOnClick:(id)sender;

@end
