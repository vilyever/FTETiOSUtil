//
//  VDNoticeMsgViewController.h
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VDNoticeMsgViewController;


@protocol VDNoticeMsgViewControllerDelegate <NSObject>

@required

@optional

@end


@protocol VDNoticeMsgViewControllerDatasource <NSObject>

@required

@optional

@end


@interface VDNoticeMsgViewController : UIViewController

@property (nonatomic, weak) id<VDNoticeMsgViewControllerDelegate> delegate;
@property (nonatomic, weak) id<VDNoticeMsgViewControllerDatasource> datasource;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isHiding;

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
//- (void)reloadData;

@end
