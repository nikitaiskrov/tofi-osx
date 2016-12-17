//
//  Category.m
//  IBankAdmin
//
//  Created by Никита Искров on 16.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "Category.h"

@implementation Category

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.Name = [dictionary valueForKey:@"name"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.UpdatedAt = [dictionary valueForKey:@"updatedAt"];
        }
    }
    
    return self;
}

@end
