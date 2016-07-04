//
//  NSObject+VDDelayOperation.h
//  VDUtil
//
//  Created by FTET on 15/3/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (VDDelayOperation)

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_delaySelector:(SEL)aSelector delay:(NSTimeInterval)delayInterval onMain:(BOOL)onMain identifier:(NSString *)identifier;
- (void)vd_delayBlock:(void(^)(void))block delay:(NSTimeInterval)delayInterval onMain:(BOOL)onMain identifier:(NSString *)identifier;

@end
