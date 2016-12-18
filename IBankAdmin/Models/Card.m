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
            self.IsBlocked = [[dictionary valueForKey:@"blocked"] boolValue];

            if (self.IsBlocked && [NSNull null] == [dictionary valueForKey:@"blockExpiredAt"]) {
                self.DateIsNull = YES;
            } else {
                self.DateIsNull = NO;
            }
            
            if ([NSNull null] != [dictionary valueForKey:@"blockExpiredAt"])
            {
                NSInteger seconds = [[dictionary valueForKey:@"blockExpiredAt"] integerValue];
                self.BlockExpiredAt = [NSDate dateWithTimeIntervalSince1970:seconds];
            }
            else
            {
                self.BlockExpiredAt = [NSDate date];
            }
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.LastFourNumbers = ([dictionary valueForKey:@"lastFourNumbers"] == [NSNull null]) ? @"-" : [dictionary valueForKey:@"lastFourNumbers"];
            self.ExpiredAt = ([dictionary valueForKey:@"expiredAt"]   == [NSNull null]) ? @"-" : [dictionary valueForKey:@"expiredAt"];
            self.OwnerName = ([dictionary valueForKey:@"ownerName"] == [NSNull null]) ? @"" : [dictionary valueForKey:@"ownerName"];
            self.CashAmountLimit = ([dictionary valueForKey:@"cashAmountLimit"]  == [NSNull null]) ? @"" : [dictionary valueForKey:@"cashAmountLimit"];
            self.CashAttemptsLimit = ([dictionary valueForKey:@"cashAttemptsLimit"] == [NSNull null]) ? @"" : [dictionary valueForKey:@"cashAttemptsLimit"];
            self.CashlessAmountLimit = ([dictionary valueForKey:@"cashlessAmountLimit"] == [NSNull null]) ? @"" : [dictionary valueForKey:@"cashlessAmountLimit"];
            self.CashlessAttemptsLimit = ([dictionary valueForKey:@"cashlessAttemptsLimit"] == [NSNull null]) ? @"" : [dictionary valueForKey:@"cashlessAttemptsLimit"];
            self.CardType = ([dictionary valueForKey:@"cardType"]  == [NSNull null]) ? @"-" : [dictionary valueForKey:@"cardType"];
        }
    }
    
    return self;
}


@end
