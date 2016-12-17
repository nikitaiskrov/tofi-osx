//
//  HistoryLog.h
//  IBankAdmin
//
//  Created by Никита Искров on 27.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryLog : NSObject

/*
 "id": 212,
 "userId": 22,
 "type": "signin",
 "ip": "159.122.215.170",
 "countryCode": "US",
 "countryName": "United States",
 "regionName": null,
 "city": null,
 "timeZone": null,
 "latitude": "37.751",
 "longitude": "-97.822",
 "createdAt": "2016-11-06 13:20:32"
 */

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSInteger UserID;
@property (readwrite, nonatomic) NSString *Type;
@property (readwrite, nonatomic) NSString *IP;
@property (readwrite, nonatomic) NSString *CountryCode;
@property (readwrite, nonatomic) NSString *CountryName;
@property (readwrite, nonatomic) NSString *RegionName;
@property (readwrite, nonatomic) NSString *City;
@property (readwrite, nonatomic) NSString *TimeZone;
@property (readwrite, nonatomic) NSString *Latitude;
@property (readwrite, nonatomic) NSString *Longitude;
@property (readwrite, nonatomic) NSDate *CreatedAt;

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
