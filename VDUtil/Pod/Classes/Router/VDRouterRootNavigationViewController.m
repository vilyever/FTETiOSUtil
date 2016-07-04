//
//  VDRouterRootNavigationViewController.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDRouterRootNavigationViewController.h"

//#import <VDUtil/VDUtil.h>


@interface VDRouterRootNavigationViewController ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end


@implementation VDRouterRootNavigationViewController

#pragma Overrides
- (instancetype)init {
    self = [super initWithRootViewController:[UIViewController new]];
    self.rootViewController = self.viewControllers[0];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initial];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.rootViewController) {
        [super pushViewController:viewController animated:NO];
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];
        [controllers removeObject:self.rootViewController];
        self.viewControllers = controllers;
        self.rootViewController = nil;
    } else {
        [super pushViewController:viewController animated:animated];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma Initial
- (void)initial
{
    
}


#pragma IBActions


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Delegates


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method


@end
