//
//  CategoryEditVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 17.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CategoryEditVC : NSViewController

@property (weak) IBOutlet NSTextField *NameTextField;
@property (weak) IBOutlet NSTableView *TableView;

- (IBAction)BackButtonOnClick:(id)sender;
- (IBAction)SaveButtonOnClick:(id)sender;
- (IBAction)DeleteCurrentCategoryButtonOnClick:(id)sender;

@end
