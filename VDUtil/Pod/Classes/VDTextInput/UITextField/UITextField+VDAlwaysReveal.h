//
//  UITextField+VDAlwaysReveal.h
//  VDTextInPut
//
//  Created by FTET on 14/12/17.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (VDAlwaysReveal)

/**
 *  decide is auto relocate view to avoid cover by keyboard
 *  there is a problem that put this view into navigation controller, while push then back, relocate will be messing up.
 *  TODO. while controller will push, send a notification named VD_TEXTFIELD_WILL_PUSHED_IN_CONTROLLER or call +(void)endAllVDTextFieldEditing to tell this view to end editing to avoid relocate fail.
 */
@property (nonatomic, weak) UIView *vd_alwaysRevealPanView;
@property (nonatomic, assign) CGFloat vd_alwaysRevealPanOffset;

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method

@end
