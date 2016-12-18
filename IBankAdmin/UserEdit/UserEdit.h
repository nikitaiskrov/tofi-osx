//
//  UserEdit.h
//  IBankAdmin
//
//  Created by Никита Искров on 05.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UserEdit : NSViewController

@property (weak) IBOutlet NSTextField *IDLabel;
@property (weak) IBOutlet NSTextField *LastNameLabel;
@property (weak) IBOutlet NSTextField *FirstNameLabel;
@property (weak) IBOutlet NSTextField *MiddleNameLabel;
@property (weak) IBOutlet NSTextField *PhoneLabel;
@property (weak) IBOutlet NSTextField *PassportLabel;
@property (weak) IBOutlet NSTextField *NationalityLabel;
@property (weak) IBOutlet NSTextField *BirthdayLabel;
@property (weak) IBOutlet NSTextField *SexLabel;
@property (weak) IBOutlet NSTextField *IdentificationLabel;
@property (weak) IBOutlet NSTextField *PlaceOfBirthLabel;
@property (weak) IBOutlet NSTextField *DateOfIssueLabel;
@property (weak) IBOutlet NSTextField *DateOfExpirationLabel;
@property (weak) IBOutlet NSTextField *AuthorityLabel;
@property (weak) IBOutlet NSTextField *DateAddedLabel;
@property (weak) IBOutlet NSTextField *DateUpdateLabel;

@property (weak) IBOutlet NSTextField *IDTextField;
@property (weak) IBOutlet NSTextField *LastNameTextField;
@property (weak) IBOutlet NSTextField *FirstNameTextField;
@property (weak) IBOutlet NSTextField *MiddleNameTextField;
@property (weak) IBOutlet NSTextField *PhoneTextField;
@property (weak) IBOutlet NSTextField *PassportTextField;
@property (weak) IBOutlet NSTextField *NationalityTextField;
@property (weak) IBOutlet NSTextField *BirthdayTextField;
@property (weak) IBOutlet NSTextField *SexTextField;
@property (weak) IBOutlet NSTextField *IdentificationTextField;
@property (weak) IBOutlet NSTextField *PlaceOfBirthTextField;
@property (weak) IBOutlet NSTextField *DateOfIssueTextField;
@property (weak) IBOutlet NSTextField *DateOfExpirationTextField;
@property (weak) IBOutlet NSTextField *AuthorityTextField;
@property (weak) IBOutlet NSTextField *DateAddedTextField;
@property (weak) IBOutlet NSTextField *DateUpdateTextField;


@property (weak) IBOutlet NSTextField *LoginLabel;
@property (weak) IBOutlet NSTextField *PasswordLabel;
@property (weak) IBOutlet NSTextField *NewPasswordLabel;
@property (weak) IBOutlet NSTextField *NewPasswordRepeatLabel;
@property (weak) IBOutlet NSTextField *StatusLabel;
@property (weak) IBOutlet NSTextField *StatusChangebleLabel;


@property (weak) IBOutlet NSTextField *LoginTextField;
@property (weak) IBOutlet NSTextField *PasswordTextField;
@property (weak) IBOutlet NSTextField *NewPasswordTextField;
@property (weak) IBOutlet NSTextField *NewPasswordRepeatTextField;

@property (weak) IBOutlet NSTextField *ChangeStatusTextField;
@property (weak) IBOutlet NSButton *ChangeStatusButton;
@property (weak) IBOutlet NSButton *BankAccountsButton;

- (IBAction)SaveButtonOnClic:(NSButton *)sender;
- (IBAction)ChangeStatusButtonOnClick:(id)sender;
- (IBAction)BankAccountsButtonOnClick:(id)sender;
- (IBAction)PopUpButtonSelectionDidChange:(id)sender;

@end
