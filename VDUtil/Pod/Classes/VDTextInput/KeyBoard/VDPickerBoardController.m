//
//  VDPickerBoardController.m
//  VDTextInPut
//
//  Created by FTET on 14/9/4.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "VDPickerBoardController.h"

#import <VDKit/VDKit.h>


@interface VDPickerBoardController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation VDPickerBoardController

+ (instancetype)sharedInstance
{
    static VDPickerBoardController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [VDPickerBoardController vd_controllerFromNib];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma setter & getter
- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.pickerView.dataSource = delegate;
    self.pickerView.delegate = delegate;
}

#pragma main
- (void)reload
{
    [self.pickerView reloadAllComponents];
}

- (void)selectItemIndex:(NSInteger)index
{
    [self.pickerView selectRow:index inComponent:0 animated:YES];
}

@end
