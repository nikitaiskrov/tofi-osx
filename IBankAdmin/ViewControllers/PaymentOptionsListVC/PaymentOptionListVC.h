//
//  PaymentOptionListVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 17.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PaymentOptionListVC : NSViewController

@property (weak) IBOutlet NSTableView *TableView;

- (IBAction)AddPaymentOptionButtonOnClick:(id)sender;

@end
