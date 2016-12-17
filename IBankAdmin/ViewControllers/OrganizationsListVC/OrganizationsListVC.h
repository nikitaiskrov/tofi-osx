//
//  OrganizationsListVC.h
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OrganizationsListVC : NSViewController

@property (weak) IBOutlet NSTableView *TableView;
- (IBAction)AddOrganizationButtonOnClick:(id)sender;

@end
