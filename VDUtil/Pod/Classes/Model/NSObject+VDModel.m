//
//  NSObject+VDModel.m
//  VDModel
//
//  Created by FTET on 15/4/2.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "NSObject+VDModel.h"

#import <objc/runtime.h>

#import <VDKit/VDKit.h>

#import "NSObject+VDAspects.h"



@implementation NSObject (VDModel)

#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors


#pragma Methods
#pragma Private Class Method
+ (void)vd_insertJsonValue:(NSDictionary *)jsonDictionary jsonKey:(NSString *)jsonKey model:(id)model property:(VDProperty *)property {
    
    if (![jsonDictionary objectForKey:jsonKey]) {
        return;
    }
    
    if (property.isPrimitive)
    {
        [model setValue:[jsonDictionary objectForKey:jsonKey] forKeyPath:property.name];
    }
    else if (property.type == [NSString class])
    {
        [model setValue:[jsonDictionary objectForKey:jsonKey] forKeyPath:property.name];
    }
    else if (property.type == [NSNumber class])
    {
        [model setValue:[jsonDictionary objectForKey:jsonKey] forKeyPath:property.name];
    }
    else if (property.type == [NSDate class])
    {
        NSDateFormatter *jsonDateFormatter = nil;
        NSObject<VDModelProtocol> *protocolModel = (NSObject<VDModelProtocol> *)model;
        // use custom jsonDateFormatter if the model class conforms, or else use default
        if ([[protocolModel class] respondsToSelector:@selector(jsonDateFormatterForVDModel)])
        {
            jsonDateFormatter = [ [protocolModel class] jsonDateFormatterForVDModel];
        }
        else
        {
            jsonDateFormatter = [ [NSDateFormatter alloc] init];
            [jsonDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *destDate= [jsonDateFormatter dateFromString:[jsonDictionary objectForKey:jsonKey]];
        [model setValue:destDate forKeyPath:property.name];
    }
    else if (property.type == [NSArray class]
             || property.type == [NSMutableArray class])
    {
        for (NSString *protocolName in property.protocols)
        {
            Class protocolClass = NSClassFromString(protocolName);
            if (protocolClass)
            {
                NSArray *array = [protocolClass vd_arrayWithDictionaries:[jsonDictionary objectForKey:jsonKey]];
                
                if (property.type == [NSArray class])
                {
                    [model setValue:array forKey:property.name];
                }
                else if (property.type == [NSMutableArray class])
                {
                    [model setValue:[NSMutableArray arrayWithArray:array] forKey:property.name];
                }
                break;
            }
        }
    }
    else if ([property.type conformsToProtocol:@protocol(VDModelProtocol)])
    {
        [model setValue:[property.type vd_modelWithDictionary:[jsonDictionary objectForKey:jsonKey]] forKey:property.name];
    }
    
}

+ (id)vd_getValueFromModel:(id)model property:(VDProperty *)property {
    if (property.isPrimitive)
    {
        return [model valueForKey:property.name];
    }
    else if (property.type == [NSString class])
    {
        return [model valueForKey:property.name];
    }
    else if (property.type == [NSNumber class])
    {
        return [model valueForKey:property.name];
    }
    else if (property.type == [NSDate class])
    {
        NSDateFormatter *jsonDateFormatter = nil;
        NSObject<VDModelProtocol> *protocolModel = (NSObject<VDModelProtocol> *)model;
        // use custom jsonDateFormatter if the model class conforms, or else use default
        if ([[protocolModel class] respondsToSelector:@selector(jsonDateFormatterForVDModel)])
        {
            jsonDateFormatter = [ [protocolModel class] jsonDateFormatterForVDModel];
        }
        else
        {
            jsonDateFormatter = [ [NSDateFormatter alloc] init];
            [jsonDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *date = [model valueForKey:property.name];
        return [jsonDateFormatter stringFromDate:date];
    }
    else if (property.type == [NSArray class]
             || property.type == [NSMutableArray class])
    {
        return [model valueForKey:property.name];
    }
    else if ([property.type conformsToProtocol:@protocol(VDModelProtocol)])
    {
        return [model valueForKey:property.name];
    }
    
    return nil;
}

#pragma Private Instance Method
- (instancetype)initForVDModel
{
    self = [self init];
    NSAssert([self conformsToProtocol:@protocol(VDModelProtocol)], @"Object init for VDModel must conforms VDModelProtocol");
    
    VDWeakifySelf;
    [self vdaspect_hookSelector:@selector(description) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        VDStrongifySelf;
        void *originalValue;
        NSInvocation *invocation = [info originalInvocation];
        [invocation invoke];
        [invocation getReturnValue:&originalValue];
        NSString *originalDescription = (__bridge NSString *)originalValue;
        
        NSMutableString *description = [NSMutableString stringWithFormat:@"\n< %@ > \n", originalDescription];
        
        Class ancestorClass = [self class];
        while ([[ancestorClass superclass] conformsToProtocol:@protocol(VDModelProtocol)])
        {
            ancestorClass = [ancestorClass superclass];
        }
        
        NSArray *properties = [[self class] vd_propertiesTraceToAncestorClass:ancestorClass];
        
        NSDictionary *jsonKeyDictionary = nil;
        NSObject<VDModelProtocol> *protocolSelf = (NSObject<VDModelProtocol> *)self;
        if ([[protocolSelf class] respondsToSelector:@selector(jsonKeyDictionaryForVDModel)])
        {
            jsonKeyDictionary = [ [protocolSelf class] jsonKeyDictionaryForVDModel];
        }
        
        for (VDProperty *property in properties)
        {
            if (![property.protocols containsObject:@protocol(VDModelIgnore)])
            {
                id value = [self.class vd_getValueFromModel:self property:property];
                if (!value) {
                    continue;
                }
                
                NSString *appendString = @"";
                for (NSString *propertyName in jsonKeyDictionary.allKeys)
                {
                    if ([propertyName isEqualToString:property.name])
                    {
                        appendString = VDStringFormat(@" (%@) ", [jsonKeyDictionary objectForKey:propertyName]);
                        break;
                    }
                }
                
                [description appendFormat:@"[%@%@] : %@ \n", property.name, appendString, value];
            }
        }
        
        [description appendFormat:@"</%@>", [self class]];
        
        [invocation setReturnValue:&description];
    } error:nil];
    
    return self;
}

#pragma Public Class Method
+ (instancetype)vd_modelWithJSONString:(NSString *)jsonString error:(NSError *__autoreleasing *)error
{
    return [self vd_modelWithJSONString:jsonString usingEncoding:NSUTF8StringEncoding error:error];
}

+ (instancetype)vd_modelWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)encoding error:(NSError *__autoreleasing *)error
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                                               options:kNilOptions
                                                                 error:error];
    return [self vd_modelWithDictionary:dictionary];
}

