//
//  UIButton+VDUtil.m
//  VDUtil
//
//  Created by FTET on 15/2/13.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIButton+VDUtil.h"

//#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"

#import "NSObject+VDAspects.h"

#import "NSObject+VDPop.h"


//static char _Associated_Object_Key;


@implementation UIButton (VDUtil)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method
- (void)updateImage
{
    UIImage *normalImage = [self imageForState:UIControlStateNormal];
    UIImage *highlightedImage = [self imageForState:UIControlStateHighlighted];
    UIImage *selectedImage = [self imageForState:UIControlStateSelected];
    UIImage *disabledImage = [self imageForState:UIControlStateDisabled];
    
    if (normalImage.size.height > self.frame.size.height)
    {
        [self setImage:[UIImage vd_resizeImage:normalImage withProportion:self.frame.size.height / normalImage.size.height] forState:UIControlStateNormal];
    }
    
    if (highlightedImage != normalImage
        && highlightedImage.size.height > self.frame.size.height)
    {
        [self setImage:[UIImage vd_resizeImage:highlightedImage withProportion:self.frame.size.height / highlightedImage.size.height] forState:UIControlStateHighlighted];
    }
    
    if (selectedImage != normalImage
        && selectedImage.size.height > self.frame.size.height)
    {
        [self setImage:[UIImage vd_resizeImage:selectedImage withProportion:self.frame.size.height / selectedImage.size.height] forState:UIControlStateSelected];
    }
    
    if (disabledImage != normalImage
        && disabledImage.size.height > self.frame.size.height)
    {
        [self setImage:[UIImage vd_resizeImage:disabledImage withProportion:self.frame.size.height / disabledImage.size.height] forState:UIControlStateDisabled];
    }
}

#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_restrictImageAspectFit
{
    VDWeakifySelf;
    [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self updateImage];
    } ];
}

- (void)vd_setBackgroundColor:(UIColor *)color
{
    [self setBackgroundColor:color];
    
    VDWeakifySelf;
    [VDRACObserve(self, highlighted, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        if (color)
        {
            BOOL highlighted = [x boolValue];
            
            if (highlighted)
            {
                CGFloat hue, saturation, brightness, alpha;
                [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
                brightness = brightness * 0.8f;
                [self setBackgroundColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
            }
            else
            {
                [self setBackgroundColor:color];
            }
        }
    } ];
    
    [VDRACObserve(self, enabled, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        if (color)
        {
            BOOL enabled = [x boolValue];
            
            if (!enabled)
            {
                CGFloat hue, saturation, brightness, alpha;
                [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
                hue = hue * 0.5f;
                saturation = saturation * 0.5f;
                brightness = brightness * 0.5f;
                [self setBackgroundColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
            }
            else
            {
                [self setBackgroundColor:color];
            }
        }
    } ];
}

@end
