//
//  VDModelFile.h
//  VDModel
//
//  Created by FTET on 15/4/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDModelObject.h"


@class VDModelFile;


@protocol VDModelFile
@end


@interface VDModelFile : VDModelObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSNumber *size;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSDate *createDate;


#pragma Methods
#pragma Public Class Method

#pragma Public Instance Method

@end
