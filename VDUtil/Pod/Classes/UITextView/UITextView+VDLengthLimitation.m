//
//  UITextView+VDLengthLimitation.m
//  VDUtil
//
//  Created by FTET on 15/1/21.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UITextView+VDLengthLimitation.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"


static char Length_Limitation_Associated_Object_Key;
static char Length_Limitation_Label_Associated_Object_Key;

@implementation UITextView (VDLengthLimitation)


#pragma Accessors
#pragma Private Accessors
- (UILabel *)lengthLimitationLabel
{
    UILabel *label = objc_getAssociatedObject(self, &Length_Limitation_Label_Associated_Object_Key);
    if (!label)
    {
        label = [ [UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:label];
        objc_setAssociatedObject(self, &Length_Limitation_Label_Associated_Object_Key, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

#pragma Public Accessors
- (void)setVd_lengthLimitation:(NSInteger)vd_lengthLimitation
{
    objc_setAssociatedObject(self, &Length_Limitation_Associated_Object_Key, @(vd_lengthLimitation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.vd_lengthLimitation > 0)
    {
        VDWeakifySelf;
        [VDRACObserve(self, text, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        [VDRACObserve(self, frame, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        [VDRACObserve(self, textContainerInset, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        [VDRACObserve(self.textContainer, size, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        
        [VDRACNotification(UITextViewTextDidChangeNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self drawLengthLimitation];
        } ];
        
//        [VDObserve(self, frame) nextActionWithTag:@"setLengthLimitation" action:^(NSDictionary *change) {
//            [self drawLengthLimitation];
//        } ];
//        [VDObserve(self, bounds) nextActionWithTag:@"setLengthLimitation" action:^(NSDictionary *change) {
//            [self drawLengthLimitation];
//        } ];
//        [VDObserve(self, text) nextActionWithTag:@"setLengthLimitation" action:^(NSDictionary *change) {
//            [self drawLengthLimitation];
//        } ];
//        [VDObserve(self, textContainerInset) nextActionWithTag:@"setLengthLimitation" action:^(NSDictionary *change) {
//            [self drawLengthLimitation];
//        } ];
//        [VDObserve(self.textContainer, size) nextActionWithTag:@"setLengthLimitation" action:^(NSDictionary *change) {
//            [self drawLengthLimitation];
//        } ];
//        
//        [VDNotification(self, UITextViewTextDidChangeNotification, self) nextActionWithTag:@"setLengthLimitation" action:^(NSNotification *notification) {
//            [self drawLengthLimitation];
//        } ];
    }
    else
    {
//        [VDObserve(self, frame) removeActionWithTag:@"setLengthLimitation"];
//        [VDObserve(self, bounds) removeActionWithTag:@"setLengthLimitation"];
//        [VDObserve(self, text) removeActionWithTag:@"setLengthLimitation"];
//        [VDObserve(self, textContainerInset) removeActionWithTag:@"setLengthLimitation"];
//        [VDObserve(self.textContainer, size) removeActionWithTag:@"setLengthLimitation"];
//
//        [VDNotification(self, UITextViewTextDidChangeNotification, self) removeActionWithTag:@"setLengthLimitation"];
    }
    
    [self drawLengthLimitation];
}

- (NSInteger)vd_lengthLimitation
{
    return [objc_getAssociatedObject(self, &Length_Limitation_Associated_Object_Key) integerValue];
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method
- (void)drawLengthLimitation
{
    self.lengthLimitationLabel.text = [NSString stringWithFormat:@"%@", VDNumberWithInteger(self.vd_lengthLimitation - self.text.length) ];
    [self.lengthLimitationLabel sizeToFit];
    
    if (self.text.length > self.vd_lengthLimitation)
    {
        self.lengthLimitationLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.lengthLimitationLabel.textColor = [UIColor grayColor];
    }
    
    if (self.textContainerInset.bottom < self.lengthLimitationLabel.frame.size.height)
    {
        UIEdgeInsets insets = self.textContainerInset;
        insets.bottom = self.lengthLimitationLabel.frame.size.height;
        self.textContainerInset = insets;
    }
    
    CGRect frame = self.lengthLimitationLabel.frame;
    frame.origin.x = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    frame.origin.y = self.textContainerInset.top;
    frame.size.width = fminf(frame.size.width, self.textContainer.size.width - self.textContainer.lineFragmentPadding * 2.0f);
    
    CGFloat contentHeight = fmaxf(self.frame.size.height, self.contentSize.height);
    self.lengthLimitationLabel.center = CGPointMake(self.frame.size.width - self.textContainer.lineFragmentPadding - self.lengthLimitationLabel.frame.size.width / 2.0f, contentHeight - self.lengthLimitationLabel.frame.size.height / 2.0f);
}

#pragma Public Class Method

#pragma Public Instance Method


@end
