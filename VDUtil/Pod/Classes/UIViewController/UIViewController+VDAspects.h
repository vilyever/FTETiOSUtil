//
//  UIViewController+VDAspects.h
//  VDUtil
//
//  Created by FTET on 15/1/30.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+VDAspects.h"


#ifndef VDAccessorWaitForViewLoaded
#define VDAccessorWaitForViewLoaded(Property, Value) if (!self.isViewLoaded)\
{\
__block __typeof(Value)vd_block_value = Value;\
VDWeakifySelf;\
[self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){\
VDStrongifySelf;\
self.Property = vd_block_value;\
} error:NULL];\
return;\
}
#endif


#ifndef VDSelectorWaitForViewLoaded
#define VDSelectorWaitForViewLoaded(Selector) if (!self.isViewLoaded)\
{\
VDWeakifySelf;\
[self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){\
VDStrongifySelf;\
[self performSelector:@selector(Selector) ];\
} error:NULL];\
return;\
}
#endif


@interface UIViewController (VDAspects)

@property (nonatomic, assign) BOOL vdViewFirstAppeared;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method

@end
