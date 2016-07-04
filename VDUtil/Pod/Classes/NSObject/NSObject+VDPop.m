//
//  NSObject+VDPop.m
//  VDUtil
//
//  Created by FTET on 15/2/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDPop.h"

//#import <objc/runtime.h>

#import <VDKit/VDKit.h>


//static char _Associated_Object_Key;


@implementation NSObject (VDPop)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
+ (void)vdpop_registerAnimatablePropertyCALayerCornerRadius
{
    CALayer *layer;
    [CALayer pop_registerAnimatablePropertyWithName:VDKeyPath(layer, cornerRadius) readBlock:^(CALayer *layer, CGFloat *values) {
        values[0] = layer.cornerRadius;
    } writeBlock:^(CALayer *layer, const CGFloat *values) {
        layer.cornerRadius = values[0];
    } threshold:0.01f];
}

+ (void)vdpop_registerAnimatablePropertyScrollViewZoomScale
{
    UIScrollView *scrollView;
    [UIScrollView pop_registerAnimatablePropertyWithName:VDKeyPath(scrollView, zoomScale) readBlock:^(UIScrollView *scrollView, CGFloat *values) {
        values[0] = scrollView.zoomScale;
    } writeBlock:^(UIScrollView *scrollView, const CGFloat *values) {
        scrollView.zoomScale = values[0];
    } threshold:0.01f];
}

//+ (void)vdpop_registerAnimatablePropertyUILabelTextColor
//{
//    UILabel *label;
//    [UILabel pop_registerAnimatablePropertyWithName:VDKeyPath(label, textColor) readBlock:^(UILabel *label, CGFloat *values) {
//        POPUIColorGetRGBAComponents(label.textColor, values);
//    } writeBlock:^(UILabel *label, const CGFloat *values) {
//        label.textColor = POPUIColorRGBACreate(values);
//    } threshold:0.01f];
//}

#pragma Public Instance Method


#pragma Load

@end
