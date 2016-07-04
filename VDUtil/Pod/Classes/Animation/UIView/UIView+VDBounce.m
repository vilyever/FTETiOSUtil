//
//  UIView+VDBounce.m
//  VDUtil
//
//  Created by FTET on 14/12/11.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "UIView+VDBounce.h"

#import <VDKit/VDKit.h>

#import <POP+MCAnimate/POP+MCAnimate.h>

#import "NSObject+VDReactiveCocoa.h"


static CGFloat Default_Bounce_Degree = 0.95f;


@implementation UIView (VDBounce)

- (void)vd_bounce
{
    [self vd_bounceWithDegree:Default_Bounce_Degree];
}

- (void)vd_bounceWithDegree:(float)degree
{
    VDWeakifySelf;
    [NSObject pop_animate:^(void){
        VDStrongifySelf;
        self.layer.pop_springSpeed = 20.0f;
        self.layer.pop_springBounciness = 10.0f;
        self.layer.pop_velocity = [NSValue valueWithCGSize:CGSizeMake(1.5f, 1.5f) ];
        self.layer.pop_spring.pop_scaleXY = CGPointMake(degree, degree);
    } completion:^(BOOL finished){
        VDStrongifySelf;
        self.layer.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
    } ];
}

@end
