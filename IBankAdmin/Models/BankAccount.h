//
//  BankAccount.h
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OwnerType
{
    User,
    Organization
} OwnerType;


@interface BankAccount : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSInteger OwnerID;
@property (readwrite, nonatomic) OwnerType OwnerType;
@property (readwrite, nonatomic) NSInteger Number;
@property (readwrite, nonatomic) BOOL IsBlocked;
@property (readwrite, nonatomic) NSString *BlockExpiredAt;
@property (readwrite, nonatomic) NSString *CreatedAt;
@property (readwrite, nonatomic) NSString *UpdatedAt;
@property (readwrite, nonatomic) float Balance;
@property (readwrite, nonatomic) NSString *Currency;


- (id)initWIthDictionary:(NSDictionary *)dictionary;

@end
