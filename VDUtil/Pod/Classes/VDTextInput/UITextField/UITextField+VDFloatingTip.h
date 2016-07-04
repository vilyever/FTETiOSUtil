//
//  UITextField+VDFloatingTip.h
//  VDTextInPut
//
//  Created by FTET on 14/12/16.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, VDFloatingTipState) {
    VDFloatingTipStateHide = 0,
    VDFloatingTipStateFocus,
    VDFloatingTipStateUnfocus,
    VDFloatingTipStateError,
    VDFloatingTipStateAll = 10
};

@interface UITextField (VDFloatingTip)

@property (nonatomic, assign, readonly) VDFloatingTipState vd_floatingTipState;
@property (nonatomic, copy) NSString *vd_floatingTip;

/**
 *  regex string for check
 */
@property (nonatomic, copy) NSString *vd_floatingTipRegex;

/**
 *  display this letter instead of floatingTip in tip label if mismatch regex
 */
@property (nonatomic, copy) NSString *vd_mismatchFloatingTipRegexLetter;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_setFloatingTipLabelColor:(UIColor *)color forState:(VDFloatingTipState)floatingTipState;

/**
 *  check input text is matched regex
 *
 *  @return is match
 */
- (BOOL)vd_isRegexMatched;

@end
