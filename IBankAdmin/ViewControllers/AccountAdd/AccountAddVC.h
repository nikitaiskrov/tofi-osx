//
//  AccountAddVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AccountAddVC : NSViewController

@property (weak) IBOutlet NSTextField *LoginLabel;
@property (weak) IBOutlet NSTextField *PasswordLabel;

@property (weak) IBOutlet NSTextField *LoginTextField;
@property (weak) IBOutlet NSTextField *PasswordTextField;

- (IBAction)SaveButtonOnClick:(NSButton *)sender;

@end
