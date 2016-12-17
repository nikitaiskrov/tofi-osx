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
            self.ID = [[dictionary valueForKey:@"id"] integerValue];
            self.FirstName = [[dictionary valueForKey:@"firstName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.MiddleName = [[dictionary valueForKey:@"middleName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.SecondName = [[dictionary valueForKey:@"secondName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PhoneNumber = [[dictionary valueForKey:@"phoneNumber"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PassportNumber = [[dictionary valueForKey:@"passportNumber"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.Nationality = [[dictionary valueForKey:@"nationality"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.Birthday = [dictionary valueForKey:@"birthday"];
            self.Sex = [[dictionary valueForKey:@"sex"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.Identification = [[dictionary valueForKey:@"identification"] integerValue];
            self.PlaceOfBirth = [[dictionary valueForKey:@"placeOfBirth"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.PassportDateIssuse = [dictionary valueForKey:@"passportDateOfIssue"];
            self.PassportDateExpiry = [dictionary valueForKey:@"passportDateOfExpiry"];
            self.Authority = [[dictionary valueForKey:@"authority"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.CreatedAt = [dictionary valueForKey:@"createdAt"];
            self.UpdatedAt = [dictionary valueForKey:@"updatedAt"];
        }
    }
    
    return self;
}

@end
