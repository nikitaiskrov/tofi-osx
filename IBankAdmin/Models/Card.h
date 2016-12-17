//
//  Card.h
//  IBankAdmin
//
//  Created by Никита Искров on 11.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSInteger AccountID;
@property (readwrite, nonatomic) BOOL IsBlocked;
@property (readwrite, nonatomic) NSString *BlockExpiredAt;
@property (readwrite, nonatomic) NSString *CreatedAt;
@property (readwrite, nonatomic) NSString *LastFourNumbers;
@property (readwrite, nonatomic) NSString *ExpiredAt;
@property (readwrite, nonatomic) NSString *OwnerName;
@property (readwrite, nonatomic) NSString *CashAmountLimit;
@property (readwrite, nonatomic) NSString *CashAttemptsLimit;
@property (readwrite, nonatomic) NSString *CashlessAmountLimit;
@property (readwrite, nonatomic) NSString *CashlessAttemptsLimit;
@property (readwrite, nonatomic) NSString *CardType;


- (id)initWIthDictionary:(NSDictionary *)dictionary;

@end
