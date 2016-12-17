//
//  Organization.h
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentOption.h"

@interface Organization : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSInteger CategoryID;
@property (readwrite, nonatomic) NSString *Name;
@property (readwrite, nonatomic) NSString *Address;
@property (readwrite, nonatomic) NSString *Phone;
@property (readwrite, nonatomic) NSDate *CreatedAt;
@property (readwrite, nonatomic) NSDate *UpdatedAt;
@property (readwrite, nonatomic) NSMutableArray *PaymentOptions;


- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
