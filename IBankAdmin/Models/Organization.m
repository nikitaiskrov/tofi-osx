//
//  Organization.m
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "Organization.h"

@implementation Organization

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.CategoryID = [[dictionary valueForKey:@"categoryId"] integerValue];
            self.Name = [dictionary valueForKey:@"name"];
            self.Address = [dictionary valueForKey:@"address"];
            self.Phone = [dictionary valueForKey:@"phone"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.UpdatedAt = [dictionary valueForKey:@"updatedAt"];
            
            self.PaymentOptions = [NSMutableArray array];
            NSArray *paymentOptionsFromServer = (NSArray *)[dictionary valueForKey:@"paymentOptions"];
            for (NSInteger i = 0; i < paymentOptionsFromServer.count; i++)
            {
                PaymentOption *paymentOption = [[PaymentOption alloc] initWIthDictionary:(NSDictionary *)paymentOptionsFromServer[i]];
                
                [self.PaymentOptions addObject:paymentOption];
            }
        }
    }
    
    return self;
}


@end
