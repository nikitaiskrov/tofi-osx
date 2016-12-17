//
//  Card.m
//  IBankAdmin
//
//  Created by Никита Искров on 11.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.AccountID = [[dictionary valueForKey:@"accountId"] integerValue];
            self.BlockExpiredAt = [dictionary valueForKey:@"blockExpiredAt"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.LastFourNumbers = [dictionary valueForKey:@"lastFourNumbers"];
            self.ExpiredAt = [dictionary valueForKey:@"expiredAt"];
            self.OwnerName = [dictionary valueForKey:@"ownerName"];
            self.CashAmountLimit = [dictionary valueForKey:@"cashAmountLimit"];
            self.CashAttemptsLimit = [dictionary valueForKey:@"cashAttemptsLimit"];
            self.CashlessAmountLimit = [dictionary valueForKey:@"cashlessAmountLimit"];
            self.CashlessAttemptsLimit = [dictionary valueForKey:@"cashlessAttemptsLimit"];
            self.CardType = [dictionary valueForKey:@"cardType"];
        }
    }
    
    return self;
}


@end
