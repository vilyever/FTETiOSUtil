//
//  UIView+VDShake.m
//  UIView+VDShake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "UIView+VDShake.h"

#import <VDKit/VDKit.h>

@implementation UIView (VDShake)

- (void)vd_shakeHorizon
{
    [self vd_shake:10 withDelta:5 andSpeed:0.04 shakeDirection:VDShakeDirectionHorizontal];
}

- (void)vd_shake:(int)times withDelta:(CGFloat)delta
{
	[self shake:times direction:VDShakeDirectionHorizontal currentTimes:0 withDelta:delta andSpeed:0.03 shakeDirection:VDShakeDirectionHorizontal];
}

- (void)vd_shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
	[self shake:times direction:VDShakeDirectionHorizontal currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:VDShakeDirectionHorizontal];
}

- (void)vd_shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(VDShakeDirection)shakeDirection
{
    [self shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:shakeDirection];
}

- (void)shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(VDShakeDirection)shakeDirection
{
    VDWeakifySelf;
	[UIView animateWithDuration:interval animations:^{
        VDStrongifySelf;
		self.transform = (shakeDirection == VDShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
	} completion:^(BOOL finished) {
        VDStrongifySelf;
		if(current >= times) {
			self.transform = CGAffineTransformIdentity;
			return;
		}
		[self shake:(times - 1)
		   direction:direction * -1
		currentTimes:current + 1
		   withDelta:delta
			andSpeed:interval
	  shakeDirection:shakeDirection];
	}];
}

@end
