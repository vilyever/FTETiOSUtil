//
//  VDPickerBoardController.h
//  VDTextInPut
//
//  Created by FTET on 14/9/4.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDPickerBoardController : UIViewController

@property (nonatomic, retain) id delegate;

+ (instancetype)sharedInstance;

- (void)reload;
- (void)selectItemIndex:(NSInteger)index;

@end
