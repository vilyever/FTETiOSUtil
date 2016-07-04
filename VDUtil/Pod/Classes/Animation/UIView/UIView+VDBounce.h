//
//  UIView+VDBounce.h
//  VDUtil
//
//  Created by FTET on 14/12/11.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VDBounce)

/**
 *  按默认缩放程度缩放弹动视图
 */
- (void)vd_bounce;

/**
 *  按缩放程度degree缩放弹动视图
 *
 *  @param degree 缩放程度，视图边界bounds按degree比例缩放后还原
 */
- (void)vd_bounceWithDegree:(float)degree;

@end
