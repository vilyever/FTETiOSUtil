//
//  VDKeyboardInputAccessoryViewController.m
//  VDTextInPut
//
//  Created by FTET on 14/9/3.
//  Copyright (c) 2014年 Vilyever. All rights reserved.
//

#import "VDKeyboardInputAccessoryViewController.h"

#import <VDKit/VDKit.h>

#import "NSObject+VDReactiveCocoa.h"


@interface VDKeyboardInputAccessoryViewController ()

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIBarButtonItem *prevBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *nextBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *clearBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;

@property (nonatomic, strong) NSMutableArray *inputViews;

@property (nonatomic, strong) id prevInputView;
@property (nonatomic, strong) id nextInputView;

@end

@implementation VDKeyboardInputAccessoryViewController

+ (instancetype)sharedInstance
{
    static VDKeyboardInputAccessoryViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [ [VDKeyboardInputAccessoryViewController alloc] init];
    } );
    
    return _sharedInstance;
}

+ (UIToolbar *)inputAccessoryToolBar
{
    return [VDKeyboardInputAccessoryViewController sharedInstance].toolBar;
}

+ (UIImage *)generateBarButtonItemBackgroundImageWithColor:(UIColor *)color withImageSize:(CGSize)size withCornerRadius:(float)cornerRadius
{
    float offset = 3.0f;
    CGRect rect = CGRectMake(0.0f, offset, size.width, size.height - offset);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius) ];
    
    [path closePath];
    [path fill];
    
    UIImage *image = nil;
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.inputViews = [ [NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma setter & getter
- (UIToolbar *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [ [UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, VDWindow.bounds.size.width, 44.0f) ];
        [_toolBar setBarStyle:UIBarStyleBlack];
        
        self.prevBarButtonItem = [ [UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevButtonDidTap:) ];
        
        self.nextBarButtonItem = [ [UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonDidTap:) ];
        
        UIBarButtonItem *spaceItem = [ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        self.clearBarButtonItem = [ [UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonDidTap:) ];

        self.doneBarButtonItem = [ [UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonDidTap:) ];
        
        NSArray *buttons = [NSArray arrayWithObjects:self.prevBarButtonItem, self.nextBarButtonItem, spaceItem, self.clearBarButtonItem, self.doneBarButtonItem, nil];
        [_toolBar setItems:buttons];
    }
    
    return _toolBar;
}

- (void)setCurrentInputView:(id)currentInputView
{
    _currentInputView = currentInputView;
    
    if ( [currentInputView respondsToSelector:@selector(becomeFirstResponder) ] )
    {
        [currentInputView becomeFirstResponder];
    }
    
    self.prevInputView = nil;
    self.nextInputView = nil;
    
    if (self.inputViews.count <= 1)
    {
        [self.prevBarButtonItem setEnabled:NO];
        [self.nextBarButtonItem setEnabled:NO];
        self.prevInputView = nil;
        self.nextInputView = nil;
    }
    else
    {
        [self.prevBarButtonItem setEnabled:(self.inputViews[0] != currentInputView) ];
        [self.nextBarButtonItem setEnabled:(self.inputViews[self.inputViews.count - 1] != currentInputView) ];
        
        for (int i = 0; i < self.inputViews.count; i++)
        {
            id inputView = self.inputViews[i];
            if (inputView == currentInputView)
            {
                if (i > 0)
                {
                    self.prevInputView = self.inputViews[i - 1];
                }
                
                if (i < self.inputViews.count - 1)
                {
                    self.nextInputView = self.inputViews[i + 1];
                }
            }
        }
    }
}

#pragma UI
- (void)clearButtonDidTap:(id)sender {
    if ( [self.currentInputView respondsToSelector:@selector(setText:) ] )
    {
        [self.currentInputView setText:@""];
    }
}

- (void)doneButtonDidTap:(id)sender {
    if ( [self.currentInputView respondsToSelector:@selector(resignFirstResponder) ] )
    {
        [self.currentInputView resignFirstResponder];
    }
}

- (void)nextButtonDidTap:(id)sender {
    if ( [self.currentInputView respondsToSelector:@selector(becomeFirstResponder) ] )
    {
        [self.nextInputView becomeFirstResponder];
    }
}

- (void)prevButtonDidTap:(id)sender {
    if ( [self.currentInputView respondsToSelector:@selector(becomeFirstResponder) ] )
    {
        [self.prevInputView becomeFirstResponder];
    }
}

#pragma private
- (void)hookInputView:(id)inputView
{
    if ( [inputView respondsToSelector:@selector(setInputAccessoryView:) ] )
    {
        [inputView setInputAccessoryView:[self toolBar] ];
    }
    
    NSString *tag = [NSString stringWithFormat:@"VDKIA-%@", inputView];
    
    VDWeakifySelf;
    [VDRACNotification(UITextFieldTextDidBeginEditingNotification, inputView, tag) subscribeNextForNotification:^(NSNotification *notification) {
        VDStrongifySelf;
        self.currentInputView = notification.object;
    } ];
    
//    [VDNotification(inputView, UITextFieldTextDidBeginEditingNotification, inputView) nextActionWithTag:tag action:^(NSNotification *notification) {
//        self.currentInputView = notification.object;
//    } ];
}

#pragma public
- (void)addInputView:(id)inputView
{
    [self hookInputView:inputView];
    [self.inputViews addObject:inputView];
}

- (void)addInputView:(id)inputView atIndex:(NSUInteger)index
{
    [self hookInputView:inputView];
    [self.inputViews insertObject:inputView atIndex:index];
}

- (void)clear
{
    self.currentInputView = nil;
    [self.inputViews removeAllObjects];
}

- (void)resignCurrentInputView
{
    if ( [self.currentInputView respondsToSelector:@selector(resignFirstResponder) ] )
    {
        [self.currentInputView resignFirstResponder];
    }
}

@end
