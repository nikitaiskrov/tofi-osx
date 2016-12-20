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
            self.Type = ([NSNull null] != [dictionary valueForKey:@"type"]) ? [dictionary valueForKey:@"type"] : @"-";
            self.IP = ([NSNull null] != [dictionary valueForKey:@"ip"]) ? [dictionary valueForKey:@"ip"] : @"-";
            self.CountryCode = ([NSNull null] != [dictionary valueForKey:@"countryCode"]) ? [dictionary valueForKey:@"countryCode"]: @"-";
            self.CountryName = ([NSNull null] != [dictionary valueForKey:@"countryName"]) ? [dictionary valueForKey:@"countryName"] : @"-";
            self.RegionName = ([NSNull null] != [dictionary valueForKey:@"regionName"]) ? [dictionary valueForKey:@"regionName"] : @"-";
            self.City = ([NSNull null] != [dictionary valueForKey:@"city"]) ? [dictionary valueForKey:@"city"] : @"-";
            self.TimeZone = ([NSNull null] != [dictionary valueForKey:@"timeZone"]) ? [dictionary valueForKey:@"timeZone"] : @"-";
            self.Latitude = [dictionary valueForKey:@"latitude"];
            self.Longitude = [dictionary valueForKey:@"longitude"];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
        }
    }
    
    return self;
}

@end
