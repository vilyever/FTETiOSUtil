//
//  TestRouter.h
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VDRouter.h"


@class TestRouter;


@interface TestRouter : NSObject <VDRouterUrlDelegate>


#pragma Methods
#pragma Public Class Method
+ (id)paramsWithTitle:(NSString *)title;
+ (NSString *)titleFromParams:(id)params;

#pragma Public Instance Method

@end
