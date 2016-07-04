//
//  CheckViewController.m
//  VDUtil
//
//  Created by FTET on 15/3/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "CheckViewController.h"

//#import <VDUtil/VDUtil.h>

#import "NSObject+VDDelayOperation.h"


@interface CheckViewController ()

@end


@implementation CheckViewController

#pragma Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    NSLog(@"dealloc");
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
    [self vd_delaySelector:@selector(test) delay:5 onMain:YES identifier:@"none"];
    [self vd_delaySelector:@selector(test) delay:6 onMain:YES identifier:@"none"];
    [self vd_delayBlock:^{
        NSLog(@"block");
    } delay:8 onMain:YES identifier:@"check"];
    [self vd_delayBlock:^{
        NSLog(@"block2222");
    } delay:8 onMain:YES identifier:@"check"];
}


#pragma IBActions


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors
- (void)setDelegate:(id<CheckViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setDatasource:(id<CheckViewControllerDatasource>)datasource
{
//    VDAccessorWaitForViewLoaded(datasource, datasource);
//    VDAccessorForbidEqual(_datasource, datasource);
    
    _datasource = datasource;
    
//    [self reloadData];
}


#pragma Delegates


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
//- (void)reloadData
//{
//
//}

- (void)test
{
    NSLog(@"test");
}


@end
