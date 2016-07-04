//
//  VDModelImageFile.h
//  VDModel
//
//  Created by FTET on 15/4/3.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDModelFile.h"


@class VDModelImageFile;


@protocol VDModelImageFile
@end


@interface VDModelImageFile : VDModelFile

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method

@end
