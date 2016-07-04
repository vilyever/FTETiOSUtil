//
//  UIImageView+VDFullscreen.m
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIImageView+VDFullscreen.h"

//#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import <Masonry/Masonry.h>

#import "NSObject+VDReactiveCocoa.h"

#import "NSObject+VDAspects.h"

#import "NSObject+VDPop.h"


//static char _Associated_Object_Key;


@implementation UIImageView (VDFullscreen)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Delegates
#pragma UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    UIView *view = scrollView.subviews[0];
//    view.center = CGPointMake(fmaxf(scrollView.contentSize.width, scrollView.frame.size.width) / 2.0f, fmaxf(scrollView.contentSize.height, scrollView.frame.size.height) / 2.0f);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    return scrollView.subviews[0];
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_enterImageViewFullscreenMode
{
    self.userInteractionEnabled = NO;
    
    __block id<AspectToken> prefersStatusBarHiddenAspectToken = [[UIViewController vd_topViewControllerWithRootViewController:nil] vdaspect_hookSelector:@selector(prefersStatusBarHidden) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        BOOL prefersStatusBarHidden = YES;
        NSInvocation *invocation = [info originalInvocation];
        [invocation setReturnValue:&prefersStatusBarHidden];
    } error:NULL];
    
    [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
    
    UIScrollView *scrollView = [ [UIScrollView alloc] initWithFrame:VDWindow.bounds];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1.0f;
    scrollView.contentSize = scrollView.bounds.size;
    [VDWindow vd_addSubview:scrollView scaleToFill:YES];
    
    UIImageView *imageView = [ [UIImageView alloc] init];
    imageView.image = self.image;
    imageView.clipsToBounds = self.clipsToBounds;
    
    __weak typeof(&*scrollView)weakScrollView = scrollView;
    __weak typeof(&*imageView)weakImageView = imageView;
    
    CGFloat selfAspectRatio = self.frame.size.width / self.frame.size.height;
    CGFloat imageAspectRatio = imageView.image.size.width / imageView.image.size.height;
    CGFloat scrollViewAspectRatio = scrollView.frame.size.width / scrollView.frame.size.height;
    
    __block CGRect originalFrame = CGRectZero;
    originalFrame.origin = [self convertPoint:self.bounds.origin toView:nil];
    originalFrame.size = self.frame.size;
    switch (self.contentMode) {
        case UIViewContentModeScaleToFill:
            break;
        case UIViewContentModeScaleAspectFit:
            if (selfAspectRatio > imageAspectRatio)
            {
                originalFrame.size.width = originalFrame.size.height * imageAspectRatio;
                originalFrame.origin.x += (self.frame.size.width - originalFrame.size.width) / 2.0f;
            }
            else
            {
                originalFrame.size.height = originalFrame.size.width / imageAspectRatio;
                originalFrame.origin.y += (self.frame.size.height - originalFrame.size.height) / 2.0f;
            }
            break;
        case UIViewContentModeScaleAspectFill:
            if (selfAspectRatio > imageAspectRatio)
            {
                originalFrame.size.height = originalFrame.size.width / imageAspectRatio;
                originalFrame.origin.y += (self.frame.size.height - originalFrame.size.height) / 2.0f;
            }
            else
            {
                originalFrame.size.width = originalFrame.size.height * imageAspectRatio;
                originalFrame.origin.x += (self.frame.size.width - originalFrame.size.width) / 2.0f;
            }
            break;
        case UIViewContentModeRedraw:
            break;
        case UIViewContentModeCenter:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += (self.frame.size.width - originalFrame.size.width) / 2.0f;
            originalFrame.origin.y += (self.frame.size.height - originalFrame.size.height) / 2.0f;
            break;
        case UIViewContentModeTop:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += (self.frame.size.width - originalFrame.size.width) / 2.0f;
            break;
        case UIViewContentModeBottom:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += (self.frame.size.width - originalFrame.size.width) / 2.0f;
            originalFrame.origin.y += self.frame.size.height - originalFrame.size.height;
            break;
        case UIViewContentModeLeft:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.y += (self.frame.size.height - originalFrame.size.height) / 2.0f;
            break;
        case UIViewContentModeRight:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += self.frame.size.width - originalFrame.size.width;
            originalFrame.origin.y += (self.frame.size.height - originalFrame.size.height) / 2.0f;
            break;
        case UIViewContentModeTopLeft:
            originalFrame.size = imageView.image.size;
            break;
        case UIViewContentModeTopRight:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += self.frame.size.width - originalFrame.size.width;
            break;
        case UIViewContentModeBottomLeft:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.y += self.frame.size.height - originalFrame.size.height;
            break;
        case UIViewContentModeBottomRight:
            originalFrame.size = imageView.image.size;
            originalFrame.origin.x += self.frame.size.width - originalFrame.size.width;
            originalFrame.origin.y += self.frame.size.height - originalFrame.size.height;
            break;
            
        default:
            break;
    }
    
    imageView.frame = originalFrame;
    
    __block CGFloat originalCornerRadius = self.layer.cornerRadius;
    imageView.layer.cornerRadius = originalCornerRadius;
    
    [scrollView addSubview:imageView];
    
    __block CGRect bounds = originalFrame;
    bounds.origin = CGPointZero;
    if (imageView.image.size.width > scrollView.frame.size.width
        && imageAspectRatio >= scrollViewAspectRatio)
    {
        bounds.size.width = scrollView.frame.size.width;
        bounds.size.height = bounds.size.width / imageAspectRatio;
        scrollView.maximumZoomScale = imageView.image.size.width * 2.0f / scrollView.frame.size.width;
    }
    else if (imageView.image.size.height > VDWindow.frame.size.height
             && imageAspectRatio <= scrollViewAspectRatio)
    {
        bounds.size.height = scrollView.frame.size.height;
        bounds.size.width = bounds.size.height * imageAspectRatio;
        scrollView.maximumZoomScale = imageView.image.size.height * 2.0f / scrollView.frame.size.height;
    }
    else
    {
        bounds.size = imageView.image.size;
        scrollView.maximumZoomScale = 2.0f;
    }
    
    [CALayer vdpop_registerAnimatablePropertyCALayerCornerRadius];
    
    [NSObject pop_animate:^{
        __strong __typeof(&*weakScrollView)scrollView = weakScrollView;
        __strong __typeof(&*weakImageView)imageView = weakImageView;
        imageView.pop_spring.bounds = bounds;
        imageView.pop_spring.center = CGPointMake(scrollView.contentSize.width / 2.0f, scrollView.contentSize.height / 2.0f);
        imageView.layer.pop_spring.cornerRadius = 0.0f;
        scrollView.pop_linear.backgroundColor = VDColorFromRGBA(0x000000DD);
    } completion:^(BOOL finished) {
        
    } ];

    __block id<AspectToken> viewForZoomingInScrollViewAspectToken = [self vdaspect_hookSelector:@selector(viewForZoomingInScrollView:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
//        __strong __typeof(&*weakScrollView)scrollView = weakScrollView;
        __strong __typeof(&*weakImageView)imageView = weakImageView;
        
        NSInvocation *invocation = [info originalInvocation];
        [invocation setReturnValue:&imageView];
    } error:NULL];
    
    __block id<AspectToken> scrollViewDidZoomAspectToken = [self vdaspect_hookSelector:@selector(scrollViewDidZoom:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        __strong __typeof(&*weakScrollView)scrollView = weakScrollView;
        __strong __typeof(&*weakImageView)imageView = weakImageView;
        
        imageView.contentScaleFactor = scrollView.zoomScale;
        imageView.center = CGPointMake(fmaxf(scrollView.contentSize.width, scrollView.frame.size.width) / 2.0f, fmaxf(scrollView.contentSize.height, scrollView.frame.size.height) / 2.0f);
    } error:NULL];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [scrollView vdrac_addDoubleTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
        __strong __typeof(&*weakScrollView)scrollView = weakScrollView;
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale)
        {
            [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
        }
        else if (scrollView.zoomScale == scrollView.minimumZoomScale)
        {
            [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
        }
    }];
    
    VDWeakifySelf;
    UITapGestureRecognizer *tapGestureRecognizer = [scrollView vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
        VDStrongifySelf;
        __strong __typeof(&*weakScrollView)scrollView = weakScrollView;
        __strong __typeof(&*weakImageView)imageView = weakImageView;
        
        [prefersStatusBarHiddenAspectToken remove];
        [[UIViewController vd_topViewControllerWithRootViewController:nil] setNeedsStatusBarAppearanceUpdate];
        
        scrollView.userInteractionEnabled = NO;

        __block id<AspectToken> scrollViewDidEndZoomingAspectToken = [self vdaspect_hookSelector:@selector(scrollViewDidEndZooming:withView:atScale:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            
            [NSObject pop_animate:^{
                imageView.pop_spring.frame = originalFrame;
                imageView.layer.pop_spring.cornerRadius = originalCornerRadius;
                scrollView.pop_linear.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [scrollViewDidEndZoomingAspectToken remove];
                [viewForZoomingInScrollViewAspectToken remove];
                [scrollViewDidZoomAspectToken remove];
                
                [scrollView removeFromSuperview];
                
                self.userInteractionEnabled = YES;
            } ];
            
        } error:NULL];
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale)
        {
            [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
        }
        else
        {
            [scrollView.delegate scrollViewDidEndZooming:scrollView withView:imageView atScale:1.0f];
        }

    } ];
    
    [tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

- (void)vd_activateTapToEnterImageViewFullscreenMode
{
    self.userInteractionEnabled = YES;
    VDWeakifySelf;
    [self vdrac_addTapGestureRecognizerWithSubscribeNext:^(UIGestureRecognizer *gestureRecognizer) {
        VDStrongifySelf;
        [self vd_enterImageViewFullscreenMode];
    } ];
}

@end
