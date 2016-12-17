//
//  RandomManager.m
//  IBankAdmin
//
//  Created by Никита Искров on 26.11.16.
//  Copyright © 2016 Никита Искров. All rights reserved.
//

#import "RandomManager.h"

@implementation RandomManager


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
NSString *numbers = @"1234567890";

+ (id)manager
{
    static RandomManager *randomManager = nil;
    
    @synchronized(self)
    {
        if (randomManager == nil)
            randomManager = [[self alloc] init];
    }
    
    return randomManager;
}



-(NSString *)randomStringWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i < len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}


-(NSString *)randomStringNumberWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i < len; i++)
    {
        [randomString appendFormat: @"%C", [numbers characterAtIndex: arc4random_uniform([numbers length])]];
    }
    
    return randomString;
}


@end
