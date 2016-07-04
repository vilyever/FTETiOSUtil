//
//  UILabel+VDMarquee.m
//  VDUtil
//
//  Created by FTET on 15/1/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UILabel+VDMarquee.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"

#import "NSObject+VDPop.h"


static char Auto_Marquee_Associated_Object_Key;
static char Marqueeing_Associated_Object_Key;

static char Original_Text_Associated_Object_Key;
static char Marquee_First_Label_Associated_Object_Key;
static char Marquee_Second_Label_Associated_Object_Key;

@implementation UILabel (VDMarquee)

#pragma Accessors
#pragma Private Accessors
- (void)setOriginalText:(NSString *)originalText
{
    objc_setAssociatedObject(self, &Original_Text_Associated_Object_Key, originalText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)originalText
{
    return objc_getAssociatedObject(self, &Original_Text_Associated_Object_Key);
}

- (void)setMarqueeFirstLabel:(UILabel *)marqueeFirstLabel
{
    objc_setAssociatedObject(self, &Marquee_First_Label_Associated_Object_Key, marqueeFirstLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)marqueeFirstLabel
{
    UILabel *label = objc_getAssociatedObject(self, &Marquee_First_Label_Associated_Object_Key);
    if (!label)
    {
        label = [ [UILabel alloc] initWithFrame:self.bounds];
        [self setMarqueeFirstLabel:label];
    }
    
    return label;
}

- (void)setMarqueeSecondLabel:(UILabel *)marqueeSecondLabel
{
    objc_setAssociatedObject(self, &Marquee_Second_Label_Associated_Object_Key, marqueeSecondLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)marqueeSecondLabel
{
    UILabel *label = objc_getAssociatedObject(self, &Marquee_Second_Label_Associated_Object_Key);
    if (!label)
    {
        label = [ [UILabel alloc] initWithFrame:self.bounds];
        [self setMarqueeSecondLabel:label];
    }
    
    return label;
}

#pragma Public Accessors
- (void)setVd_isAutoEnterMarqueeModeOnTextTooLong:(BOOL)vd_isAutoEnterMarqueeModeOnTextTooLong
{
    objc_setAssociatedObject(self, &Auto_Marquee_Associated_Object_Key, [NSNumber numberWithBool:vd_isAutoEnterMarqueeModeOnTextTooLong], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (vd_isAutoEnterMarqueeModeOnTextTooLong)
    {
        self.clipsToBounds = YES;
    }
    
    VDWeakifySelf;
    [VDRACObserve(self, text, VDRACIdentifier) subscribeNext:^(NSString *newText) {
        VDStrongifySelf;
        if ([self.originalText isEqualToString:newText] || newText.length == 0)
        {
            return;
        }
        self.originalText = newText;
        [self updateMarquee];
    } ];
    [VDRACObserve(self, frame, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self updateMarquee];
    } ];
    [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self updateMarquee];
    } ];
    [VDRACObserve(self, font, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self updateMarquee];
    } ];
    [VDRACObserve(self, numberOfLines, VDRACIdentifier) subscribeNext:^(id x) {
        VDStrongifySelf;
        [self updateMarquee];
    } ];
    
    [self updateMarquee];
    
//    [VDObserve(self, text) nextActionWithTag:@"Marquee" action:^(NSDictionary *change) {
//        [self updateMarquee];
//    } ];
//    [VDObserve(self, frame) nextActionWithTag:@"Marquee" action:^(NSDictionary *change) {
//        [self updateMarquee];
//    } ];
//    [VDObserve(self, bounds) nextActionWithTag:@"Marquee" action:^(NSDictionary *change) {
//        [self updateMarquee];
//    } ];
//    [VDObserve(self, font) nextActionWithTag:@"Marquee" action:^(NSDictionary *change) {
//        [self updateMarquee];
//    } ];
//    [VDObserve(self, numberOfLines) nextActionWithTag:@"Marquee" action:^(NSDictionary *change) {
//        [self updateMarquee];
//    } ];
}

