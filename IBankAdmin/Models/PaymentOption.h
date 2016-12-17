//
//  PaymentOptions.h
//  IBankAdmin
//
//  Created by Nikita on 15/12/2016.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentOption : NSObject

@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSString *FieldID;
@property (readwrite, nonatomic) NSString *Type;
@property (readwrite, nonatomic) NSString *ActionDescription;
@property (readwrite, nonatomic) NSString *Description;


- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
