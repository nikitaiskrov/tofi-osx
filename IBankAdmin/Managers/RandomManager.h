//
//  RandomManager.h
//  IBankAdmin
//
//  Created by Никита Искров on 26.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomManager : NSObject


+ (id)manager;


-(NSString *)randomStringWithLength:(int)len;
-(NSString *)randomStringNumberWithLength:(int)len;


@end
