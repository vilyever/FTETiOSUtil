//
//  VDDateBoardController.h
//  VDTextInPut
//
//  Created by FTET on 14/9/3.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VDDateBoardDelegate <NSObject>

- (void)VDDateBoardDidChangedDate:(NSDate *)date;

@end

@interface VDDateBoardController : UIViewController

@property (nonatomic, retain) id<VDDateBoardDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)reset;
- (void)setDate:(NSDate *)date;

@end
