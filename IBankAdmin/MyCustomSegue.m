//
//  MyCustomSegue.m
//  NSViewControllerPresentations
//
//  Created by jonathan on 25/01/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//

#import "MyCustomSegue.h"
#import "MyCustomAnimator.h"

@implementation MyCustomSegue

- (void)perform
{
    
    id animator1 = [[MyCustomAnimator alloc] init];
    
    [self.sourceController presentViewController:self.destinationController
                                        animator:animator1];
}
@end
