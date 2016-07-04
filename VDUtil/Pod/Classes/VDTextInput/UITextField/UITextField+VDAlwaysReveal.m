//
//  UITextField+VDAlwaysReveal.m
//  VDTextInPut
//
//  Created by FTET on 14/12/17.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "UITextField+VDAlwaysReveal.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import <POP+MCAnimate/POP+MCAnimate.h>

#import "NSObject+VDReactiveCocoa.h"


static char Pan_View_Associated_Object_Key;
static char Pan_Offset_Associated_Object_Key;
static char Keyboard_Size_Associated_Object_Key;
static char Origin_Pan_View_Center_Associated_Object_Key;
static char Origin_Self_Center_In_Window_Associated_Object_Key;

static float DefalutRevealOffset = 30.0f;

@implementation UITextField (VDAlwaysReveal)


#pragma lazy initial
- (void)setVd_alwaysRevealPanView:(UIView *)vd_alwaysRevealPanView
{
    if (!self.vd_alwaysRevealPanView)
    {
        VDWeakifySelf;
        [VDRACNotification(UITextFieldTextDidBeginEditingNotification, self, VDRACIdentifier)subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            if ( [self keyboardSize] )
            {
                [self panViewForEditing:YES];
            }
        } ];
        
        [VDRACNotification(UITextFieldTextDidEndEditingNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self panViewForEditing:NO];
        } ];
        
        [VDRACNotification(UIKeyboardWillShowNotification, nil, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self setOriginPanViewCenter:[NSValue valueWithCGPoint:self.vd_alwaysRevealPanView.center] ];
            [self setOriginSelfCenterInWindow:[NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil] ] ];
            [self keyboardWillShow:notification];
        } ];

        [VDRACNotification(UIKeyboardDidHideNotification, nil, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self setOriginPanViewCenter:nil];
            [self setOriginSelfCenterInWindow:nil];
        } ];
        
        [VDRACNotification(UIKeyboardWillChangeFrameNotification, nil, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self keyboardSizeWillChange:notification];
        } ];
        
        
        [VDRACNotification(UIApplicationWillChangeStatusBarOrientationNotification, nil, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self resignFirstResponder];
        } ];
        
        if ( [vd_alwaysRevealPanView isMemberOfClass:[UIScrollView class] ] )
        {
            UIScrollView *panScrollView = (UIScrollView *)vd_alwaysRevealPanView;

            [VDRACKVO(panScrollView, contentOffset, VDRACIdentifier) subscribeNextForKVO:^(NSDictionary *change) {
                VDStrongifySelf;
                
                CGPoint oldContentOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
                CGPoint newContentOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
                
                CGPoint lastOriginSelfCenterInWindow = [ [self originSelfCenterInWindow] CGPointValue];
                lastOriginSelfCenterInWindow.y -= newContentOffset.y - oldContentOffset.y;
                
                [self setOriginSelfCenterInWindow:nil];
                [self setOriginSelfCenterInWindow:[NSValue valueWithCGPoint:lastOriginSelfCenterInWindow] ];
            } ];
        }
    }
    
    objc_setAssociatedObject(self, &Pan_View_Associated_Object_Key, vd_alwaysRevealPanView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)vd_alwaysRevealPanView
{
    return objc_getAssociatedObject(self, &Pan_View_Associated_Object_Key);
}

