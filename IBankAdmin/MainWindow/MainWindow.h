//
//  MainWindow.h
//  IBankAdmin
//
//  Created by Nikita on 29/11/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSViewController

@property (weak) IBOutlet NSView *ContentView;
@property (weak) NSViewController *CurrentChildViewController;
- (IBAction)ClientsListButtonOnClick:(id)sender;
- (IBAction)AccountsListButtonOnClick:(id)sender;
- (IBAction)LogsButtonOnClick:(id)sender;
- (IBAction)QuitButtonOnClick:(id)sender;

@end
