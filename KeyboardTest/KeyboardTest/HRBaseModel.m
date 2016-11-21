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
                if(!property){
                    //propertyNotExist
                    [self setValue:obj forKeyPath:key];
                }else{
                    NSString* propertyTypeName=  [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"type name %@",propertyTypeName);
                    
                    //根据声明的属性类型处理，一切以声明的类型为准进行转model
                    if ([propertyTypeName hasPrefix:@"Tf"] || [propertyTypeName hasPrefix:@"Td"]){
                        //it's a float,double,CGFloat
                        if([obj isKindOfClass:[NSNumber class]]){
                            [self setValue:obj forKeyPath:key];
                        }else if([obj isKindOfClass:[NSString class]]){
                            [self setValue:@([obj doubleValue]) forKey:key];
                        }else{
                            NSLog(@"type error ");
                        }
                    }else if([propertyTypeName hasPrefix:@"Ti"]){
                        //it is int
                        if([obj isKindOfClass:[NSNumber class]]){
                            [self setValue:obj forKeyPath:key];
                        }else if([obj isKindOfClass:[NSString class]]){
                            [self setValue:@([obj intValue]) forKey:key];
                        }else{
                            NSLog(@"type error ");
                        }
                    }else if([propertyTypeName hasPrefix:@"Tq"]){
                        //long, long long, NSIntger
                        if([obj isKindOfClass:[NSNumber class]]){
                            [self setValue:obj forKeyPath:key];
                        }else if([obj isKindOfClass:[NSString class]]){
                            [self setValue:@([obj longLongValue]) forKey:key];
                        }else{
                            NSLog(@"type error ");
                        }
                    }else if ([propertyTypeName hasPrefix:@"T@"]) {
                        //it is string
                        if([obj isKindOfClass:[NSNumber class]]){
                            [self setValue:[NSString stringWithFormat:@"%d",[obj intValue]] forKeyPath:key];
                        }else if([obj isKindOfClass:[NSString class]]){
                            [self setValue:obj forKey:key];
                        }else{
                            NSLog(@"type error ");
                        }
                    } else {
                        //other types, may never run here as json can only be string dic and array
                        [self setValue:[NSString stringWithFormat:@"%d",[obj intValue]] forKey:key];
                    }
                }
            }
        }
    }
    return self;
}

-(NSString *)jsonString{
    return [self DataTOjsonString:[self getModelDictionary]];
}

-(NSDictionary *)getModelDictionary{
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        
        id object  = [self valueForKeyPath:key];
        if([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSDictionary class]]){
            [dic setValue:object forKey:key];
        }else if([object isKindOfClass:[NSArray class]]){
            for(id subObj in object){
                NSDictionary *jsonDic = [self getJsonDicWithObject:subObj withName:key];
                [dic setValue:jsonDic forKey:key];
            }
        }else if([object isKindOfClass:[HRBaseModel class]]){
            //自定义model对象型,需要继承baseModel的类
            NSDictionary *jsonDic = [self getJsonDicWithObject:object withName:key];
            [dic setValue:jsonDic forKey:key];
        }else{
            NSLog(@"%@ %@",NSStringFromClass([object class]),object);
        }
    }
    
    free(properties);
    
    return dic;
}

-(NSDictionary *)getJsonDicWithObject:(id)object withName:(NSString *)name{
    NSMutableDictionary *retDic = @{}.mutableCopy;
    NSDictionary *subDic = [(HRBaseModel *)object getModelDictionary];
    [retDic setValue:subDic forKey:name];
    
    return retDic;
}


-(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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

/**
 *  @author Henry
 *
 *  通过节点取到相应的类名，比如字典是modelName，解析后会取到MZModelName，加上项目前缀和首字母大写
 *
 *  @param nodeName 字典中的节点名
 *
 *  @return 取到相应的类名字
 */
-(NSString *)getClassNameWithNodeName:(NSString *)nodeName{
    NSString *firstChar = [[nodeName substringToIndex:1] uppercaseString];
    NSString *replaceString = [nodeName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstChar];
    return [NSString stringWithFormat:@"%@%@",classPrefix,replaceString];
}

//解析数据对象型属性
-(void)configDicValue:(id)obj withKey:(NSString *)key{
    Class clazz = NSClassFromString([self getClassNameWithNodeName:key]);
    if(clazz){
        id myObj = [[clazz alloc] initWithDictionary:obj];
        [self setValue:myObj forKeyPath:key];
    }else{
        NSLog(@"%@ undeclare",key);
    }
}

//解析数组类型
-(void)configArrayValue:(id)obj withKey:(NSString *)key{
    Class clazz = NSClassFromString([self getClassNameWithNodeName:key]);
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
