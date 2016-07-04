//
//  NSObject+VDAspects.h
//  VDUtil
//
//  Created by FTET on 15/2/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Aspects/Aspects.h>


@interface NSObject (VDAspects)

#pragma Methods
#pragma Public Class Method
+ (id<AspectToken>)vdaspect_hookSelector:(SEL)selector
                           withOptions:(AspectOptions)options
                            usingBlock:(void (^)(id<AspectInfo> info) )block
                                 error:(NSError **)error;

#pragma Public Instance Method
- (id<AspectToken>)vdaspect_hookSelector:(SEL)selector
                           withOptions:(AspectOptions)options
                            usingBlock:(void (^)(id<AspectInfo> info) )block
                                 error:(NSError **)error;

@end