+ (instancetype)vd_modelWithDictionary:(NSDictionary *)dictionary
{
    id model = [[self alloc] initForVDModel];
    
    NSDictionary *jsonKeyDictionary = nil;
    
    // check if model conforms VDModelProtocol
    NSObject<VDModelProtocol> *protocolModel = (NSObject<VDModelProtocol> *)model;
    if ([[protocolModel class] respondsToSelector:@selector(jsonKeyDictionaryForVDModel)])
    {
        jsonKeyDictionary = [ [protocolModel class] jsonKeyDictionaryForVDModel];
    }
    
    // get the most super class that conforms VDModelProtocol
    Class ancestorClass = [self class];
    while ([[ancestorClass superclass] conformsToProtocol:@protocol(VDModelProtocol)])
    {
        ancestorClass = [ancestorClass superclass];
    }
    
    // get properties that the model class have (include super class)
    NSArray *properties = [self vd_propertiesTraceToAncestorClass:ancestorClass];
    
    for (VDProperty *property in properties) {
        if ([jsonKeyDictionary objectForKey:property.name]) {
            [self vd_insertJsonValue:dictionary jsonKey:[jsonKeyDictionary objectForKey:property.name] model:model property:property];
        } else {
            [self vd_insertJsonValue:dictionary jsonKey:property.name model:model property:property];
        }
    }
    
    return model;
}