- (BOOL)vd_isAutoEnterMarqueeModeOnTextTooLong
{
    return [objc_getAssociatedObject(self, &Auto_Marquee_Associated_Object_Key) boolValue];
}

- (void)setVd_isMarqueeing:(BOOL)vd_isMarqueeing
{
    objc_setAssociatedObject(self, &Marqueeing_Associated_Object_Key, [NSNumber numberWithBool:vd_isMarqueeing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)vd_isMarqueeing
{
    return [objc_getAssociatedObject(self, &Marqueeing_Associated_Object_Key) boolValue];
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method
- (void)updateMarquee
{
    if (self.vd_isMarqueeing)
    {
        self.vd_isMarqueeing = NO;
        [self.marqueeFirstLabel.pop_stop frame];
        [self.marqueeSecondLabel.pop_stop frame];
        [self.marqueeFirstLabel removeFromSuperview];
        [self.marqueeSecondLabel removeFromSuperview];
    }

    if (!self.vd_isAutoEnterMarqueeModeOnTextTooLong
        || self.numberOfLines != 1
        || [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width < self.frame.size.width)
    {
        self.text = self.originalText;
        return;
    }
    
    if (self.originalText.length == 0)
    {
        self.originalText = self.text;
    }
    self.text = @"";
    
    self.marqueeFirstLabel.backgroundColor = [UIColor clearColor];
    self.marqueeFirstLabel.textAlignment = self.textAlignment;
    self.marqueeFirstLabel.numberOfLines = self.numberOfLines;
    self.marqueeFirstLabel.font = self.font;
    self.marqueeFirstLabel.textColor = self.textColor;
    self.marqueeFirstLabel.text = self.originalText;
    self.marqueeFirstLabel.frame = CGRectMake(self.bounds.size.width / 2.0f, (self.bounds.size.height - self.marqueeFirstLabel.bounds.size.height) / 2.0f, [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width, self.marqueeFirstLabel.bounds.size.height);
    [self addSubview:self.marqueeFirstLabel];
    
    self.marqueeSecondLabel.backgroundColor = [UIColor clearColor];
    self.marqueeSecondLabel.textAlignment = self.textAlignment;
    self.marqueeSecondLabel.numberOfLines = self.numberOfLines;
    self.marqueeSecondLabel.font = self.font;
    self.marqueeSecondLabel.textColor = self.textColor;
    self.marqueeSecondLabel.text = self.originalText;
    self.marqueeSecondLabel.frame = CGRectMake(self.marqueeFirstLabel.frame.origin.x + self.marqueeFirstLabel.frame.size.width + self.bounds.size.width / 2.0f, (self.bounds.size.height - self.marqueeSecondLabel.bounds.size.height) / 2.0f, [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width, self.marqueeSecondLabel.bounds.size.height);
    [self addSubview:self.marqueeSecondLabel];
    
    self.vd_isMarqueeing = YES;
    [self marqueeWithLeftLabel:self.marqueeFirstLabel rightLabel:self.marqueeSecondLabel];
}

- (void)marqueeWithLeftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
//    VDWeakifySelf;
//    [UIView animateWithDuration:( [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width / self.bounds.size.width * 10.0f) delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//        VDStrongifySelf;
//        
//        [leftLabel vd_setOriginX:-leftLabel.bounds.size.width];
//        [rightLabel vd_setOriginX:self.bounds.size.width / 2.0f];
//        
//    } completion:^(BOOL finished) {
//        VDStrongifySelf;
//        
//        if (self.vd_isMarqueeing)
//        {
//            leftLabel.frame = CGRectMake(rightLabel.frame.origin.x + rightLabel.frame.size.width + self.bounds.size.width / 2.0f, (self.bounds.size.height - leftLabel.bounds.size.height) / 2.0f, leftLabel.bounds.size.width, leftLabel.bounds.size.height);
//            [self marqueeWithLeftLabel:rightLabel rightLabel:leftLabel];
//        }
//    } ];
    
    VDWeakifySelf;
    __weak UILabel *weakLeftLabel = leftLabel;
    __weak UILabel *weakRightLabel = rightLabel;
    [NSObject pop_animate:^{
        VDStrongifySelf;
        __strong UILabel *leftLabel = weakLeftLabel;
        __strong UILabel *rightLabel = weakRightLabel;
        
        CGRect leftLabelFrame = leftLabel.frame;
        leftLabelFrame.origin.x = -leftLabel.bounds.size.width;
        leftLabel.pop_duration = [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width / self.bounds.size.width * 10.0f;
        leftLabel.pop_linear.frame = leftLabelFrame;
        
        CGRect rightLabelFrame = rightLabel.frame;
        rightLabelFrame.origin.x = self.bounds.size.width / 2.0f;
        rightLabel.pop_duration = [self.originalText vd_frameWithFont:self.font withMaxBoundsWidth:HUGE_VALF].size.width / self.bounds.size.width * 10.0f;
        rightLabel.pop_linear.frame = rightLabelFrame;
        
    } completion:^(BOOL finished) {
        
        if (!finished)
        {
            return;
        }
        
        VDStrongifySelf;
        __strong UILabel *leftLabel = weakLeftLabel;
        __strong UILabel *rightLabel = weakRightLabel;
        
        leftLabel.frame = CGRectMake(rightLabel.frame.origin.x + rightLabel.frame.size.width + self.bounds.size.width / 2.0f, (self.bounds.size.height - leftLabel.bounds.size.height) / 2.0f, leftLabel.bounds.size.width, leftLabel.bounds.size.height);
        [self marqueeWithLeftLabel:rightLabel rightLabel:leftLabel];
    } ];
    
}

#pragma Public Class Method

#pragma Public Instance Method
//- (void)vd_activateAutoEnterMarqueeModeOnTextTooLong
//{
//    if ( [self vd_isAutoMaquee] )
//    {
//        return;
//    }
//    
//    VDWeakifySelf;
//    __block RACDisposable *textDisposable = [VDRACObserve(self, text, VDRACIdentifier) subscribeNext:^(id x) {
//        VDStrongifySelf;
//        [self updateMarquee];
//    } ];
//    __block RACDisposable *frameDisposable = [VDRACObserve(self, frame, VDRACIdentifier) subscribeNext:^(id x) {
//        VDStrongifySelf;
//        [self updateMarquee];
//    } ];
//    __block RACDisposable *boundsDisposable = [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(id x) {
//        VDStrongifySelf;
//        [self updateMarquee];
//    } ];
//    __block RACDisposable *fontDisposable = [VDRACObserve(self, font, VDRACIdentifier) subscribeNext:^(id x) {
//        VDStrongifySelf;
//        [self updateMarquee];
//    } ];
//    __block RACDisposable *numberOfLinesDisposable = [VDRACObserve(self, numberOfLines, VDRACIdentifier) subscribeNext:^(id x) {
//        VDStrongifySelf;
//        [self updateMarquee];
//    } ];
//    
//    __block id<AspectToken> isAutoMaqueeAspectToken = [self vdaspect_hookSelector:@selector(vd_isAutoMaquee) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
//        
//        BOOL isAutoMarquee = YES;
//        NSInvocation *invocation = [info originalalInvocation];
//        [invocation setReturnValue:&isAutoMarquee];
//        
//    } error:NULL];
//    
//    __block id<AspectToken> deactivateAutoEnterMarqueeModeOnTextTooLongAspectToken = [self vdaspect_hookSelector:@selector(vd_deactivateAutoEnterMarqueeModeOnTextTooLong) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
//        
//        [deactivateAutoEnterMarqueeModeOnTextTooLongAspectToken remove];
//        
//        [isAutoMaqueeAspectToken remove];
//        
//        [textDisposable dispose];
//        [frameDisposable dispose];
//        [boundsDisposable dispose];
//        [fontDisposable dispose];
//        [numberOfLinesDisposable dispose];
//        
//    } error:NULL];
//    [self setAutoMarquee:YES];
//}

//- (void)vd_deactivateAutoEnterMarqueeModeOnTextTooLong
//{
//    if (![self vd_isAutoMaquee] )
//    {
//        return;
//    }
//    [self setAutoMarquee:NO];
//}


@end
