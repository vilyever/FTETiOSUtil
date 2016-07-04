//
//  UIView+VDAnimation.h
//  VDAnimation
//
//  Created by FTET on 14/12/26.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+VDBounce.h"
#import "UIView+VDShake.h"


typedef NS_ENUM(NSInteger, VDRotateDirection) {
    VDRotateDirectionClockwise,
    VDRotateDirectionAntiClockwise
};

@interface UIView (VDAnimation)

- (void)vd_setHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)vd_setHidden:(BOOL)hidden animated:(BOOL)animated duration:(CFTimeInterval)duration;
- (void)vd_rotateViewByDirection:(VDRotateDirection)direction duration:(CFTimeInterval)duration repeatCount:(float)repeatCount;

@end
