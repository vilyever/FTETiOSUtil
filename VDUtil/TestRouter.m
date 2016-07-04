//
//  TestRouter.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "TestRouter.h"

#import <VDKit/VDKit.h>


@interface TestRouter ()

@end


@implementation TestRouter

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

#pragma Public Accessors


#pragma Delegates
#pragma VDRouterUrlDelegate
+ (NSString *)urlForRouter {
    return @"test";
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
+ (id)paramsWithTitle:(NSString *)title {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:title forKey:@"title"];
    
    return dic;
}

+ (NSString *)titleFromParams:(id)params {
    return [params objectForKey:@"title"];
}

#pragma Public Instance Method



@end
