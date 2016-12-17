//
//  PaymentOptions.m
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "PaymentOption.h"

@implementation PaymentOption

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.FieldID = [dictionary valueForKey:@"field"];
            self.Type = [dictionary valueForKey:@"type"];
            self.ActionDescription = [dictionary valueForKey:@"actionDescription"];
            self.Description = [dictionary valueForKey:@"description"];
        }
    }
    
    return self;
}

@end
