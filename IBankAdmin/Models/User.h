//
//  User.h
//  IBankAdmin
//
//  Created by Никита Искров on 01.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSString *FirstName;
@property (readwrite, nonatomic) NSString *MiddleName;
@property (readwrite, nonatomic) NSString *SecondName;
@property (readwrite, nonatomic) NSString *PhoneNumber;
@property (readwrite, nonatomic) NSString *PassportNumber;
@property (readwrite, nonatomic) NSString *Nationality;
@property (readwrite, nonatomic) NSDate *Birthday;
@property (readwrite, nonatomic) NSString *Sex;
@property (readwrite, nonatomic) NSInteger Identification;
@property (readwrite, nonatomic) NSString *PlaceOfBirth;
@property (readwrite, nonatomic) NSDate *PassportDateIssuse;
@property (readwrite, nonatomic) NSDate *PassportDateExpiry;
@property (readwrite, nonatomic) NSString *Authority;
@property (readwrite, nonatomic) NSDate *CreatedAt;
@property (readwrite, nonatomic) NSDate *UpdatedAt;


- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
