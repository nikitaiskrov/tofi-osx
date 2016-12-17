//
//  CategoryAddVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 16.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CategoryAddVC : NSViewController

@property (weak) IBOutlet NSTextField *NameTextField;

- (IBAction)AddButtonOnClick:(id)sender;
- (IBAction)BackButtonOnClick:(id)sender;

@end
