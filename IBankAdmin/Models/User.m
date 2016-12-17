//
//  User.m
//  IBankAdmin
//
//  Created by Никита Искров on 01.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        if (dictionary != nil)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.FirstName = [[dictionary valueForKey:@"firstName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.MiddleName = [[dictionary valueForKey:@"middleName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.SecondName = [[dictionary valueForKey:@"secondName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PhoneNumber = [[dictionary valueForKey:@"phoneNumber"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PassportNumber = [[dictionary valueForKey:@"passportNumber"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.Nationality = [[dictionary valueForKey:@"nationality"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *str = [dictionary valueForKey:@"birthday"];
            NSDate *date = [formatter dateFromString:str];
            self.Birthday = date;
            self.Sex = [[dictionary valueForKey:@"sex"] isEqualToString:@"m"] ? @"Мужской" : @"Женский";
            self.Identification = [[dictionary valueForKey:@"identification"] integerValue];
            self.PlaceOfBirth = [[dictionary valueForKey:@"placeOfBirth"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PassportDateIssuse = [formatter dateFromString:[dictionary valueForKey:@"passportDateOfIssue"]];
            self.PassportDateExpiry = [formatter dateFromString:[dictionary valueForKey:@"passportDateOfExpiry"]];
            self.Authority = [[dictionary valueForKey:@"authority"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.CreatedAt = [formatter dateFromString:[dictionary valueForKey:@"createdAt"]];
            self.UpdatedAt = [formatter dateFromString:[dictionary valueForKey:@"updatedAt"]];
        }
    }
    
    return self;
}

@end
