//
//  HRBaseModel.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/9/22.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

//model解析时，类的前缀，可以为空
#define classPrefix @"HR"

#import <objc/runtime.h>
#import "HRBaseModel.h"

@implementation HRBaseModel

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        for(NSString *key in [dictionary allKeys]){
            id obj = [dictionary objectForKey:key];
            if(!obj || [obj isKindOfClass:[NSNull class]]){
                NSLog(@"%@ is null",key);
            }
            if([obj isKindOfClass:[NSDictionary class]]){
                [self configDicValue:obj withKey:key];
            }else if([obj isKindOfClass:[NSArray class]]){
                [self configArrayValue:obj withKey:key];
            }else{
                objc_property_t property = class_getProperty([self class], key.UTF8String);
                const char * type = property_getName(property);
                NSString * typeString = [NSString stringWithUTF8String:type];
                NSArray * attributes = [typeString componentsSeparatedByString:@","];
                NSString * typeAttribute = [attributes objectAtIndex:0];
                NSString * propertyType = [typeAttribute substringFromIndex:1];
                const char * rawPropertyType = [propertyType UTF8String];
                
                //根据声明的属性类型处理，一切以声明的类型为准进行转model
                //如果是数字型的
                if (strcmp(rawPropertyType, @encode(float)) == 0){
                    //it's a float
                    if([obj isKindOfClass:[NSNumber class]]){
                        [self setValue:obj forKeyPath:key];
                    }else if([obj isKindOfClass:[NSString class]]){
                        [self setValue:@([obj intValue]) forKey:key];
                    }else{
                        NSLog(@"type error ");
                    }
                }else if(strcmp(rawPropertyType, @encode(int)) == 0){
                    if([obj isKindOfClass:[NSNumber class]]){
                        [self setValue:obj forKeyPath:key];
                    }else if([obj isKindOfClass:[NSString class]]){
                        [self setValue:@([obj floatValue]) forKey:key];
                    }else{
                        NSLog(@"type error ");
                    }
                }else if (strcmp(rawPropertyType, @encode(id)) == 0) {
                    //其它类型稍后处理
                    [self setValue:[NSString stringWithFormat:@"%d",[obj intValue]] forKey:key];
                } else {
                    // String型
                    if([obj isKindOfClass:[NSNumber class]]){
                        [self setValue:[NSString stringWithFormat:@"%d",[obj intValue]] forKeyPath:key];
                    }else if([obj isKindOfClass:[NSString class]]){
                        [self setValue:obj forKey:key];
                    }else{
                        NSLog(@"type error ");
                    }
                }
            }
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        
        [aCoder encodeObject:[self valueForKeyPath:key] forKey:key];
    }
    
    free(ivars);
}

//解析数据对象型属性
-(void)configDicValue:(id)obj withKey:(NSString *)key{
    Class clazz = NSClassFromString([NSString stringWithFormat:@"%@%@",classPrefix,key.capitalizedString]);
    if(clazz){
        id myObj = [[clazz alloc] initWithDictionary:obj];
        [self setValue:myObj forKeyPath:key];
    }else{
        NSLog(@"%@ undeclare",key);
    }
}

//解析数组类型
-(void)configArrayValue:(id)obj withKey:(NSString *)key{
    Class clazz = NSClassFromString([NSString stringWithFormat:@"%@%@",classPrefix,key.capitalizedString]);
    if(!clazz){
        NSLog(@"%@ undeclare",key);
    }else{
        NSMutableArray *arrayObj = [NSMutableArray new];
        for(NSDictionary *dic in obj){
            id item = [[clazz alloc] initWithDictionary:dic];
            [arrayObj addObject:item];
        }
        [self setValue:arrayObj forKeyPath:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"key:%@ not exist",key);
}

@end
