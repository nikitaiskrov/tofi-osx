//
//  ClientAddVC.h
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ClientAddVC : NSViewController

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
@property (weak) IBOutlet NSTextField *SecretQuestionLabel;
@property (weak) IBOutlet NSTextField *SecretAnswerLabel;

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
@property (weak) IBOutlet NSTextField *SecretQuestionTextField;
@property (weak) IBOutlet NSTextField *SecretAnswerTextField;

- (IBAction)SaveButtonOnClick:(NSButton *)sender;
- (IBAction)BackButtonOnClick:(id)sender;

@end
