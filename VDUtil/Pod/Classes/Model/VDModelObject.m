//
//  VDModelObject.m
//  VDModel
//
//  Created by FTET on 15/4/1.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDModelObject.h"

#import <VDKit/VDKit.h>


@interface VDModelObject ()

@end


@implementation VDModelObject

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
#pragma VDModelProtocol
+ (NSDictionary *)jsonKeyDictionaryForVDModel
{
    NSMutableDictionary *dic = [NSObject vd_jsonKeyDictionary];
    
//    VDModelObject *model;
//    [dic setObject:@"id" forKey:VDKeyPath(model, ID)];
    
    return [NSDictionary dictionaryWithDictionary:dic];
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method


@end
