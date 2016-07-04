//
//  UITextField+VDFloatingTip.m
//  VDTextInPut
//
//  Created by FTET on 14/12/16.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "UITextField+VDFloatingTip.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import <POP+MCAnimate/POP+MCAnimate.h>

#import "NSObject+VDReactiveCocoa.h"


#define DEFAULT_TIP_TEXT_FONT [UIFont fontWithName:@"AmericanTypewriter-Bold" size:8]
#define DEFAULT_TIP_TEXT_COLOR VDColorFromRGB(VDC_DODGER_BLUE)
#define DEFAULT_UNFOCUS_TEXT_COLOR [UIColor colorWithWhite:0.7f alpha:0.9f]

#define DEFAULT_MISMATCH_TIP_TEXT_COLOR [UIColor redColor]

static CGFloat FloatingTipDefaultTopMargin = 5.0f;

static char Floating_Tip_State_Associated_Object_Key;
static char Floating_Tip_Colors_Associated_Object_Key;
static char Floating_Tip_Associated_Object_Key;
static char Floating_Tip_Label_Associated_Object_Key;
static char Regex_Associated_Object_Key;
static char Mismatch_Regex_Letter_Associated_Object_Key;

@implementation UITextField (VDFloatingTip)


#pragma lazy initial
- (void)setVd_floatingTipState:(VDFloatingTipState)vd_floatingTipState
{
    if (vd_floatingTipState == VDFloatingTipStateAll)
    {
        return;
    }
    
    objc_setAssociatedObject(self, &Floating_Tip_State_Associated_Object_Key, [NSNumber numberWithInt:vd_floatingTipState], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.floatingTipLabel setTextColor:[self.floatingTipColors objectAtIndex:vd_floatingTipState] ];
    self.floatingTipLabel.text = vd_floatingTipState == VDFloatingTipStateError ? self.vd_mismatchFloatingTipRegexLetter : self.vd_floatingTip;
}

- (VDFloatingTipState)vd_floatingTipState
{
    NSNumber *state = objc_getAssociatedObject(self, &Floating_Tip_State_Associated_Object_Key);
    return [state integerValue];
}

