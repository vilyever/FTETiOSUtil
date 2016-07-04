//
//  ViewController.m
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "ViewController.h"

#import "VDUtil.h"

#import "TestViewController.h"

#import "UIImageView+VDFullScreen.h"

#import <POP+MCAnimate/POP+MCAnimate.h>

//#import <POPCGUtils.h>

#import "UIView+VDFullScreen.h"

#import "UIView+VDNoticeMsg.h"


@interface ViewController () <UIScrollViewDelegate, TestViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) TestViewController *testController;
@property (weak, nonatomic) IBOutlet UIView *cyanView;
@property (weak, nonatomic) IBOutlet UIView *greenSubView;
@property (weak, nonatomic) IBOutlet UIView *orangeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *scrollLabel;


@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, assign) int xxx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    VDProperty *property = [self.class vd_propertyWithName:VDKeyPath(self, scrollView)];
    VDLog(@"%@", property);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.testController = [TestViewController vd_controllerFromNib];
    [self addChildViewController:self.testController];
    [self.testController.view setNeedsDisplay];
    self.testController.delegate = self;
    self.testController.testTitle = @"here come";

    
    [UIViewController vd_topViewControllerWithRootViewController:nil];
    
    self.testController.view.backgroundColor = [UIColor cyanColor];
    self.testController.view.frame = CGRectMake(234.0f, 385.0f, 239.0f, 293.0f);
    [self.greenSubView vd_addSubview:self.testController.view scaleToFill:YES];

    
    [VDRACObserve(self, xxx, @"aaa") subscribeNext:^(id x) {
        NSLog(@"xxx %@", x);
    } ];
    [VDRACObserve(self, xxx, @"aaa") subscribeNext:^(id x) {
        NSLog(@"yyy %@", x);
    } ];
    [VDRACObserve(self, xxx, @"aaa") subscribeNext:^(id x) {
        NSLog(@"zzz %@", x);
    } ];
    
    self.view.userInteractionEnabled = YES;
    [self.view vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {

//        [self.testLabel.pop_stop frame];
        [self.view vd_showWarningNotice:@"that's right"];
        
//        [self.testController removeFromParentViewController];
//        
//        [self presentViewController:self.testController animated:NO completion:^{
//            [self.testController.view.superview vd_addSubview:self.testController.view scaleToFill:YES];
//        }];
    } ];
    
    self.testController.view.userInteractionEnabled = YES;
    [self.testController.view vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
        [self.testController dismissViewControllerAnimated:NO completion:^{
            [self addChildViewController:self.testController];
            [self.greenSubView vd_addSubview:self.testController.view scaleToFill:YES];
        }];
        
    } ];
    
    self.label.clipsToBounds = YES;
    
    self.imageView.layer.cornerRadius = 30.0f;
    self.imageView.clipsToBounds = YES;
        
    self.label.userInteractionEnabled = YES;
    [self.label vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
        if (self.label.isHighlighted)
        {
            [self.label vd_enterFullscreenMode];
            [self.label setHighlighted:NO];
            
        }
        else
        {
            [self.label vd_exitFullscreenMode];
            [self.label setHighlighted:YES];
        }
        
    } ];

    
//    [[self.imageView vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
////        [self.imageView vd_enterFullScreenMode];
//        
//        
//
//        
//    }] requireGestureRecognizerToFail: [self.imageView vdrac_addDoubleTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
////        [self.imageView vd_exitFullScreenMode];
//    }] ];
    
    [self.imageView vd_activateTapToEnterImageViewFullscreenMode];
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 5.0f;
    self.scrollView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.testLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 80.0f, 80.0f) ];
    self.testLabel.backgroundColor = [UIColor redColor];
    self.testLabel.text = @"Z";
    
    [self.view addSubview:self.testLabel];
    
    self.testLabel.userInteractionEnabled = YES;
    [self.testLabel vdrac_addTapGestureRecognizerWithSubscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
//        if (self.testLabel.isHighlighted)
//        {
//            [self.testLabel vd_enterFullscreenMode];
//            [self.testLabel setHighlighted:NO];
//            
//        }
//        else
//        {
//            [self.testLabel vd_exitFullscreenMode];
//            [self.testLabel setHighlighted:YES];
//        }
        [NSObject pop_animate:^{
            self.testLabel.pop_duration = 10.0f;
            self.testLabel.pop_linear.frame = CGRectMake(200.0f, 200.0f, 100.0f, 100.0f);
        } completion:^(BOOL finished) {
            NSLog(@"finish %@", VDBoolToString(finished));
        } ];
        
    } ];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{

    return self.scrollLabel;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

- (void)ttttttest
{
    NSLog(@"jifjifjifjifjfi");
}

@end
