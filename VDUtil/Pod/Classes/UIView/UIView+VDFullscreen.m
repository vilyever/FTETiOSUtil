//
//  UIView+VDFullscreen.m
//  VDUtil
//
//  Created by FTET on 15/2/3.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIView+VDFullscreen.h"

//#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"

#import "NSObject+VDAspects.h"

#import "NSObject+VDPop.h"


//static char _Associated_Object_Key;


@implementation UIView (VDFullscreen)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method
- (BOOL)vd_isZoomInFullscreen
{
    return NO;
}

- (BOOL)vd_isFullscreen
{
    return NO;
}

#pragma Public Class Method

#pragma Public Instance Method
- (CGPoint)vd_zoomInFullscreenMode
{
    return [self vd_zoomInFullscreenModeWithCompletionAction:NULL];
}

- (CGPoint)vd_zoomInFullscreenModeWithCompletionAction:(void (^)(CGPoint))completionAction
{
    if ( [self vd_isZoomInFullscreen] )
    {
        return CGPointZero;
    }
    
    __block void (^blockCompletionAction)(CGPoint) = [completionAction copy];
    
    __block id<AspectToken> prefersStatusBarHiddenAspectToken = [[UIViewController vd_topViewControllerWithRootViewController:nil] vdaspect_hookSelector:@selector(prefersStatusBarHidden) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        BOOL prefersStatusBarHidden = YES;
        NSInvocation *invocation = [info originalInvocation];
        [invocation setReturnValue:&prefersStatusBarHidden];
    } error:NULL];
    
    [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
    
    __block CGPoint originalWindowCenter = VDWindow.center;
    __block CGPoint scaledWindowCenter = CGPointZero;
    CGPoint selfCenterInWindow = [self.superview convertPoint:self.center toView:nil];
    
    scaledWindowCenter.x = originalWindowCenter.x - (selfCenterInWindow.x - originalWindowCenter.x) * VDWindow.frame.size.width / self.frame.size.width;
    scaledWindowCenter.y = originalWindowCenter.y - (selfCenterInWindow.y- originalWindowCenter.y) * VDWindow.frame.size.height / self.frame.size.height;
    
    
    __block CGPoint fullscreenScale = CGPointMake(VDWindow.frame.size.width / self.frame.size.width,
                                          VDWindow.frame.size.height / self.frame.size.height);
    
    VDWindow.userInteractionEnabled = NO;
    VDWeakifySelf;
    [NSObject pop_animate:^{
        VDWindow.pop_spring.pop_scaleXY = fullscreenScale;
        VDWindow.pop_spring.center = scaledWindowCenter;
    } completion:^(BOOL finished) {
        VDStrongifySelf;
        VDWindow.userInteractionEnabled = YES;
        
        __block CGFloat originalContentScaleFactor = self.contentScaleFactor;
        self.contentScaleFactor = fmaxf(VDWindow.pop_scaleXY.x, VDWindow.pop_scaleXY.y);
        for (UIView *subView in self.subviews)
        {
            subView.contentScaleFactor = fmaxf(VDWindow.pop_scaleXY.x, VDWindow.pop_scaleXY.y);
        }
        
        if (blockCompletionAction)
        {
            blockCompletionAction(VDWindow.pop_scaleXY);
        }
        
        __block id<AspectToken> vd_isZoomInFullscreenAspectToken = [self vdaspect_hookSelector:@selector(vd_isZoomInFullscreen) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
            BOOL isFullscreen = YES;
            NSInvocation *invocation = [info originalInvocation];
            [invocation setReturnValue:&isFullscreen];
        } error:NULL];
        
        __block id<AspectToken> vd_zoomOutFullscreenModeAspectToken = [self vdaspect_hookSelector:@selector(vd_zoomOutFullscreenMode) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            VDStrongifySelf;
            VDWindow.userInteractionEnabled = NO;
            
            [vd_zoomOutFullscreenModeAspectToken remove];
            [vd_isZoomInFullscreenAspectToken remove];
            [prefersStatusBarHiddenAspectToken remove];
            [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
            
            self.contentScaleFactor = originalContentScaleFactor;
            for (UIView *subView in self.subviews)
            {
                subView.contentScaleFactor = originalContentScaleFactor;
            }
            
            [NSObject pop_animate:^{
                VDWindow.pop_springBounciness = 0.0f;
                VDWindow.pop_spring.pop_scaleXY = CGPointMake(1.0f, 1.0f);
                VDWindow.pop_spring.center = originalWindowCenter;
            } completion:^(BOOL finished) {
                VDWindow.userInteractionEnabled = YES;

            } ];
            
        } error:NULL];
    } ];
    
    return fullscreenScale;
}

- (void)vd_zoomOutFullscreenMode
{
    if (![self vd_isZoomInFullscreen] )
    {
        return;
    }
}

- (void)vd_enterFullscreenMode
{
    [self vd_enterFullscreenModeWithCompletionAction:NULL];
}

- (void)vd_enterFullscreenModeWithCompletionAction:(void (^)(CGPoint))completionAction
{
    if ( [self vd_isFullscreen] )
    {
        return;
    }
    
    __block void (^blockCompletionAction)(CGPoint) = [completionAction copy];
    
    __block id<AspectToken> prefersStatusBarHiddenAspectToken = [[UIViewController vd_topViewControllerWithRootViewController:nil] vdaspect_hookSelector:@selector(prefersStatusBarHidden) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        BOOL prefersStatusBarHidden = YES;
        NSInvocation *invocation = [info originalInvocation];
        [invocation setReturnValue:&prefersStatusBarHidden];
    } error:NULL];
    
    [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
    
    __block CGRect originalFrame = self.frame;
    __block UIView *originalSuperView = self.superview;
    
    [self removeFromSuperview];
    self.frame = [originalSuperView convertRect:originalFrame toView:nil];
    [VDWindow addSubview:self];
    
    VDWindow.userInteractionEnabled = NO;
    VDWeakifySelf;
    [NSObject pop_animate:^{
        VDStrongifySelf;
        self.pop_spring.frame = VDWindow.bounds;
    } completion:^(BOOL finished) {
        VDStrongifySelf;
        VDWindow.userInteractionEnabled = YES;
        
        if (blockCompletionAction)
        {
            blockCompletionAction(VDWindow.pop_scaleXY);
        }
        
        __block id<AspectToken> vd_isFullscreenAspectToken = [self vdaspect_hookSelector:@selector(vd_isFullscreen) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
            BOOL isFullscreen = YES;
            NSInvocation *invocation = [info originalInvocation];
            [invocation setReturnValue:&isFullscreen];
        } error:NULL];
        
        __block id<AspectToken> vd_exitFullscreenModeAspectToken = [self vdaspect_hookSelector:@selector(vd_exitFullscreenMode) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            VDWindow.userInteractionEnabled = NO;
            
            [vd_exitFullscreenModeAspectToken remove];
            [vd_isFullscreenAspectToken remove];
            [prefersStatusBarHiddenAspectToken remove];
            [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
            
            [NSObject pop_animate:^{
                VDStrongifySelf;
                self.pop_spring.frame = [originalSuperView convertRect:originalFrame toView:nil];
            } completion:^(BOOL finished) {
                VDStrongifySelf;
                
                [self removeFromSuperview];
                self.frame = originalFrame;
                [originalSuperView addSubview:self];
                
                VDWindow.userInteractionEnabled = YES;
            } ];
            
        } error:NULL];
    } ];
}

- (void)vd_exitFullscreenMode
{
    if (![self vd_isFullscreen] )
    {
        return;
    }
}

@end
