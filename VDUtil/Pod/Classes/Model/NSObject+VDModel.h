//
//  NSObject+VDModel.h
//  VDModel
//
//  Created by FTET on 15/4/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol VDModelProtocol

@required
+ (NSDictionary *)jsonKeyDictionaryForVDModel;

@optional
+ (NSDateFormatter *)jsonDateFormatterForVDModel;

@end

@protocol VDModelIgnore
@end


@interface NSObject (VDModel)

#pragma Methods
#pragma Public Class Method
+ (instancetype)vd_modelWithJSONString:(NSString *)jsonString error:(NSError **)error;
+ (instancetype)vd_modelWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)encoding error:(NSError **)error;

+ (instancetype)vd_modelWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)vd_arrayWithJSONString:(NSString *)jsonString error:(NSError **)error;
+ (NSArray *)vd_arrayWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)encoding error:(NSError **)error;

+ (NSArray *)vd_arrayWithDictionaries:(NSArray *)dictionaries;

+ (NSMutableDictionary *)vd_jsonKeyDictionary;

#pragma Public Instance Method
- (NSDictionary *)vd_toJsonDictionary;
- (NSString *)vd_toJsonString;


@end
