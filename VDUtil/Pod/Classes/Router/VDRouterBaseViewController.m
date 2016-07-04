//
//  VDRouterBaseViewController.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDRouterBaseViewController.h"

#import <VDKit/VDKit.h>


@interface VDRouterBaseViewController ()

@end


@implementation VDRouterBaseViewController

#pragma Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma Initial

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
- (instancetype)initWithRouterParams:(id)params {
    self = [self initWithNibName:[self.class vd_className] bundle:nil];
    if (!self) {
        self = [self init];
    }
    self.routerParams = params;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    return self;
}


@end
