//
//  Account.h
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSInteger ClientID;
@property (readwrite, nonatomic) NSString *Username;
@property (readwrite, nonatomic) NSString *Role;
@property (readwrite, nonatomic) NSString *IsBlockedString;
@property (readwrite, nonatomic) BOOL IsBlocked;
@property (readwrite, nonatomic) BOOL DateIsNull;
@property (readwrite, nonatomic) NSDate *BlockedDate;
@property (readwrite, nonatomic) NSDate *CreatedAt;
@property (readwrite, nonatomic) NSDate *UpdatedAt;

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
