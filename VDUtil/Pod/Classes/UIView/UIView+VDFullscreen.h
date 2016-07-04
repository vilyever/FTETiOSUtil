//
//  UIView+VDFullscreen.h
//  VDUtil
//
//  Created by FTET on 15/2/3.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (VDFullscreen)

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (CGPoint)vd_zoomInFullscreenMode;
- (CGPoint)vd_zoomInFullscreenModeWithCompletionAction:(void (^)(CGPoint scale))completionAction;
- (void)vd_zoomOutFullscreenMode;

- (void)vd_enterFullscreenMode;
- (void)vd_enterFullscreenModeWithCompletionAction:(void (^)(CGPoint scale))completionAction;
- (void)vd_exitFullscreenMode;

@end
