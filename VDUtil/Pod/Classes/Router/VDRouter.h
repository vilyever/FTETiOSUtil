//
//  VDRouter.h
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VDRouterBaseAppDelegate.h"
#import "VDRouterRootNavigationViewController.h"
#import "VDRouterBaseViewController.h"


@class VDRouter;


@protocol VDRouterUrlDelegate <NSObject>

+ (NSString *)urlForRouter;

@end


@interface VDRouter : NSObject


#pragma Methods
#pragma Public Class Method
+ (VDRouter *)sharedInstance;

#pragma Public Instance Method
+ (void)registerViewController:(Class)vcClass url:(NSString *)url;

+ (void)route:(NSString *)url params:(id)params;
+ (void)route:(NSString *)url params:(id)params shouldBack:(BOOL)shouldBack;

+ (void)routeBack;

@end