- (NSMutableArray *)floatingTipColors
{
    NSMutableArray *colors = objc_getAssociatedObject(self, &Floating_Tip_Colors_Associated_Object_Key);
    
    if (!colors)
    {
        colors = [ [NSMutableArray alloc] init];
        
        for (int i = VDFloatingTipStateHide; i <= VDFloatingTipStateError; i++)
        {
            [colors addObject:DEFAULT_TIP_TEXT_COLOR];
        }
        
        [colors replaceObjectAtIndex:VDFloatingTipStateFocus withObject:DEFAULT_TIP_TEXT_COLOR];
        [colors replaceObjectAtIndex:VDFloatingTipStateUnfocus withObject:DEFAULT_UNFOCUS_TEXT_COLOR];
        [colors replaceObjectAtIndex:VDFloatingTipStateError withObject:DEFAULT_MISMATCH_TIP_TEXT_COLOR];
        
        objc_setAssociatedObject(self, &Floating_Tip_Colors_Associated_Object_Key, colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return colors;
}

- (void)setVd_floatingTip:(NSString *)vd_floatingTip
{
    if (!vd_floatingTip)
    {
        vd_floatingTip = self.placeholder;
    }
    
    if (self.vd_floatingTipState != VDFloatingTipStateError)
    {
        [self.floatingTipLabel setText:vd_floatingTip];
    }
    else
    {
        [self.floatingTipLabel setText:self.vd_mismatchFloatingTipRegexLetter];
    }
    
    objc_setAssociatedObject(self, &Floating_Tip_Associated_Object_Key,vd_floatingTip, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)vd_floatingTip
{
    return objc_getAssociatedObject(self, &Floating_Tip_Associated_Object_Key);
}

- (void)setVd_floatingTipRegex:(NSString *)vd_floatingTipRegex
{
    objc_setAssociatedObject(self, &Regex_Associated_Object_Key, vd_floatingTipRegex, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)vd_floatingTipRegex
{
    return objc_getAssociatedObject(self, &Regex_Associated_Object_Key);
}

- (void)setVd_mismatchFloatingTipRegexLetter:(NSString *)vd_mismatchFloatingTipRegexLetter
{
    objc_setAssociatedObject(self, &Mismatch_Regex_Letter_Associated_Object_Key, vd_mismatchFloatingTipRegexLetter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)vd_mismatchFloatingTipRegexLetter
{
    return objc_getAssociatedObject(self, &Mismatch_Regex_Letter_Associated_Object_Key);
}

- (UILabel *)floatingTipLabel
{
    UILabel *tipLabel = objc_getAssociatedObject(self, &Floating_Tip_Label_Associated_Object_Key);
    if (!tipLabel)
    {   // init tip tabel and add observer for change tip state
        tipLabel = [ [UILabel alloc] initWithFrame:[self placeholderRectForBounds:self.bounds] ];
        tipLabel.font = DEFAULT_TIP_TEXT_FONT;
        tipLabel.textAlignment = self.textAlignment;
        [tipLabel setHidden:YES];
        [self addSubview:tipLabel];
        
        objc_setAssociatedObject(self, &Floating_Tip_Label_Associated_Object_Key, tipLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        VDWeakifySelf;
        [VDRACNotification(UITextFieldTextDidChangeNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self textDidChange];
        } ];
        
        [VDRACNotification(UITextFieldTextDidBeginEditingNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self textDidBeginEditing];
        } ];
        
        [VDRACNotification(UITextFieldTextDidEndEditingNotification, self, VDRACIdentifier) subscribeNextForNotification:^(NSNotification *notification) {
            VDStrongifySelf;
            [self textDidEndEditing];
        } ];
        
        [VDRACObserve(self, center, VDRACIdentifier) subscribeNext:^(NSValue *newCenter) {
            VDStrongifySelf;
            CGPoint center = [newCenter CGPointValue];
            self.floatingTipLabel.center = center;
        } ];
        
        [VDRACObserve(self, bounds, VDRACIdentifier) subscribeNext:^(NSValue *newBounds) {
            VDStrongifySelf;
            CGRect bounds = [newBounds CGRectValue];
            self.floatingTipLabel.bounds = bounds;
        } ];
        
        [VDRACObserve(self, textAlignment, VDRACIdentifier) subscribeNext:^(NSNumber *newTextAlignment) {
            VDStrongifySelf;
            [self.floatingTipLabel setTextAlignment:[newTextAlignment integerValue] ];
        } ];
        
        [VDRACObserve(self, text, VDRACIdentifier) subscribeNext:^(id x) {
            VDStrongifySelf;
            [self textDidChange];
        } ];
        
    }
    
    return tipLabel;
}


#pragma private
- (void)textDidChange
{
    [self displayTipLabel];
}

- (void)textDidBeginEditing
{
    [self displayTipLabel];
}

- (void)textDidEndEditing
{
    [self displayTipLabel];
}

/**
 *  display tip label for different state
 */
- (void)displayTipLabel
{
    if (self.text.length <= 0)
    {
        [self hideTipLabel];
        return;
    }
    
    VDFloatingTipState preState = self.vd_floatingTipState;
    
    if (![self vd_isRegexMatched] )
    {
        self.vd_floatingTipState = VDFloatingTipStateError;
    }
    else
    {
        self.vd_floatingTipState = self.isFirstResponder ? VDFloatingTipStateFocus : VDFloatingTipStateUnfocus;
    }
    
    if (preState == VDFloatingTipStateHide)
    {
        [self.floatingTipLabel.pop_stop frame];
        
        CGRect frame = self.floatingTipLabel.frame;
        frame.origin.x = [self placeholderRectForBounds:self.bounds].origin.x;
        frame.origin.y = FloatingTipDefaultTopMargin;
        frame.size.width = [self placeholderRectForBounds:self.bounds].size.width;
        NSDictionary *attributes = @{NSFontAttributeName:self.floatingTipLabel.font};
        CGRect textFrame = [self.floatingTipLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        frame.size.height = textFrame.size.height;
        
        [self.floatingTipLabel setHidden:NO];
        
        VDWeakifySelf;
        [NSObject pop_animate:^(void) {
            VDStrongifySelf;
            self.floatingTipLabel.pop_spring.frame = frame;
            self.floatingTipLabel.pop_spring.alpha = 1.0f;
        } completion:^(BOOL finished) {

            if (finished)
            {
                VDStrongifySelf;
                [self.floatingTipLabel setHidden:NO];
            }
        } ];
    }
}

- (void)hideTipLabel
{
    if (self.vd_floatingTipState == VDFloatingTipStateHide)
    {
        return;
    }
    
    VDFloatingTipState preState = self.vd_floatingTipState;
    
    self.vd_floatingTipState = VDFloatingTipStateHide;
    
    if (preState != VDFloatingTipStateHide)
    {
        [self.floatingTipLabel.pop_stop frame];
        
        VDWeakifySelf;
        [NSObject pop_animate:^(void) {
            VDStrongifySelf;
            self.floatingTipLabel.pop_spring.frame = [self placeholderRectForBounds:self.bounds];
            self.floatingTipLabel.pop_spring.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                VDStrongifySelf;
                [self.floatingTipLabel setHidden:YES];
            }
        } ];
    }
}

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_setFloatingTipLabelColor:(UIColor *)color forState:(VDFloatingTipState)floatingTipState
{
    id newColor = color;
    
    if(!newColor)
    {
        newColor = DEFAULT_TIP_TEXT_COLOR;
    }
    
    if(floatingTipState == VDFloatingTipStateAll)
    {
        for (int i = VDFloatingTipStateHide; i <= VDFloatingTipStateError; i++)
        {
            [self.floatingTipColors replaceObjectAtIndex:i withObject:newColor];
        }
    }
    else
    {
        [self.floatingTipColors replaceObjectAtIndex:floatingTipState withObject:newColor];
    }
}

- (BOOL)vd_isRegexMatched
{
    if (!self.vd_floatingTipRegex)
    {   // no need to check
        return YES;
    }
    
    return [self.text vd_isRegexMatched:self.vd_floatingTipRegex];
}

@end
