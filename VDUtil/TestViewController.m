//
//  TestViewController.m
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "TestViewController.h"

//#import <VDUtil/VDUtil.h>

#import "VDUtil.h"

#import "TestRouter.h"


@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end


@implementation TestViewController

#pragma Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
//    self.view.frame = self.view.superview.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    
//    if ([self.view.superview.class.className isEqualToString:@"UITransitionView"])
//    {
//        NSLog(@"UITransitionView");
//        self.view.frame = self.view.superview.bounds;
//    }
    
    self.testLabel.text = [TestRouter titleFromParams:self.routerParams];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    NSLog(@"initial");
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
//    self.view.userInteractionEnabled = YES;
//    [self.view vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
////        [self dismissViewControllerAnimated:YES completion:NULL];
//        VDLog(@"nav %@", self.navigationController);
//        [self.navigationController popViewControllerAnimated:YES];
//    } ];
    
//    [self.view vdaspect_hookSelector:@selector(didMoveToSuperview) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
//        
//        
//        VDLog(@"arguments %@", [info arguments]);
//            UIView *superView = self.view.superview;
//            if ([superView.class.className isEqualToString:@"UITransitionView"])
//            {
//                self.view.translatesAutoresizingMaskIntoConstraints = NO;
//                
//                NSMutableArray *array = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[vdsubview]-0-|" options:0 metrics:nil views:@{@"vdsubview" : self.view} ] ];
//                [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[vdsubview]-0-|" options:0 metrics:nil views:@{@"vdsubview" : self.view} ] ];
//                
//                NSArray *constraints = [NSArray arrayWithArray:array];
//                
//                [superView addConstraints:constraints];
//            }
//    } error:NULL];
}


#pragma IBActions


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors
- (void)setTestTitle:(NSString *)testTitle
{
//    NSLog(@"setTestTitle");

//    VDAccessorWaitForViewLoaded(testTitle, testTitle);
//    VDAccessorForbidEqual(_testTitle, testTitle);

//    if ([_testTitle isEqualToString:testTitle])
//    {
//        return;
//    }
    
    _testTitle = testTitle;
    
    self.testLabel.text = _testTitle;
    [self show];
    
//    [self.delegate ttttttest];
    
//    NSLog(@"ctp %@", VDBoolToString( [self.delegate conformsToProtocol:@protocol(TestViewControllerDelegate) ] ) );
}


#pragma Delegates


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (void)show
{
//    NSLog(@"title %@, label %@, labeltext %@", self.testTitle, self.testLabel, self.testLabel.text);
}


@end
