//
//  UIView+VDNoticeMsg.h
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (VDNoticeMsg)

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_showNotice:(NSString *)msg color:(UIColor *)color duration:(CFTimeInterval)duration;
- (void)vd_showInfoNotice:(NSString *)msg;
- (void)vd_showWarningNotice:(NSString *)msg;
- (void)vd_showErrorNotice:(NSString *)msg;

- (void)vd_hideNotice;


@end
