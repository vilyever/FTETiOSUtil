//
//  UIView+VDLoadingHud.m
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "UIView+VDLoadingHud.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "VDLoadingHudViewController.h"


@implementation UIView (VDLoadingHud)

#pragma Accessors
#pragma Private Accessors
- (VDLoadingHudViewController *)vd_loadingHudController {
    VDLoadingHudViewController *loadingHudController = objc_getAssociatedObject(self, @selector(vd_loadingHudController));
    if (!loadingHudController) {
        loadingHudController = [VDLoadingHudViewController vd_controllerFromNib];
        objc_setAssociatedObject(self, @selector(vd_loadingHudController), loadingHudController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return loadingHudController;
}

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method

#pragma Public Instance Method
- (void)vd_showLoadingHud:(NSString *)title {
    [self vd_loadingHudController].title = title;
    [VDWindow vd_addSubview:[self vd_loadingHudController].view scaleToFill:YES];
}

- (void)vd_hideLoadingHud {
    [[self vd_loadingHudController].view removeFromSuperview];
}

@end
