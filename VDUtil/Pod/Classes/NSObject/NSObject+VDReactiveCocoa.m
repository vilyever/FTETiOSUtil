//
//  NSObject+VDReactiveCocoa.m
//  VDUtil
//
//  Created by FTET on 15/1/28.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDReactiveCocoa.h"

#import <objc/runtime.h>

#import <NSNotificationCenter+RACSupport.h>

//#import <VDUtil/VDUtil.h>


static char RAC_Observed_Identfiers_Associated_Object_Key;
static char RAC_Observed_KVO_Identfiers_Associated_Object_Key;
static char RAC_Observed_Notification_Identfiers_Associated_Object_Key;


@implementation NSObject (VDReactiveCocoa)

#pragma Accessors
#pragma Private Accessors
- (NSMutableDictionary *)rac_observedIdentfiers
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &RAC_Observed_Identfiers_Associated_Object_Key);
    
    if (!dictionary)
    {
        dictionary = [ [NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &RAC_Observed_Identfiers_Associated_Object_Key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dictionary;
}

- (NSMutableDictionary *)rac_observedKVOIdentfiers
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &RAC_Observed_KVO_Identfiers_Associated_Object_Key);
    
    if (!dictionary)
    {
        dictionary = [ [NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &RAC_Observed_KVO_Identfiers_Associated_Object_Key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dictionary;
}

- (NSMutableDictionary *)rac_observedNotificationIdentfiers
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &RAC_Observed_Notification_Identfiers_Associated_Object_Key);
    
    if (!dictionary)
    {
        dictionary = [ [NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &RAC_Observed_Notification_Identfiers_Associated_Object_Key, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dictionary;
}

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (RACSignal *)vdrac_isObservedKeyPath:(NSString *)keyPath identifier:(NSString *)identifier
{
    if (!identifier)
    {
        return [ [keyPath vd_keyPathTarget] rac_valuesForKeyPath:keyPath observer:self];
    }
    
    NSArray *keys = [ [self rac_observedIdentfiers] allKeys];
    __block NSString *key = [NSString stringWithFormat:@"%@_%@", keyPath, identifier];
    if ( [keys containsObject:key] )
    {
        RACSignal *signal = [ [self rac_observedIdentfiers] objectForKey:key];
        return signal;
    }
    
    __block RACSignal *signal = [ [keyPath vd_keyPathTarget] rac_valuesForKeyPath:keyPath observer:self];
    [ [self rac_observedIdentfiers] setObject:signal forKey:key];
    
    [signal vdaspect_hookSelector:@selector(subscribe:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        __weak RACDisposable *disposable;
        [ [info originalInvocation] getReturnValue:&disposable];
        
        signal.vd_disposable = disposable;
        
    } error:NULL];
    
    return signal;
}

- (RACSignal *)vdrac_isObservedKVOObserver:(id)observer KeyPath:(NSString *)keyPath identifier:(NSString *)identifier
{
    if (!identifier)
    {
        return [ [keyPath vd_keyPathTarget] rac_valuesAndChangesForKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial observer:observer];
    }
    
    NSArray *keys = [ [self rac_observedKVOIdentfiers] allKeys];
    NSString *key = [NSString stringWithFormat:@"%p_%@_%@", [keyPath vd_keyPathTarget], keyPath, identifier];
    if ( [keys containsObject:key] )
    {
        RACSignal *signal = [ [self rac_observedKVOIdentfiers] objectForKey:key];
        return signal;
    }
    
    RACSignal *signal = [ [keyPath vd_keyPathTarget] rac_valuesAndChangesForKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial observer:observer];
    [ [self rac_observedKVOIdentfiers] setObject:signal forKey:key];
    
    [signal vdaspect_hookSelector:@selector(subscribe:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        __weak RACDisposable *disposable;
        [ [info originalInvocation] getReturnValue:&disposable];
        
        signal.vd_disposable = disposable;
        
    } error:NULL];
    
    return signal;
}

- (RACSignal *)vdrac_isObservedNotification:(NSString *)notification object:(id)object identifier:(NSString *)identifier
{
    if (!identifier)
    {
        return [VDDefaultNotificationCenter rac_addObserverForName:notification object:object];
    }
    
    NSArray *keys = [ [self rac_observedNotificationIdentfiers] allKeys];
    NSString *key = [NSString stringWithFormat:@"%@_%@", notification, identifier];
    if ( [keys containsObject:key] )
    {
        RACSignal *signal = [ [self rac_observedNotificationIdentfiers] objectForKey:key];
        return signal;
    }
    
    RACSignal *signal = [VDDefaultNotificationCenter rac_addObserverForName:notification object:object];
    [ [self rac_observedNotificationIdentfiers] setObject:signal forKey:key];
    
    [signal vdaspect_hookSelector:@selector(subscribe:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        __weak RACDisposable *disposable;
        [ [info originalInvocation] getReturnValue:&disposable];
        
        signal.vd_disposable = disposable;
        
    } error:NULL];
    
    return signal;
}

@end


@implementation UIView (VDReactiveCocoa)

#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (UITapGestureRecognizer *)vdrac_addTapGestureRecognizerWithSubscribeNext:(void (^)(UITapGestureRecognizer *))block
{
    UITapGestureRecognizer *tapGestureRecognizer = [ [UITapGestureRecognizer alloc] init];
    [ [tapGestureRecognizer rac_gestureSignal] subscribeNext:block];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
    return tapGestureRecognizer;
}

- (UITapGestureRecognizer *)vdrac_addDoubleTapGestureRecognizerWithSubscribeNext:(void (^)(UITapGestureRecognizer *))block
{
    UITapGestureRecognizer *tapGestureRecognizer = [self vdrac_addTapGestureRecognizerWithSubscribeNext:block];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    
    return tapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)vdrac_addLongPressGestureRecognizerWithSubscribeNext:(void (^)(UILongPressGestureRecognizer *))block
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [ [UILongPressGestureRecognizer alloc] init];
    [ [longPressGestureRecognizer rac_gestureSignal] subscribeNext:block];
    
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    return longPressGestureRecognizer;
}

- (UIPanGestureRecognizer *)vdrac_addPanGestureRecognizerWithSubscribeNext:(void (^)(UIPanGestureRecognizer *))block
{
    UIPanGestureRecognizer *panGestureRecognizer = [ [UIPanGestureRecognizer alloc] init];
    [ [panGestureRecognizer rac_gestureSignal] subscribeNext:block];
    
    [self addGestureRecognizer:panGestureRecognizer];
    
    return panGestureRecognizer;
}

- (UIPinchGestureRecognizer *)vdrac_addPinchGestureRecognizerWithSubscribeNext:(void (^)(UIPinchGestureRecognizer *))block
{
    UIPinchGestureRecognizer *pinchGestureRecognizer = [ [UIPinchGestureRecognizer alloc] init];
    [ [pinchGestureRecognizer rac_gestureSignal] subscribeNext:block];
    
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    return pinchGestureRecognizer;
}

@end


static char RACSignal_RACDisposable_Associated_Object_Key;

@implementation RACSignal (VDReactiveCocoa)

#pragma Accessors
#pragma Private Accessors
- (void)setVd_disposable:(RACDisposable *)vd_disposable
{
    [self.vd_disposable dispose];
    objc_setAssociatedObject(self, &RACSignal_RACDisposable_Associated_Object_Key, [VDWeakObjectCarrier carrierWithWeakObject:vd_disposable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RACDisposable *)vd_disposable
{
    return [objc_getAssociatedObject(self, &RACSignal_RACDisposable_Associated_Object_Key) weakObject];
}

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (RACDisposable *)subscribeNextForKVO:(void (^)(NSDictionary *))nextBlock
{
    void (^targetBlock)(NSDictionary *) = [nextBlock copy];
    void (^analysisBlock)(RACTuple *)= ^(RACTuple *tuple) {
        targetBlock(tuple.second);
    };
    
    return [self subscribeNext:analysisBlock];
}

- (RACDisposable *)subscribeNextForNotification:(void (^)(NSNotification *))nextBlock
{
    return [self subscribeNext:nextBlock];
}

@end
