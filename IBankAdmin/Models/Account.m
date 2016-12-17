//
//  Account.m
//  IBankAdmin
//
//  Created by Никита Искров on 13.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "Account.h"

@implementation Account

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.ClientID = ([NSNull null] != [dictionary valueForKey:@"clientId"]) ? [[dictionary valueForKey:@"clientId"] integerValue] : -1;
            self.Username = [[dictionary valueForKey:@"username"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.Role = [dictionary valueForKey:@"role"];
            self.IsBlockedString = [[dictionary valueForKey:@"blocked"] boolValue] ? @"Заблокирован" : @"Активен";
            self.IsBlocked = [[dictionary valueForKey:@"blocked"] boolValue];
#pragma warning fix
            self.BlockedDate = ([NSNull null] != [dictionary valueForKey:@"blockExpiredAt"]) ? [dictionary valueForKey:@"blockExpiredAt"] : [NSDate date];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.UpdatedAt = [dictionary valueForKey:@"updatedAt"];
        }
    }
    
    return self;
}

@end
