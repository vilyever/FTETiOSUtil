//
//  VDLoadingHudViewController.h
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VDLoadingHudViewController;


@protocol VDLoadingHudViewControllerDelegate <NSObject>

@required

@optional

@end


@protocol VDLoadingHudViewControllerDatasource <NSObject>

@required

@optional

@end


@interface VDLoadingHudViewController : UIViewController

@property (nonatomic, weak) id<VDLoadingHudViewControllerDelegate> delegate;
@property (nonatomic, weak) id<VDLoadingHudViewControllerDatasource> datasource;

@property (weak, nonatomic) IBOutlet UIView *hudView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
//- (void)reloadData;

@end
