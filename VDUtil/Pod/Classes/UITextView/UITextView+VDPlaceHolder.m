//
//  UITextView+VDPlaceHolder.m
//  VDUtil
//
//  Created by FTET on 15/1/21.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UITextView+VDPlaceHolder.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"


static char Placeholder_Associated_Object_Key;
static char Placeholder_Label_Associated_Object_Key;

@implementation UITextView (VDPlaceHolder)


#pragma Accessors
#pragma Private Accessors
- (UILabel *)placeholderLabel
{
    UILabel *label = objc_getAssociatedObject(self, &Placeholder_Label_Associated_Object_Key);
    if (!label)
    {
        label = [ [UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        objc_setAssociatedObject(self, &Placeholder_Label_Associated_Object_Key, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

#pragma Public Accessors
- (void)setVd_placeholder:(NSString *)vd_placeholder
{
    vd_placeholder = vd_placeholder ? : @"";
    
    objc_setAssociatedObject(self, &Placeholder_Associated_Object_Key, vd_placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    VDWeakifySelf;
    [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self drawPlaceholder];
    } ];
    
    [VDRACObserve(self, text, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self drawPlaceholder];
    } ];
    
    [VDRACNotification(UITextViewTextDidChangeNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
        VDStrongifySelf;
        [self drawPlaceholder];
    } ];
    
    [self drawPlaceholder];
}

- (NSString *)vd_placeholder
{
    return objc_getAssociatedObject(self, &Placeholder_Associated_Object_Key);
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method
- (void)drawPlaceholder
{
    if (self.text.length == 0)
    {
        self.placeholderLabel.font = self.font;
        self.placeholderLabel.textColor = [UIColor grayColor];
        self.placeholderLabel.text = self.vd_placeholder;
        [self.placeholderLabel sizeToFit];
        
        CGRect frame = self.placeholderLabel.frame;
        frame.origin.x = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
        frame.origin.y = self.textContainerInset.top;
        frame.size.width = fminf(frame.size.width, self.textContainer.size.width - self.textContainer.lineFragmentPadding * 2.0f);
        
        self.placeholderLabel.frame = frame;
    }
    else
    {
        self.placeholderLabel.text = @"";
        self.placeholderLabel.frame = CGRectZero;
    }
}

#pragma Public Class Method

#pragma Public Instance Method

@end
