//
//  UIView+VDNoticeMsg.m
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIView+VDNoticeMsg.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import <POP+MCAnimate/POP+MCAnimate.h>

#import "VDNoticeMsgViewController.h"

#import "NSObject+VDReactiveCocoa.h"

#import "NSObject+VDDelayOperation.h"

static CGFloat DefaultMsgViewHeight = 80.0f;
static CFTimeInterval DefaultAnimateDuration = 0.8f;
static CFTimeInterval DefaultShowingDuration = 3.0f;


@implementation UIView (VDNoticeMsg)

#pragma Accessors
#pragma Private Accessors
- (VDNoticeMsgViewController *)vd_noticeMsgController {
    VDNoticeMsgViewController *controller = objc_getAssociatedObject(self, @selector(vd_noticeMsgController));
    if (!controller) {
        controller = [VDNoticeMsgViewController vd_controllerFromNib];
        objc_setAssociatedObject(self, @selector(vd_noticeMsgController), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addSubview:controller.view];

        [controller.view setHidden:YES];
        
        VDWeakifySelf;
        [controller.view vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
            VDStrongifySelf;
            [self vd_hideNotice];
        }];
    }
    
    return controller;
}

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method


#pragma Public Instance Method
- (void)vd_showNotice:(NSString *)msg color:(UIColor *)color duration:(CFTimeInterval)duration {
    [self vd_noticeMsgController].isShowing = YES;
    [self vd_delayBlock:nil delay:duration onMain:YES identifier:@"vd_hideNotice"];
    
    [[self vd_noticeMsgController].view.pop_stop center];
    
    [self bringSubviewToFront:[self vd_noticeMsgController].view];
    [self vd_noticeMsgController].view.backgroundColor = color;
    [self vd_noticeMsgController].msgLabel.text = msg;
    
    [[self vd_noticeMsgController].view setBounds:CGRectMake(0.0f, 0.0f, self.bounds.size.width, DefaultMsgViewHeight)];
    [[self vd_noticeMsgController].view setCenter:CGPointMake(self.bounds.size.width / 2.0f, -DefaultMsgViewHeight / 2.0f)];
    
    [[self vd_noticeMsgController].view setHidden:NO];
    
    [self vd_noticeMsgController].view.pop_duration = DefaultAnimateDuration;
    
    VDWeakifySelf;
    [NSObject pop_animate:^{
        VDStrongifySelf;
        [self vd_noticeMsgController].view.pop_linear.center = CGPointMake(self.bounds.size.width / 2.0f, DefaultMsgViewHeight / 2.0f);
    } completion:^(BOOL finished) {
        VDStrongifySelf;
        if (finished) {
            [self vd_delayBlock:^{
                [self vd_hideNotice];
            } delay:duration onMain:YES identifier:@"vd_hideNotice"];
            
        }
        
        [self vd_noticeMsgController].isShowing = NO;
    } ];
}

- (void)vd_showInfoNotice:(NSString *)msg
{
    [self vd_showNotice:msg color:VDColorFromRGB(VDC_GREEN) duration:DefaultShowingDuration];
}

- (void)vd_showWarningNotice:(NSString *)msg
{
    [self vd_showNotice:msg color:VDColorFromRGB(VDC_ORANGE) duration:DefaultShowingDuration];
}

- (void)vd_showErrorNotice:(NSString *)msg
{
    [self vd_showNotice:msg color:VDColorFromRGB(VDC_RED) duration:DefaultShowingDuration];
}

- (void)vd_hideNotice
{
    if ([self vd_noticeMsgController].view.isHidden) {
        return;
    }
    
    if ([self vd_noticeMsgController].isHiding) {
        return;
    }
    [self vd_noticeMsgController].isHiding = YES;
    
    [[self vd_noticeMsgController].view.pop_stop center];
    [self vd_noticeMsgController].view.pop_duration = DefaultAnimateDuration;
    
    VDWeakifySelf;
    [NSObject pop_animate:^{
        VDStrongifySelf;
        [self vd_noticeMsgController].view.pop_linear.center = CGPointMake(self.bounds.size.width / 2.0f, -DefaultMsgViewHeight / 2.0f);
    } completion:^(BOOL finished) {
        VDStrongifySelf;
        [[self vd_noticeMsgController].view setHidden:![self vd_noticeMsgController].isShowing];
        [self vd_noticeMsgController].isHiding = NO;
    } ];
    
}

@end
