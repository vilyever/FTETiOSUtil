//
//  VDRouter.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDRouter.h"

#import <VDKit/VDKit.h>




@interface VDRouter ()

@property (nonatomic, strong) NSMutableDictionary *registeredViewControllers;

@end


@implementation VDRouter

#pragma Overrides
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initial];
    }
    
    return self;
}

- (void)dealloc
{
    
}


#pragma Initial
- (void)initial
{
    
}


#pragma Accessors
#pragma Private Accessors
- (NSMutableDictionary *)registeredViewControllers {
    if (!_registeredViewControllers) {
        _registeredViewControllers = [NSMutableDictionary new];
    }
    
    return _registeredViewControllers;
}

#pragma Public Accessors


#pragma Delegates


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
+ (VDRouter *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [ [ [self class] alloc] init];
    } );
    
    return _sharedInstance;
}

#pragma Public Instance Method
+ (void)registerViewController:(Class)vcClass url:(NSString *)url {
    [[self sharedInstance].registeredViewControllers setObject:vcClass forKey:url];
}

+ (void)route:(NSString *)url params:(id)params {
    [self route:url params:params shouldBack:NO];
}

+ (void)route:(NSString *)url params:(id)params shouldBack:(BOOL)shouldBack {
    Class destinationClass = [[self sharedInstance].registeredViewControllers objectForKey:url];
    if (!destinationClass) {
        return;
    }
    
    VDRouterBaseAppDelegate *appDelegate = (VDRouterBaseAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (shouldBack) {
        NSInteger count = appDelegate.rootNavigationViewController.viewControllers.count;
        for (NSInteger i = count - 2; i >= 0; i--) {
            if ([appDelegate.rootNavigationViewController.viewControllers[i] isMemberOfClass:destinationClass]) {
                [appDelegate.rootNavigationViewController popToViewController:appDelegate.rootNavigationViewController.viewControllers[i] animated:YES];
                return;
            }
        }
    }
    
    UIViewController *destinationViewController = [[destinationClass alloc] initWithRouterParams:params];
    [appDelegate.rootNavigationViewController pushViewController:destinationViewController animated:YES];
}

+ (void)routeBack {
    VDRouterBaseAppDelegate *appDelegate = (VDRouterBaseAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.rootNavigationViewController popViewControllerAnimated:YES];
}


@end
