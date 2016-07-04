//
//  NSObject+VDDelayOperation.m
//  VDUtil
//
//  Created by FTET on 15/3/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDDelayOperation.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDAspects.h"
#import "NSObject+VDReactiveCocoa.h"


//static char _Associated_Object_Key;

@interface VDDelayOperationQueue : NSOperationQueue

@property (nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;

@end

@implementation VDDelayOperationQueue

- (instancetype)initWithTarget:(id)target
{
    self = [super init];
    
    self.target = target;
    
    VDWeakifySelf;
    [self.target vdaspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        VDStrongifySelf;
        [self cancelAllOperations];
    } error:nil];
    
    return self;
}

@end


@implementation NSObject (VDDelayOperation)

#pragma Accessors
#pragma Private Accessors
- (VDDelayOperationQueue *)vd_delayQueue
{
    VDDelayOperationQueue *queue = objc_getAssociatedObject(self, @selector(vd_delayQueue));
    if (!queue)
    {
        queue = [[VDDelayOperationQueue alloc] initWithTarget:self];
        objc_setAssociatedObject(self, @selector(vd_delayQueue), queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return queue;
}

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
- (void)vd_addOperation:(VDDelayOperation *)operation
{
    for (NSOperation *op in [self vd_delayQueue].operations)
    {
        if ([op.name isEqualToString:operation.name])
        {
            [op cancel];
        }
    }
    
    [[self vd_delayQueue] addOperation:operation];
}

#pragma Public Instance Method
- (void)vd_delaySelector:(SEL)aSelector delay:(NSTimeInterval)delayInterval onMain:(BOOL)onMain identifier:(NSString *)identifier
{
    VDDelayOperation *operation = [[VDDelayOperation alloc] initWithTarget:self selector:aSelector delay:delayInterval onMain:onMain];
    operation.name = identifier;
    
    [self vd_addOperation:operation];
}

- (void)vd_delayBlock:(void(^)(void))block delay:(NSTimeInterval)delayInterval onMain:(BOOL)onMain identifier:(NSString *)identifier
{
    VDDelayOperation *operation = [[VDDelayOperation alloc] initWithBlock:block delay:delayInterval onMain:onMain];
    operation.name = identifier;
    
    [self vd_addOperation:operation];
}

@end
