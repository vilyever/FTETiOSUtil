//
//  UIImageView+VDFullscreen.h
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (VDFullscreen) <UIScrollViewDelegate>

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_enterImageViewFullscreenMode;
- (void)vd_activateTapToEnterImageViewFullscreenMode;

@end
