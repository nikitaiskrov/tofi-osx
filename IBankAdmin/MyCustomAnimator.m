//
//  MyCustomAnimator.m
//  TestOSXApp
//
//  Created by jonathan on 22/01/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.


#import "MyCustomAnimator.h"
#import "MainWindow.h"

@interface MyCustomAnimator()
{
//    NSViewController *currentViewController;
}

@end


@implementation MyCustomAnimator


- (void)animatePresentationOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    NSViewController* bottomVC = fromViewController;
    NSViewController* currentViewController = viewController;
    
    if ([bottomVC isMemberOfClass:[MainWindow class]])
    {
        [((MainWindow *)bottomVC).CurrentChildViewController.view removeFromSuperview];
    }
    else
    {
        bottomVC = ((MainWindow *)bottomVC.parentViewController);
    }
    
    currentViewController.view.wantsLayer = YES;
    currentViewController.view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    currentViewController.view.alphaValue = 0;
    
    if ([bottomVC isMemberOfClass:[MainWindow class]])
    {
        [((MainWindow *)bottomVC).ContentView addSubview:currentViewController.view];
        ((MainWindow *)bottomVC).CurrentChildViewController = currentViewController;
        CGRect rect = CGRectMake(0, 0, ((MainWindow *)bottomVC).ContentView.frame.size.width, ((MainWindow *)bottomVC).ContentView.frame.size.height);
        [currentViewController.view setFrame:rect];
    }
    else
    {
        [((MainWindow *)bottomVC.parentViewController).ContentView addSubview:currentViewController.view];
        ((MainWindow *)bottomVC.parentViewController).CurrentChildViewController = currentViewController;
        CGRect rect = CGRectMake(0, 0, ((MainWindow *)bottomVC.parentViewController).ContentView.frame.size.width, ((MainWindow *)bottomVC.parentViewController).ContentView.frame.size.height);
        [currentViewController.view setFrame:rect];
        
        [bottomVC.view removeFromSuperview];
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
    {
        context.duration = 0.5;
        currentViewController.view.animator.alphaValue = 1;
    } completionHandler:nil];
}

- (void)animateDismissalOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    NSViewController* topVC = viewController;
    topVC.view.wantsLayer = YES;
    topVC.view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
    {
        context.duration = 0.5;
        topVC.view.animator.alphaValue = 0;
    } completionHandler:^{
        [topVC.view removeFromSuperview];
    }];
}

@end
