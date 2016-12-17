//
//  HistoryLog.m
//  IBankAdmin
//
//  Created by Никита Искров on 27.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "HistoryLog.h"

@implementation HistoryLog

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.UserID = ([NSNull null] != [dictionary valueForKey:@"userId"]) ? [[dictionary valueForKey:@"userId"] integerValue] : -1;
            self.Type = [dictionary valueForKey:@"type"];
            self.IP = [dictionary valueForKey:@"ip"];
            self.CountryCode = [dictionary valueForKey:@"countryCode"];
            self.CountryName = [dictionary valueForKey:@"countryName"];
            self.RegionName = [dictionary valueForKey:@"regionName"];
            self.City = [dictionary valueForKey:@"city"];
            self.TimeZone = [dictionary valueForKey:@"timeZone"];
            self.Latitude = [dictionary valueForKey:@"latitude"];
            self.Longitude = [dictionary valueForKey:@"longitude"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
        }
    }
    
    return self;
}

@end
