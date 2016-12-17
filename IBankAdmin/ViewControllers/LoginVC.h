//
//  LoginVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 30.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindow.h"


@interface LoginVC : NSViewController

@property (weak) IBOutlet NSTextField *LoginTextField;
@property (weak) IBOutlet NSSecureTextField *PasswordTextField;
@property (weak) IBOutlet NSWindowController *TabBarWindowController;
@property (strong) MainWindow *MainWindowController;


- (IBAction)AutorizationButtonOnClick:(NSButton *)sender;

@end
