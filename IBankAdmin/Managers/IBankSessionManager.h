//
//  IBankSessionManager.h
//  IBankAdmin
//
//  Created by Никита Искров on 30.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum RequestType
{
    SignIn,
    SignUp,
    GetUsersList,
    GetUserWithID,
    PutUserWithID,
    GetAccountList,
    GetAccountWithID,
    CreateClient,
    CreateAccount,
    GetAllLogs,
    ChangeAccountStatus,
    GetBankAccountsWithOwnerID,
    CreateBankAccount,
    ChangeBankAccountStatus,
    GetAllCardsForAccount,
    GetCardWithID,
    CreateEnrollment,
    CreateCard,
    CreateCardInfo,
    CreateCardLimits,
    UpdateCardLimits,
    ChageCardStatus,
    GetOrganizationsList,
    GetOrganizationListWithCategoryID,
    CreateOrganization,
    UpdateOrganization,
    DeleteOrganization,
    GetCategoriesList,
    CreateCategory,
    UpdateCategory,
    DeleteCategory,
    GetPaymentOptionsList,
    CreatePaymetOption,
    UpdatePaymetOption,
    DeletePaymentOption
} RequestType;


@interface IBankSessionManager : NSObject

@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) NSString *sessionID;

@property (nonatomic, strong) NSMutableArray *Users;
@property (nonatomic, assign) NSInteger CurrentEditableUserID;

@property (nonatomic, strong) NSMutableArray *Accounts;
@property (nonatomic, assign) NSInteger CurrentEditableAccountID;

@property (nonatomic, strong) NSMutableArray *Logs;

@property (nonatomic, strong) NSMutableArray *BankAccounsts;
@property (nonatomic, assign) NSInteger CurrentEditableBankAccountID;

@property (nonatomic, strong) NSMutableArray *Cards;
@property (nonatomic, assign) NSInteger CurrentEditableCardID;

@property (nonatomic, strong) NSMutableArray *Organizations;
@property (nonatomic, assign) NSInteger CurrentEditableOrganizationID;

@property (nonatomic, strong) NSMutableArray *Categories;
@property (nonatomic, assign) NSInteger CurrentEditableCategoryID;

@property (nonatomic, strong) NSMutableArray *PaymentOptions;
@property (nonatomic, assign) NSInteger CurrentEditablePaymentOptionID;

+ (id)manager;

- (NSString *)GetURLWithRequestType:(RequestType)requestType parameterID:(NSInteger)clientID;
- (NSDateFormatter *)GetFullDateFormatter;
- (NSDateFormatter *)GetDateFormatter;

@end
