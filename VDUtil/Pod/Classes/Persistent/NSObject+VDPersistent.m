//
//  NSObject+VDPersistent.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDPersistent.h"

//#import <objc/runtime.h>

//#import <VDUtil/VDUtil.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDAspects.h"

#import "NSObject+VDReactiveCocoa.h"


@implementation NSObject (VDPersistent)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_enablePersistentProperty:(NSString *)propertyName {
    __block VDProperty *property = [self.class vd_propertyWithName:propertyName];
    
//    SEL setterSelector = NSSelectorFromString(property.setterSelectorName);
    SEL getterSelector = NSSelectorFromString(property.getterSelectorName);
    
    [[self vdrac_isObservedKVOObserver:self KeyPath:propertyName identifier:VDIdentifier] subscribeNextForKVO:^(NSDictionary *change) {
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id value = [change objectForKey:NSKeyValueChangeNewKey];

        if (oldValue) {
            if (value == [NSNull null]) {
                value = nil;
            }
            
            [VDUserDefaults setObject:value forKey:property.description];
            [VDUserDefaults synchronize];
        }
    }];

    [self vdaspect_hookSelector:getterSelector withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        id value = [VDUserDefaults objectForKey:property.description];
        NSInvocation *invocation = [info originalInvocation];
        [invocation setReturnValue:&value];
    } error:nil];
}

@end
