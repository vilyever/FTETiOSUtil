//
//  VDLoadingHudViewController.m
//  VDUtil
//
//  Created by FTET on 15/5/15.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDLoadingHudViewController.h"

//#import <VDUtil/VDUtil.h>


@interface VDLoadingHudViewController ()

@end


@implementation VDLoadingHudViewController

#pragma Overrides
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
    self.hudView.layer.cornerRadius = 8.0f;
    
    self.titleLabel.text = self.title;
}


#pragma IBActions


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors
- (void)setDelegate:(id<VDLoadingHudViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setDatasource:(id<VDLoadingHudViewControllerDatasource>)datasource
{
//    VDAccessorWaitForViewLoaded(datasource, datasource);
//    VDAccessorForbidEqual(_datasource, datasource);
    
    _datasource = datasource;
    
//    [self reloadData];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLabel.text = title;
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


@end
