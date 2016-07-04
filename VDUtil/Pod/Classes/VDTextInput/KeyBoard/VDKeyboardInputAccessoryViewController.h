//
//  VDKeyboardInputAccessoryViewController.h
//  VDTextInPut
//
//  Created by FTET on 14/9/3.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VDDateBoardController.h"
#import "VDPickerBoardController.h"


@interface VDKeyboardInputAccessoryViewController : NSObject

@property (nonatomic, strong) id currentInputView;

+ (instancetype)sharedInstance;

+ (UIToolbar *)inputAccessoryToolBar;

- (void)addInputView:(id)inputView;
- (void)addInputView:(id)inputView atIndex:(NSUInteger)index;

- (void)clear;

- (void)resignCurrentInputView;

@end
