//
//  NSObject+VDAspects.m
//  VDUtil
//
//  Created by FTET on 15/2/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDAspects.h"

//#import <objc/runtime.h>

//#import <VDUtil/VDUtil.h>


//static char _Associated_Object_Key;


@implementation NSObject (VDAspects)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
+ (id<AspectToken>)vdaspect_hookSelector:(SEL)selector withOptions:(AspectOptions)options usingBlock:(void (^)(id<AspectInfo>))block error:(NSError *__autoreleasing *)error
{
    return [self aspect_hookSelector:selector withOptions:options usingBlock:block error:error];
}

#pragma Public Instance Method
- (id<AspectToken>)vdaspect_hookSelector:(SEL)selector withOptions:(AspectOptions)options usingBlock:(void (^)(id<AspectInfo>))block error:(NSError *__autoreleasing *)error
{
    return [self aspect_hookSelector:selector withOptions:options usingBlock:block error:error];
}

@end
