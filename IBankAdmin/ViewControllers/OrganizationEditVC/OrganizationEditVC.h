//
//  OrganizationEditVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 18.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OrganizationEditVC : NSViewController

@property (weak) IBOutlet NSTextField *NameTextField;
@property (weak) IBOutlet NSTextField *AddressTextField;
@property (weak) IBOutlet NSTextField *PhoneTextField;
@property (weak) IBOutlet NSTableView *TableView;

- (IBAction)UpdateOrganizationButtonOnClick:(id)sender;
- (IBAction)BackButtonOnClick:(id)sender;
- (IBAction)DeleteOrganizationButtonOnClick:(id)sender;

@end
