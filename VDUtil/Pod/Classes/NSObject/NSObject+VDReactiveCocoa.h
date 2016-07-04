//
//  NSObject+VDReactiveCocoa.h
//  VDUtil
//
//  Created by FTET on 15/1/28.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

//#import <ReactiveCocoa/EXTScope.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDAspects.h"


#ifndef VDRACObserve
#define VDRACObserve(Target, Path, Identifier) \
( [Target vdrac_isObservedKeyPath:VDKeyPath(Target, Path) identifier:Identifier] )
#endif


#ifndef VDRACKVO
#define VDRACKVO(Target, Path, Identifier) \
VDRACKVOWithObserver(Target, Path, self, Identifier)
#endif

#ifndef VDRACKVOWithObserver
#define VDRACKVOWithObserver(Target, Path, Observer, Identifier) \
( [Observer vdrac_isObservedKVOObserver:Observer KeyPath:VDKeyPath(Target, Path) identifier:Identifier] )
#endif


#define VDRACNotification(Notification, Object, Identifier) \
( [self vdrac_isObservedNotification:Notification object:Object identifier:Identifier] )


#define VDRACIdentifier \
( [NSString stringWithFormat:@"%p_%s_%d", self, __FUNCTION__, __LINE__] )


@interface NSObject (VDReactiveCocoa)

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (RACSignal *)vdrac_isObservedKeyPath:(NSString *)keyPath identifier:(NSString *)identifier;
- (RACSignal *)vdrac_isObservedKVOObserver:(id)observer KeyPath:(NSString *)keyPath identifier:(NSString *)identifier;
- (RACSignal *)vdrac_isObservedNotification:(NSString *)notification object:(id)object identifier:(NSString *)identifier;

@end


@interface UIView (VDReactiveCocoa)

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (UITapGestureRecognizer *)vdrac_addTapGestureRecognizerWithSubscribeNext:(void (^)(UITapGestureRecognizer *gestureRecognizer) )block;

- (UITapGestureRecognizer *)vdrac_addDoubleTapGestureRecognizerWithSubscribeNext:(void (^)(UITapGestureRecognizer *gestureRecognizer) )block;

- (UILongPressGestureRecognizer *)vdrac_addLongPressGestureRecognizerWithSubscribeNext:(void (^)(UILongPressGestureRecognizer *gestureRecognizer) )block;

- (UIPanGestureRecognizer *)vdrac_addPanGestureRecognizerWithSubscribeNext:(void (^)(UIPanGestureRecognizer *gestureRecognizer) )block;

- (UIPinchGestureRecognizer *)vdrac_addPinchGestureRecognizerWithSubscribeNext:(void (^)(UIPinchGestureRecognizer *gestureRecognizer) )block;

@end


@interface RACSignal (VDReactiveCocoa)

@property (nonatomic, weak) RACDisposable *vd_disposable;

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (RACDisposable *)subscribeNextForKVO:(void (^)(NSDictionary *change))nextBlock;
- (RACDisposable *)subscribeNextForNotification:(void (^)(NSNotification *notification))nextBlock;

@end

