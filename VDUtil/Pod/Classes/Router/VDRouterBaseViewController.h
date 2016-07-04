//
//  VDRouterBaseViewController.h
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VDRouterBaseViewController;


@interface VDRouterBaseViewController : UIViewController

@property (nonatomic, strong) id routerParams;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (instancetype)initWithRouterParams:(id)params;

@end
