//
//  IBankSessionManager.m
//  IBankAdmin
//
//  Created by Никита Искров on 30.10.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "IBankSessionManager.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonHMAC.h>



@interface IBankSessionManager()


@end


@implementation IBankSessionManager

@synthesize serverURL;
@synthesize sessionID;
@synthesize Users;
@synthesize Accounts;
@synthesize Logs;
@synthesize Cards;
@synthesize BankAccounsts;
@synthesize Organizations;
@synthesize Categories;
@synthesize PaymentOptions;
@synthesize CurrentEditableUserID;
@synthesize CurrentEditableAccountID;
@synthesize CurrentEditableBankAccountID;
@synthesize CurrentEditableCardID;
@synthesize CurrentEditableOrganizationID;
@synthesize CurrentEditableCategoryID;
@synthesize CurrentEditablePaymentOption;


#pragma mark - init

+ (id)manager
{
    static IBankSessionManager *sharedIBankSessionManager = nil;
    
    @synchronized(self)
    {
        if (sharedIBankSessionManager == nil)
        sharedIBankSessionManager = [[self alloc] init];
    }
    
    return sharedIBankSessionManager;
}


- (id)init
{
    if (self = [super init])
    {
        Users = [NSMutableArray array];
        Accounts = [NSMutableArray array];
        Logs = [NSMutableArray array];
        BankAccounsts = [NSMutableArray array];
        Cards = [NSMutableArray array];
        Organizations = [NSMutableArray array];
        Categories = [NSMutableArray array];
        PaymentOptions = [NSMutableArray array];
        
        serverURL = @"https://tofi-project.eu-gb.mybluemix.net";
    }
    
    return self;
}


- (NSString *)GetURLWithRequestType:(RequestType)requestType parameterID:(NSInteger)ID
{
    NSString *result = serverURL;
    
    switch (requestType)
    {
        case SignIn:
            result = [result stringByAppendingString:@"/signin"];
            break;
            
        case SignUp:
            result = [result stringByAppendingString:@"/signup"];
            break;
            
        case GetUsersList:
            result = [result stringByAppendingFormat:@"/clients?session=%@", self.sessionID];
            break;
            
        case GetUserWithID:
            result = [result stringByAppendingFormat:@"/clients/%ld?session=%@", (long)ID, self.sessionID];
            break;
            
        case PutUserWithID:
            result = [result stringByAppendingFormat:@"/clients/%ld", (long)ID];
            break;
            
        case GetAccountList:
            result = [result stringByAppendingFormat:@"/accounts/?session=%@", self.sessionID];
            break;
            
        case CreateClient:
            result = [result stringByAppendingString:@"/clients"];
            break;
            
        case CreateAccount:
            result = [result stringByAppendingString:@"/signup"];
            break;
            
        case GetAllLogs:
            result = [result stringByAppendingFormat:@"/logs/users/?session=%@&dateType=year&startDate=2016-10-18", self.sessionID];
            break;
            
        case ChangeAccountStatus:
            result = [result stringByAppendingString:@"/admin/users/"];
            break;
            
        case GetBankAccountsWithOwnerID:
            result = [result stringByAppendingFormat:@"/bank/user/accounts/%ld?session=%@", (long)ID, self.sessionID];
            break;
            
        case CreateBankAccount:
            result = [result stringByAppendingString:@"/bank/accounts"];
            break;
            
        case ChangeBankAccountStatus:
            result = [result stringByAppendingString:@"/admin/bank/accounts/"];
            break;
            
        case GetAllCardsForAccount:
            result = [result stringByAppendingFormat:@"/cards/bank/accounts/%ld?session=%@", (long)ID, self.sessionID];
            break;
            
        case CreateEnrollment:
            result = [result stringByAppendingString:@"/payments/enrollment/make"];
            break;
            
        case CreateCard:
            result = [result stringByAppendingString:@"/cards"];
            break;
            
        case CreateCardInfo:
            result = [result stringByAppendingString:@"/card/info"];
            break;
            
        case CreateCardLimits:
            result = [result stringByAppendingString:@"/card/limits"];
            break;
            
        case GetOrganizationsList:
            result = [result stringByAppendingFormat:@"/organizations/?session=%@", self.sessionID];
            break;
            
        case CreateOrganization:
            result = [result stringByAppendingString:@"/organizations"];
            break;
            
        case UpdateOrganization:
            result = [result stringByAppendingFormat:@"/organizations/%ld", (long)ID];
            break;
            
        case GetCategoriesList:
            result = [result stringByAppendingFormat:@"/categories/?session=%@", self.sessionID];
            break;
            
        case UpdateCategory:
            result = [result stringByAppendingFormat:@"/categories/%ld", (long)ID];
            break;
            
        case CreateCategory:
            result = [result stringByAppendingString:@"/categories"];
            break;
            
        case DeleteCategory:
            result = [result stringByAppendingFormat:@"/categories/%ld?session=%@", (long)ID, self.sessionID];
            break;
            
        case GetPaymentOptionsList:
            result = [result stringByAppendingFormat:@"/payments/options?session=%@", self.sessionID];
            break;
    }
    
    return result;
}

- (NSDateFormatter *)FGetFullDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

- (NSDateFormatter *)GetDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

@end


