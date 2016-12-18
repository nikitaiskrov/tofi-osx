//
//  CardInfoEditVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 11.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CardInfoEditVC : NSViewController

@property (weak) IBOutlet NSTextField *OwnerNameTextField;
@property (weak) IBOutlet NSTextField *FirstLimitTextField;
@property (weak) IBOutlet NSTextField *SecondLimitTextField;
@property (weak) IBOutlet NSTextField *ThirdLimitTextField;
@property (weak) IBOutlet NSTextField *FourLimitTextField;
@property (weak) IBOutlet NSButton *CardInfoButton;

@property (weak) IBOutlet NSTextField *StatusLabel;
@property (weak) IBOutlet NSTextField *BlockDateLabel;
@property (weak) IBOutlet NSTextField *BlockOnHoursTextField;
@property (weak) IBOutlet NSButton *ChangeStatusButton;

- (IBAction)CartTypePopUpButtonChange:(id)sender;
- (IBAction)CardInfoSaveChangesButonOnClick:(id)sender;
- (IBAction)CardLimitsSaveChangesButtonOnClick:(id)sender;
- (IBAction)BackButtonOnClick:(id)sender;
- (IBAction)BlockButtonOnClick:(id)sender;

@end
