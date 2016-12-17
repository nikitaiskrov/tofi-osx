//
//  BankAccount.m
//  IBankAdmin
//
//  Created by Никита Искров on 06.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "BankAccount.h"

@implementation BankAccount

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.OwnerID = [[dictionary valueForKey:@"ownerId"] integerValue];
            
            if ([[dictionary valueForKey:@"ownerType"]  isEqual: @"user"])
            {
                self.OwnerType = User;
            }
            if ([[dictionary valueForKey:@"ownerType"]  isEqual: @"org"])
            {
                self.OwnerType = Organization;
            }
            
            self.Number = [[dictionary valueForKey:@"number"] integerValue];
            self.IsBlocked = [[dictionary valueForKey:@"blocked"] boolValue];
            self.BlockExpiredAt = [dictionary valueForKey:@"blockExpiredAt"];
            self.Balance = [[dictionary valueForKey:@"balance"] floatValue];
            self.Currency = [dictionary valueForKey:@"currency"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.UpdatedAt = [dictionary valueForKey:@"updatedAt"];
        }
    }
    
    return self;
}

@end
