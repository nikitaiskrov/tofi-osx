//
//  CreateBankAccountVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BankAccountVC : NSViewController
@property (weak) IBOutlet NSTextField *IDLabel;
@property (weak) IBOutlet NSTextField *OwnerIDLabel;
@property (weak) IBOutlet NSTextField *OwnerTypeLabel;
@property (weak) IBOutlet NSTextField *NumberLabel;
@property (weak) IBOutlet NSTextField *StatusLabel;
@property (weak) IBOutlet NSTextField *DateBlockedLabel;
@property (weak) IBOutlet NSTextField *DateCreateLabel;
@property (weak) IBOutlet NSTextField *DateUpdateLabel;
@property (weak) IBOutlet NSTextField *BallanceLabel;
@property (weak) IBOutlet NSTextField *CurrencyLabel;

@property (weak) IBOutlet NSTextField *IDInfoLabel;
@property (weak) IBOutlet NSTextField *OwnerIDInfoLabel;
@property (weak) IBOutlet NSTextField *OwnerTypeInfoLabel;
@property (weak) IBOutlet NSTextField *NumberInfoLabel;
@property (weak) IBOutlet NSTextField *StatusInfoLabel;
@property (weak) IBOutlet NSTextField *DateBlockedInfoLabel;
@property (weak) IBOutlet NSTextField *DateCreateInfoLabel;
@property (weak) IBOutlet NSTextField *DateUpdateInfoLabel;
@property (weak) IBOutlet NSTextField *BallanceInfoLabel;
@property (weak) IBOutlet NSTextField *CurrencyInfoLabel;

@property (weak) IBOutlet NSTextField *CardsLabel;
@property (weak) IBOutlet NSTableView *CardsTableView;
@property (weak) IBOutlet NSButton *ChangeStatusButton;
@property (weak) IBOutlet NSTextField *ChangeStatusTextField;

@property (weak) IBOutlet NSTextField *AddCashTextField;

- (IBAction)BlockBankAccoundButtonOnClick:(id)sender;
- (IBAction)AddCardButtonOnClick:(id)sender;
- (IBAction)AddCashButtonOnClick:(id)sender;
- (IBAction)BackButtonOnClick:(id)sender;

@end
