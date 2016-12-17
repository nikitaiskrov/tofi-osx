//
//  Category.h
//  IBankAdmin
//
//  Created by Никита Искров on 16.12.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject


@property (readwrite, nonatomic) NSInteger ID;
@property (readwrite, nonatomic) NSString *Name;
@property (readwrite, nonatomic) NSDate *CreatedAt;
@property (readwrite, nonatomic) NSDate *UpdatedAt;

- (instancetype)initWIthDictionary:(NSDictionary *)dictionary;

@end
