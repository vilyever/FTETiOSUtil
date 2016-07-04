//
//  TestViewController.h
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VDRouterBaseViewController.h"


@class TestViewController;


@protocol TestViewControllerDelegate <NSObject>

@required
- (void)ttttttest;

@optional

@end


@interface TestViewController : VDRouterBaseViewController

@property (nonatomic, assign) id<TestViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *testTitle;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)show;

@end