+ (NSArray *)vd_arrayWithJSONString:(NSString *)jsonString error:(NSError *__autoreleasing *)error
{
    return [self vd_arrayWithJSONString:jsonString usingEncoding:NSUTF8StringEncoding error:error];
}

+ (NSArray *)vd_arrayWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)encoding error:(NSError *__autoreleasing *)error
{
    NSArray *dictionaries = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                                               options:kNilOptions
                                                                 error:error];
    return [self vd_arrayWithDictionaries:dictionaries];
}

+ (NSArray *)vd_arrayWithDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dic in dictionaries)
    {
        [array addObject:[self vd_modelWithDictionary:dic]];
    }
    
    return [NSArray arrayWithArray:array];
}

+ (NSMutableDictionary *)vd_jsonKeyDictionary
{
    NSMutableDictionary *jsonKeyDictionary = nil;
    
    if ([[self superclass] conformsToProtocol:@protocol(VDModelProtocol)])
    {
        Class<VDModelProtocol> superClass = [self superclass];
        if ([[self superclass] respondsToSelector:@selector(jsonKeyDictionaryForVDModel)])
        {
            jsonKeyDictionary = [NSMutableDictionary dictionaryWithDictionary:[superClass jsonKeyDictionaryForVDModel]];
        }
    }
    
    if (!jsonKeyDictionary)
    {
        jsonKeyDictionary = [NSMutableDictionary new];
    }
    
    return jsonKeyDictionary;
}

#pragma Public Instance Method
- (NSDictionary *)vd_toJsonDictionary {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary new];
    
    Class ancestorClass = [self class];
    while ([[ancestorClass superclass] conformsToProtocol:@protocol(VDModelProtocol)])
    {
        ancestorClass = [ancestorClass superclass];
    }
    
    NSArray *properties = [[self class] vd_propertiesTraceToAncestorClass:ancestorClass];
    
    NSDictionary *jsonKeyDictionary = nil;
    NSObject<VDModelProtocol> *protocolSelf = (NSObject<VDModelProtocol> *)self;
    if ([[protocolSelf class] respondsToSelector:@selector(jsonKeyDictionaryForVDModel)])
    {
        jsonKeyDictionary = [ [protocolSelf class] jsonKeyDictionaryForVDModel];
    }
    
    for (VDProperty *property in properties)
    {
        if (![property.protocols containsObject:@protocol(VDModelIgnore)])
        {
            for (NSString *propertyName in jsonKeyDictionary.allKeys)
            {
                if ([propertyName isEqualToString:property.name])
                {
                    id value;
                    if ([property.type conformsToProtocol:@protocol(VDModelProtocol)])
                    {
                        value = [[self valueForKey:property.name] vd_toJsonDictionary];
                    }
                    else if (property.type == [NSArray class]
                             || property.type == [NSMutableArray class])
                    {
                        BOOL isContainModel = NO;
                        for (NSString *protocolName in property.protocols) {
                            Class protocolClass = NSClassFromString(protocolName);
                            if (protocolClass && [protocolClass conformsToProtocol:@protocol(VDModelProtocol)]) {
                                isContainModel = YES;
                                break;
                            }
                        }
                        
                        if (isContainModel) {
                            NSMutableArray *values = [NSMutableArray new];
                            NSArray *models = [self valueForKey:property.name];
                            for (id model in models) {
                                [values addObject:[model vd_toJsonDictionary]];
                            }
                            value = values;
                        } else {
                            value = [[self class] vd_getValueFromModel:self property:property];
                        }
                    }
                    else
                    {
                        value = [[self class] vd_getValueFromModel:self property:property];
                    }
                    
                    if (!value) {
                        value = @"";
                    }
                    [jsonDictionary setObject:value forKey:[jsonKeyDictionary objectForKey:propertyName]];
                    break;
                }
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:jsonDictionary];
}

- (NSString *)vd_toJsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self vd_toJsonDictionary] options:0 error:&error];
    
    if (!jsonData) {
        return @"{}";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
