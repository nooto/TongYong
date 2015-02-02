//
// Created by moon on 8/28/13.
// Copyright (c) 2013 lijun. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDate (DateFormat)

-(NSString *)formatDate;

/**
* @interval 距离1970年的秒数
*/
//昨天，今天，
//+(NSString *)formatDateWithInterval:(NSTimeInterval)  interval;
+(NSString *)formatDateWithNSString:(NSString *)str;

//年月日
+(NSString *)stringDateWithInterval:(NSTimeInterval)interval;

//月日 时分
+(NSString *)stringDateWithInterval2:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval3:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval4:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval5:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval6:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval7:(NSTimeInterval)interval;
+(NSString *)stringDateWithInterval8:(NSTimeInterval)interval;
+ (NSDate *)dataFromString:(NSString *)string;

+(NSInteger)dayTimeDistance:(NSTimeInterval)interval;

@end