//
//  BankAccountList.h
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BankAccountListVC : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;
@property (weak) IBOutlet NSPopUpButton *PopUp;


- (IBAction)AddNewBankAccountButtonOnClick:(id)sender;
- (IBAction)PopUpMenuSelectedItemDidChange:(id)sender;
- (IBAction)BackButtonOnClick:(id)sender;

@end
