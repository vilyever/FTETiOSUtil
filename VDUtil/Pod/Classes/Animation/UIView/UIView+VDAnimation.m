//
//  UIView+VDAnimation.m
//  VDAnimation
//
//  Created by FTET on 14/12/26.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "UIView+VDAnimation.h"

@implementation UIView (VDAnimation)

- (void)vd_setHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self vd_setHidden:hidden animated:animated duration:0.3];
}

- (void)vd_setHidden:(BOOL)hidden animated:(BOOL)animated duration:(CFTimeInterval)duration
{
    if (animated)
    {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransition;
        animation.duration = duration;
        [self.layer addAnimation:animation forKey:nil];
    }
    
    [self setHidden:hidden];
}

- (void)vd_rotateViewByDirection:(VDRotateDirection)direction duration:(CFTimeInterval)duration repeatCount:(float)repeatCount
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @((2 * M_PI) * (direction == VDRotateDirectionClockwise ? 1 : -1) );
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    //	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}

@end
