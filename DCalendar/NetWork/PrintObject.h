//
//  PrintObject.h
//  jsTest
//
//  Created by MgenLiu on 13-9-15.
//  Copyright (c) 2013年 MgenLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintObject : NSObject
//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;
+ (NSArray*)getObjectArr:(NSArray *)arr;

//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;

@end

@interface NSString (NSDictionary)
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithObject:(id) object;
@end