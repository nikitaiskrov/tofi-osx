//
//  PaymentOptionEditVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PaymentOptionEditVC : NSViewController

@property (weak) IBOutlet NSTextField *NameTextField;
@property (weak) IBOutlet NSTextField *TypeTextField;
@property (weak) IBOutlet NSTextField *ActionDescriptionTextField;
@property (weak) IBOutlet NSTextField *DescriptionTextField;
@property (weak) IBOutlet NSPopUpButton *PopUpButton;

- (IBAction)BackButtonOnClick:(id)sender;
- (IBAction)SaveButtonOnClick:(id)sender;
- (IBAction)DeleteButtonOnClick:(id)sender;
- (IBAction)TypeButtonSelectedIndexDidChange:(id)sender;

@end
