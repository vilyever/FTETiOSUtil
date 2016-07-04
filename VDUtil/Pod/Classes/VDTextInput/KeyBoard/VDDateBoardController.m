//
//  VDDateBoardController.m
//  VDTextInPut
//
//  Created by FTET on 14/9/3.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "VDDateBoardController.h"

#import <VDKit/VDKit.h>


@interface VDDateBoardController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation VDDateBoardController

+ (instancetype)sharedInstance
{
    static VDDateBoardController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [VDDateBoardController vd_controllerFromNib];
    } );
    
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UI
- (IBAction)datePickerValueDidChange:(UIDatePicker *)sender {
    [self.delegate VDDateBoardDidChangedDate:sender.date];
}

#pragma main
- (void)reset
{
    [self.datePicker setDate:[NSDate date] animated:YES];
}

- (void)setDate:(NSDate *)date
{
    if (!date)
    {
        date = [NSDate date];
    }
    
    [self.datePicker setDate:date animated:YES];
}

@end
