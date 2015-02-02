//
// Created by moon on 8/28/13.
// Copyright (c) 2013 lijun. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+DateFormat.h"
@implementation NSDate (DateFormat)

- (NSString *)formatDate {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
            NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ;

    // get current year month day
    NSDate * currentDate = [NSDate date];
    NSDateComponents * currentComponent =[calendar components:unitFlags fromDate:currentDate];
    NSInteger currentYear = currentComponent.year;
    NSInteger currentMonth = currentComponent.month;
    NSInteger currentDay = currentComponent.day;

    //get real year month day hour miniutes
    NSDateComponents * realComponent =[calendar components:unitFlags fromDate:self];
    NSInteger realYear = realComponent.year;
    NSInteger realMonth = realComponent.month;
    NSInteger realDay = realComponent.day;
//    NSInteger realHour = realComponent.hour;
//    NSInteger realMinute = realComponent.minute;

    NSString * resultFormat = nil;
    if(currentYear == realYear && currentMonth == realMonth  && currentDay == realDay) //今天
    {
        resultFormat = @"今天";//[NSString stringWithFormat:@"%02d:%02d",(int)realHour,(int)realMinute];
    } else if( currentYear == realYear && currentMonth == realMonth && currentDay == realDay +1 )
    {
        resultFormat = @"昨天";
    } else if(currentYear == realYear && currentMonth == realMonth && currentDay == realDay +2) {
        resultFormat = @"前天";
    } else{
        resultFormat =[NSString stringWithFormat:@"%d-%02d-%02d",(int)realYear,(int)realMonth,(int)realDay] ;
    }

    return resultFormat;
}

- (NSString *)stringFromDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    [formatter setTimeZone:timeZone];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat : @"yyyy年M月d日 HH:mm"];
    NSString *dateString = [formatter stringFromDate:self];

//    NSLog(@"%@", dateString);
    return dateString;
}

+ (NSDate *)dataFromString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+(NSString *)formatDateWithNSString:(NSString *)str{
//    NSDate *date = [NSDate dataFromString:str];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *date = [formatter dateFromString:str];
    return [date formatDate];
}

+(NSString *)stringDateWithInterval:(NSTimeInterval)interval{
    NSDate * realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    return [realDate stringFromDate];
}

+(NSString *)stringDateWithInterval2:(NSTimeInterval)interval{
    
    NSDate * realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    [formatter setTimeZone:timeZone];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat : @"M月d日 HH:mm"];
    NSString *dateString = [formatter stringFromDate:realDate];
    
    return dateString;
}

+(NSString *)stringDateWithInterval3:(NSTimeInterval)interval{
    NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    return [realDate stringFromDate];
}

+(NSString *)stringDateWithInterval4:(NSTimeInterval)interval{
    
    NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    [formatter setTimeZone:timeZone];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat : @"yyyy-M-d HH:mm"];
    NSString *dateString = [formatter stringFromDate:realDate];
    return dateString;
}

+(NSString *)stringDateWithInterval6:(NSTimeInterval)interval{
    
    NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    [formatter setTimeZone:timeZone];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat : @"yyyy-M-d"];
    NSString *dateString = [formatter stringFromDate:realDate];
    return dateString;
}

+(NSString *)stringDateWithInterval7:(NSTimeInterval)interval{
    NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    [formatter setTimeZone:timeZone];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [formatter setDateFormat : @"HH:mm  yyyy-M-d"];
    NSString *dateString = [formatter stringFromDate:realDate];
    return dateString;
}

+(NSString *)stringDateWithInterval8:(NSTimeInterval)interval{
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit ;
    
    NSDate *realday =[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateComponents * realComponent =[calendar components:unitFlags fromDate:realday];
    realday = [calendar dateFromComponents:realComponent];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit fromDate:realday  toDate:[NSDate date] options:0];
    NSInteger year = [comps year];
    
    if (year) {
//        NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-M-d HH:mm"];
        NSString *dateString = [formatter stringFromDate:realday];
        return dateString;
    }
    else{
//        NSDate *realDate =[NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"M-d HH:mm"];
        NSString *dateString = [formatter stringFromDate:realday];
        return dateString;
    }
}

+(NSString *)stringDateWithInterval5:(NSTimeInterval)interval{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    //开始时间
    NSDate *startDate= [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateComponents *dc = [calendar components:flag fromDate:startDate];
    NSString* timeString= [NSString stringWithFormat:@"%d-%d-%d",dc.year, dc.month,dc.day];
    
    //判断是否今天
    NSTimeInterval val =[[NSDate date] timeIntervalSince1970];
    NSInteger temp1 = val / (60 * 60 * 24);
    NSInteger temp2 = interval /(60 * 60 * 24);
    
    if (temp1 == temp2) {
        timeString = [timeString stringByAppendingString:@"今天"];
    }
    else{
        NSInteger w = [dc weekday];
        switch (w) {
            case 1:
                timeString = [timeString stringByAppendingString:@"周日"];
                break;
            case 2:
                timeString = [timeString stringByAppendingString:@"周一"];
                break;
            case 3:
                timeString = [timeString stringByAppendingString:@"周二"];
                break;
            case 4:
                timeString = [timeString stringByAppendingString:@"周三"];
                break;
            case 5:
                timeString = [timeString stringByAppendingString:@"周四"];
                break;
            case 6:
                timeString = [timeString stringByAppendingString:@"周五"];
                break;
            case 7:
                timeString = [timeString stringByAppendingString:@"周六"];
                break;
        }
    }
    
    timeString = [NSString stringWithFormat:@"%02d:%02d", dc.hour, dc.minute];
    return timeString;
}

+(NSInteger)dayTimeDistance:(NSTimeInterval)interval{
    //创建日期格式化对象
/*    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //创建了两个日期对象
    NSDate *startDate   = [dateFormatter dateFromString:@"2014-10-28 00:00"];
    NSDate *endDate     = [dateFormatter dateFromString:@"2014-11-29 23:00"];
*/
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;// | NSHourCalendarUnit | NSMinuteCalendarUnit ;

    //get real year month day hour miniutes
    NSDate *realday =[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateComponents * realComponent =[calendar components:unitFlags fromDate:realday];
    realday = [calendar dateFromComponents:realComponent];
    
    NSDateComponents *comps = [calendar components:NSDayCalendarUnit fromDate:realday  toDate:[NSDate date] options:0];
    return [comps day];
}

@end