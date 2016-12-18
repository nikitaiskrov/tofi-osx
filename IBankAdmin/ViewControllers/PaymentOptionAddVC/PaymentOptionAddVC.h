//
//  PaymentOptionAddVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PaymentOptionAddVC : NSViewController

@property (weak) IBOutlet NSTextField *NameTextField;
@property (weak) IBOutlet NSTextField *TypeTextField;
@property (weak) IBOutlet NSTextField *ActionDescriptionTextField;
@property (weak) IBOutlet NSTextField *DescriptionTextField;

- (IBAction)BackButtonOnClick:(id)sender;
- (IBAction)AddButtonOnCLick:(id)sender;
- (IBAction)TypeButtonSelectedItemDidChange:(id)sender;

@end
