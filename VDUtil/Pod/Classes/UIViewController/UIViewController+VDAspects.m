//
//  UIViewController+VDAspects.m
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIViewController+VDAspects.h"

#import <objc/runtime.h>

//#import <VDUtil/VDUtil.h>


//static char _Associated_Object_Key;


@implementation UIViewController (VDAspects)

#pragma Overrides
+ (void)load
{
    [self vdaspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        [[info instance] setVdViewFirstAppeared:YES];
        
        SEL selector = NSSelectorFromString( [NSString stringWithFormat:@"viewDidFirstAppear"]);
        if ( [[info instance] respondsToSelector:selector])
        {
            ( (void (*)(id, SEL) )[[info instance] methodForSelector:selector] )([info instance], selector);
        }
    } error:nil];
}


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors
- (BOOL)vdViewFirstAppeared
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setVdViewFirstAppeared:(BOOL)vdViewFirstAppeared
{
    objc_setAssociatedObject(self, @selector(vdViewFirstAppeared), @(vdViewFirstAppeared), OBJC_ASSOCIATION_RETAIN);
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method

@end