- (void)setVd_alwaysRevealPanOffset:(CGFloat)vd_alwaysRevealPanOffset
{
    objc_setAssociatedObject(self, &Pan_Offset_Associated_Object_Key, [NSNumber numberWithFloat:vd_alwaysRevealPanOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)vd_alwaysRevealPanOffset
{
    return [objc_getAssociatedObject(self, &Pan_Offset_Associated_Object_Key) floatValue];
}

- (void)setKeyboardSize:(NSValue *)keyboardSize
{
    objc_setAssociatedObject(self, &Keyboard_Size_Associated_Object_Key, keyboardSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)keyboardSize
{
    return objc_getAssociatedObject(self, &Keyboard_Size_Associated_Object_Key);
}

- (void)setOriginPanViewCenter:(NSValue *)originPanViewCenter
{
    if (originPanViewCenter && [self originPanViewCenter] )
    {
        return;
    }
    
    objc_setAssociatedObject(self.vd_alwaysRevealPanView, &Origin_Pan_View_Center_Associated_Object_Key, originPanViewCenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)originPanViewCenter
{
    return objc_getAssociatedObject(self.vd_alwaysRevealPanView, &Origin_Pan_View_Center_Associated_Object_Key);
}

- (void)setOriginSelfCenterInWindow:(NSValue *)originSelfCenterInWindow
{
    if (originSelfCenterInWindow && [self originSelfCenterInWindow] )
    {
        return;
    }
    
    objc_setAssociatedObject(self, &Origin_Self_Center_In_Window_Associated_Object_Key, originSelfCenterInWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)originSelfCenterInWindow
{
    return objc_getAssociatedObject(self, &Origin_Self_Center_In_Window_Associated_Object_Key);
}

#pragma private
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [ [userInfo objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (CGSizeEqualToSize(kbSize, CGSizeZero) )
    {
        [self setKeyboardSize:nil];
        [self panViewForEditing:NO];
        return;
    }
    
    if (VDIsIOS8)
    {
        [self setKeyboardSize:[NSValue valueWithCGSize:kbSize] ];
    }
    else
    {
        if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self setKeyboardSize:[NSValue valueWithCGSize:kbSize] ];
        }
        else
        {
            [self setKeyboardSize:[NSValue valueWithCGSize:CGSizeMake(kbSize.height, kbSize.width) ] ];
        }
    }
    
    [self panViewForEditing:YES];
}

- (void)keyboardSizeWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [ [userInfo objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (CGSizeEqualToSize(kbSize, [[self keyboardSize] CGSizeValue] ) )
    {
        return;
    }
    
    if (CGSizeEqualToSize(kbSize, CGSizeZero) )
    {
        [self setKeyboardSize:nil];
        [self panViewForEditing:NO];
        return;
    }
    
    if (VDIsIOS8)
    {
        [self setKeyboardSize:[NSValue valueWithCGSize:kbSize] ];
    }
    else
    {
        if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [self setKeyboardSize:[NSValue valueWithCGSize:kbSize] ];
        }
        else
        {
            [self setKeyboardSize:[NSValue valueWithCGSize:CGSizeMake(kbSize.height, kbSize.width) ] ];
        }
    }
    
    [self panViewForEditing:YES];
}

- (void)panViewForEditing:(BOOL)isEditing
{
    if (!self.vd_alwaysRevealPanView)
    {
        return;
    }
    
    if (isEditing && self.isFirstResponder)
    {
        [self.vd_alwaysRevealPanView.pop_stop center];
        
        CGPoint panViewCenter = self.vd_alwaysRevealPanView.center;
        
        float offset = [ [self originSelfCenterInWindow] CGPointValue].y + self.bounds.size.height / 2.0f + self.vd_alwaysRevealPanOffset + DefalutRevealOffset + [ [self keyboardSize] CGSizeValue].height - [self windowSize].height;
        offset = offset < 0.0f ? 0.0f : offset;
        
        if (offset <= 0.0f)
        {
            return;
        }
        
        if ( [self.vd_alwaysRevealPanView isKindOfClass:[UIScrollView class] ] )
        {
            CGPoint panViewOrigin = self.vd_alwaysRevealPanView.frame.origin;
            CGPoint panViewOriginInWindow = [self.vd_alwaysRevealPanView.superview convertPoint:panViewOrigin toView:nil];
            
            if (panViewOriginInWindow.y + self.bounds.size.height + DefalutRevealOffset + [ [self keyboardSize] CGSizeValue].height < [self windowSize].height)
            {
                CGPoint selfOrigin = self.frame.origin;
                CGPoint selfOriginInPanView = [self.superview convertPoint:selfOrigin toView:self.vd_alwaysRevealPanView];
                UIScrollView *panScrollView = (UIScrollView *)self.vd_alwaysRevealPanView;
                if (panScrollView.contentSize.height - selfOriginInPanView.y > self.bounds.size.height + DefalutRevealOffset + [ [self keyboardSize] CGSizeValue].height)
                {
                    [panScrollView setContentOffset:CGPointMake(panScrollView.contentOffset.x, panScrollView.contentOffset.y + offset) animated:YES];
                    return;
                }
            }
        }
        
        if (VDIsIOS8)
        {
            panViewCenter.y = [ [self originPanViewCenter] CGPointValue].y - offset;
        }
        else
        {
            if (self.vd_alwaysRevealPanView != VDWindow)
            {
                panViewCenter.y = [ [self originPanViewCenter] CGPointValue].y - offset;
            }
            else
            {
                if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
                {
                    panViewCenter.y = [ [self originPanViewCenter] CGPointValue].y - offset;
                }
                else if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
                {
                    panViewCenter.y = [ [self originPanViewCenter] CGPointValue].y + offset;
                }
                else if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
                {
                    panViewCenter.x = [ [self originPanViewCenter] CGPointValue].x - offset;
                }
                else if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                {
                    panViewCenter.x = [ [self originPanViewCenter] CGPointValue].y + offset;
                }
            }
        }
        
        self.vd_alwaysRevealPanView.pop_spring.center = panViewCenter;
    }
    
    if (!isEditing && !self.isFirstResponder && [self originPanViewCenter] )
    {
        [self.vd_alwaysRevealPanView.pop_stop center];
        
        CGPoint panViewCenter = [ [self originPanViewCenter] CGPointValue];
        
        VDWeakifySelf;
        [NSObject pop_animate:^(void){
            VDStrongifySelf;
            self.vd_alwaysRevealPanView.pop_spring.center = panViewCenter; // remove the animation for next offset calculate
        } completion:^(BOOL finished){
            if (!finished)
            {
                VDStrongifySelf;
                self.vd_alwaysRevealPanView.center = panViewCenter;
            }
        }];
    }
}

- (CGSize)windowSize
{
    CGSize windowSize = VDWindow.bounds.size;
    
    if (!VDIsIOS8)
    {
        if ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            windowSize = VDWindow.bounds.size;
        }
        else
        {
            windowSize = CGSizeMake(VDWindow.bounds.size.height, VDWindow.bounds.size.width);
        }
    }
    
    return windowSize;
}

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method

@end
