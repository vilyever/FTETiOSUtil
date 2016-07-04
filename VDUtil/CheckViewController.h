//
//  CheckViewController.h
//  VDUtil
//
//  Created by FTET on 15/3/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CheckViewController;


@protocol CheckViewControllerDelegate <NSObject>

@required

@optional

@end


@protocol CheckViewControllerDatasource <NSObject>

@required

@optional

@end


@interface CheckViewController : UIViewController

@property (nonatomic, weak) id<CheckViewControllerDelegate> delegate;
@property (nonatomic, weak) id<CheckViewControllerDatasource> datasource;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method
//- (void)reloadData;

@end
