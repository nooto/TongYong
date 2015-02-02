//
//  Utility.m
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "Utility.h"
#import "RFPOAPinyin.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "CAppDelegate.h"
#import "SFHFKeychainUtils.h"

#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH


@implementation Utility

+(BOOL) isEmptyString:(id)id_
{
    if([id_ isKindOfClass:[NSNull class]]) return YES;
    if(![id_ isKindOfClass:[NSString class]]) return YES;
    
	if(id_ == nil) return YES;
    
    NSInteger len=[(NSString *)id_ length];
    if (len <= 0) return YES;
	
	return NO;
}

+ (void)showMessage:(NSString*)msg complete:(DBlockAlertViewComplete) complete
{
    DBlockAlertView *alertView = [[DBlockAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       complete:complete
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}


+ (void)showMessage:(NSString*)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
+ (void)showMessage:(NSString*)msg title:(NSString*)title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:title, nil];
    [alertView show];
    
}


+(NSString *)GetThePinYinString:(NSString *)title
{
    if([Utility stringIsNULL:title]) return nil;
    
    NSString * strPinyin = @"";
    for (int i = 0; i < [title length]; i++)
    {
        NSString * tempText=[NSString stringWithFormat:@"%c", [RFPOAPinyin pinyinFirstLetter:[title characterAtIndex:i]]];
        if(tempText == nil) continue;
        tempText=[tempText uppercaseString];
        strPinyin = [strPinyin stringByAppendingString:tempText];
    }
    
    return strPinyin;
}
+(BOOL) stringIsNULL:(id)id_{
    if([id_ isKindOfClass:[NSNull class]]) return YES;
    if(![id_ isKindOfClass:[NSString class]]) return YES;
    
	if(id_ == nil) return YES;
    
    int len=(int)[(NSString *)id_ length];
    if (len <= 0) return YES;
    
	return NO;
}

+(NSString *)stringByReversed:(NSString *)str{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=str.length; i>0; i--) {
        [s appendString:[str substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

+ (NSString*)stringWithDate:(NSDate*)date{
	if (date == nil) {
		date = [NSDate date];
	}
	return [Utility stringWithDate:date withFormat:@"yyyy-MM-dd"];
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
	
//	NSArray *chineseYears = [NSArray arrayWithObjects:
//							 @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
//							 @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
//							 @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
//							 @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
//							 @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
//							 @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
	
	NSArray *chineseMonths=[NSArray arrayWithObjects:
							@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
							@"九月", @"十月", @"冬月", @"腊月", nil];
	
	
	NSArray *chineseDays=[NSArray arrayWithObjects:
						  @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
						  @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
						  @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
	
	
	NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	
	NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
	
//	NSLog(@"%d%d  %@",localeComp.month,localeComp.day, localeComp.date);
	
//	NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
	NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
	NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
	
	NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
	return chineseCal_str;
}

+(NSDate*)getLocaleDataWithTimerInterval:(NSTimeInterval)val{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:val];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	NSInteger interval = [zone secondsFromGMTForDate: date];
	NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
	return localeDate;
}

+(NSString*)getLocaleDataStringWithTimerInterval:(NSTimeInterval)val{
    if (val  <= 10000) {
        return nil;
    }
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:val];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	NSInteger interval = [zone secondsFromGMTForDate: date];
	
	NSString *localeDateStr = [[date  dateByAddingTimeInterval: interval] description];
	if (localeDateStr.length >= 16) {
		localeDateStr = [localeDateStr substringToIndex:16];
	}
	return localeDateStr;
}


+ (NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)formatStr{
	if (date == nil) {
		date = [NSDate date];
	}
	if (formatStr == nil) {
		formatStr = @"yyyy-MM-dd";
	}
	
	NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatStr];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSString *dateStr = [formatter stringFromDate:date];
	return dateStr;
}
+ (NSString *)dateFormatterToString:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+(BOOL)getAVAuthorizationStatusEnable{
    if ([Utility isSystemVersionSeven]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}

//+(BOOL)getAVAuthorizationStatusEnable{
//    if ([Utility isSystemVersionSeven]) {
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
//        {
//            return NO;
//        }
//        else{
//            return YES;
//        }
//    }
//    return NO;
//}



+(BOOL)containChineseCharacter:(NSString*)sourceText{
    for (NSInteger i = 0; i < sourceText.length; i++) {
        unichar c = [sourceText characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}
+ (UIColor *) colorFromColorString:(NSString *)colorString{
    return [Utility colorFromColorString:colorString alpha:1.0f];
}

+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha{
    NSString *stringToConvert = @"";
    stringToConvert = [colorString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [colorString componentsSeparatedByString:@","];
        return [UIColor colorWithRed:([array[0] intValue]/255.0) green:([array[1] intValue]/255.0) blue:([array[2] intValue]/255.0) alpha:1.0];
    }
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] > 6)
        cString = [cString substringToIndex:6];

    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:1.0f];
}

+(long long)getTimestamp{
	long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
	return timestamp;
}

+ (BOOL)isSystemVersionSeven{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        return YES;
    }
    return NO;
    
}+ (BOOL)isSystemVersionEight{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isSystemVersionSix{
	if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] <7.0)
	{
		return YES;
	}
	return NO;
}
+ (float)getNavBarHight{
	if ([self isSystemVersionSeven]) {
		return 64;
	}
	else{
		return 44;
	}
}

+ (NSInteger)countOfStrLength:(NSString*)str {
    NSInteger strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSInteger)indexOfStr:(NSString*)str maxLength:(NSInteger)maxCount{
    NSInteger strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font maxWidth:(float)w{
    
    CGSize retSize = CGSizeZero;
    
    CGSize textBlockMinSize = {w, CGFLOAT_MAX};
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
        NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        retSize = [str boundingRectWithSize:textBlockMinSize options:options attributes:@{NSFontAttributeName:font} context:nil].size;
        
        
    }else{
        retSize = [str sizeWithFont:font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return retSize;
}

//获取星座
+(NSString *)getAstroWithBirthday:(double)tiem
{
    if (tiem ==0) return nil;
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:tiem];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
    NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ;
    
    //get real year month day hour miniutes
    NSDateComponents * realComponent =[calendar components:unitFlags fromDate:myDate];
    NSInteger month = realComponent.month;
    NSInteger day = realComponent.day;
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    result=[NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(month *2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}

//获取性别
+(NSString *)getSexWithStr:(NSString *)sex{
    NSString *sexStr = @"";
    if ([sex isEqualToString:@"M"]) {
        sexStr = @"男";
    }
    else if([sex isEqualToString:@"F"]) {
        sexStr = @"女";
    }
    else {
        sexStr = @"未选择";
    }
    return sexStr;
}
//获取年龄
+ (NSString *)getAgeWithTime:(double)tiem{
    if (tiem ==0) {
        return nil;
    }
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:tiem];
    NSDate* now = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:myDate  toDate:now  options:0];
    NSInteger year = [comps year];
    return  [NSString stringWithFormat:@"%d岁",year];
}


+ (UIColor *)cellDevideLineColor
{
    return [Utility colorFromColorString:@"e1e1e1"];
}

//获取当前时间 毫秒级别。
+(void)getMillisecond:(const char*)fileName :(const char*)function :(NSInteger)line{
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSLog(@"%s: %d: %@", function, line, [formatter stringFromDate:[NSDate date]]);
//    NSLog(@"%d  %@",line, [formatter stringFromDate:[NSDate date]]);
    return;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
	
	//2014-07-25 09:43:27 晨会确认客户端只做手机号码长度的判断。不做正则判断。
	if (mobileNum.length == 11) {
		return YES;
	}
	else{
		NO;
	}
	
	
	NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|170)\\d{8}$";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
	if ([mobileNum length]==11 && [phoneTest evaluateWithObject:mobileNum]) {
		return YES;
	}
	return NO;
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//判断手机号类型
+ (MOBILETYPE) GetMobileType:(NSString *)mobileNum
{
    /**
     10	     * 中国移动：China Mobile
     11	     * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,188
     12	     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|8[2378])\\d)\\d{7}$";
    /**
     15	     * 中国联通：China Unicom
     16	     * 130,131,132,155,156,185,186 145
     17	     */
    NSString * CU = @"^1(3[0-2]|45|5[56]|8[56])\\d{8}$";
    /**
     20	     * 中国电信：China Telecom
     21	     * 133,1349,153,180,189
     22	     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25	     * 大陆地区固话及小灵通
     26	     * 区号：010,020,021,022,023,024,025,027,028,029
     27	     * 号码：七位或八位
     28	     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestcm evaluateWithObject:mobileNum] == YES)
	{
        return MOBILE_CM;
    }
    else if([regextestct evaluateWithObject:mobileNum] == YES)
    {
        return MOBILE_CT;
    }
	else
	{
        if([regextestcu evaluateWithObject:mobileNum] == YES)
        {
            return MOBILE_CU;
        }
    }
    return MOBILE_UNKNOWN;
}

///身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 正则判断电邮地址格式
+ (BOOL)isEmailValid:(NSString*)email
{
    //    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    //    return [emailTest evaluateWithObject:email];
    
    
    NSString* regex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([regextest evaluateWithObject:email] == YES)
	{
        return YES;
    }
	else
	{
        return NO;
    }
    return NO;
    
}

+(NSString*)getTimeStrWithTimeVal:(NSTimeInterval)val{
    
    //
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:val];
    //开始时间
    NSDateComponents *startComponent = [calendar components:NSCalendarUnitMonth |
                                        NSCalendarUnitYear|
                                        NSCalendarUnitDay |
                                        NSCalendarUnitHour|
                                        NSCalendarUnitWeekOfYear|
                                        NSCalendarUnitWeekday|
                                        NSCalendarUnitMinute
                                                   fromDate:startDate];
    
    //今天
    NSDateComponents *todayComponent = [calendar components:NSCalendarUnitMonth |
                                        NSCalendarUnitYear|
                                        NSCalendarUnitDay |
                                        NSCalendarUnitHour|
                                        NSCalendarUnitWeekOfYear|
                                        NSCalendarUnitWeekday|
                                        NSCalendarUnitMinute
                                                   fromDate:[NSDate date]];
    
    NSMutableString *timeStr = [NSMutableString string];
    
    //年
    //	if (todayComponent.year != startComponent.year) {
    //		[timeStr appendFormat:@"%d-",startComponent.year];
    //	}
    [timeStr appendFormat:@"%d-",startComponent.year];
    
    //月日。
    [timeStr appendFormat:@"%02d-%02d ", startComponent.month, startComponent.day];
    
    
    NSInteger startDays = val / (60 * 60 * 24);
    NSInteger todayDays = [[NSDate date] timeIntervalSince1970] / (60 * 60 * 24);
    
    if (startDays == todayDays) {
        [timeStr appendFormat:@"(今天)"];
    }
    else if (startDays == todayDays +1){
        [timeStr appendFormat:@"(明天)"];
    }
    else{
        //本周
        NSString *curWeek=@"";
        if (todayComponent.weekOfYear == startComponent.weekOfYear) {
            curWeek=@"本";
        }
        else if (todayComponent.weekOfYear == startComponent.weekOfYear - 1){
            curWeek=@"下";
        }
        
        if (startComponent.weekday == 1) {
            
            if (todayComponent.weekOfYear  == startComponent.weekOfYear -1) {
                [timeStr  appendFormat:@"(%@周日)",@"本"];
            }
            else if (todayComponent.weekOfYear == startComponent.weekOfYear - 2){
                [timeStr  appendFormat:@"(%@周日)",@"下"];
            }
        }
        else if (startComponent.weekday == 2){
            [timeStr  appendFormat:@"(%@周一)",curWeek];
        }
        else if (startComponent.weekday == 3){
            [timeStr  appendFormat:@"(%@周二)",curWeek];
        }
        else if (startComponent.weekday == 4){
            [timeStr  appendFormat:@"(%@周三)",curWeek];
        }
        else if (startComponent.weekday == 5){
            [timeStr  appendFormat:@"(%@周四)",curWeek];
        }
        else if (startComponent.weekday == 6){
            [timeStr  appendFormat:@"(%@周五)",curWeek];
        }
        else if (startComponent.weekday == 7){
            [timeStr  appendFormat:@"(%@周六)",curWeek];
        }
    }
    [timeStr  appendFormat:@" %02d:%02d",startComponent.hour, startComponent.minute];
    return timeStr;
}

+ (UIImage*)getImageByEventType:(NSInteger)eventType{
	switch (eventType) {
		case TYPE_HIKING:
			return [UIImage imageNamed:@"徒步"];
			break;
		case TYPE_MOUNTAIN:
			return [UIImage imageNamed:@"登山"];
			break;
		case TYPE_RIDING:
			return [UIImage imageNamed:@"骑行"];
			break;
		case TYPE_RUNNING:
			return [UIImage imageNamed:@"跑步"];
			break;
		case TYPE_MEETING:
			return [UIImage imageNamed:@"其它"];
			break;
		case TYPE_BALL:
			return [UIImage imageNamed:@"球类"];
			break;
		case TYPE_TRAVEL:
			return [UIImage imageNamed:@"其它"];
			break;
		case TYPE_OTHER:
			return [UIImage imageNamed:@"其它"];
			break;
		case TYPE_DRIVERING:
			return [UIImage imageNamed:@"自驾"];
			break;
		case TYPE_GONGYI:
			return [UIImage imageNamed:@"其它"];
			break;
            
        case TYPE_SWIMMING:
            return [UIImage imageNamed:@"游泳"];
            break;
			
		default:
			return [UIImage imageNamed:@"其它"];
			break;
	}
	return [UIImage imageNamed:@"其它"];
    
}
+ (NSString*)getTitleByEventType:(NSInteger)eventType{
	switch (eventType) {
		case TYPE_HIKING:
			return @"徒步";
			break;
		case TYPE_MOUNTAIN:
			return @"登山";
			break;
		case TYPE_RIDING:
			return @"骑行";
			break;
		case TYPE_RUNNING:
			return @"跑步";
			break;
		case TYPE_MEETING:
			return @"其它";
			break;
		case TYPE_BALL:
			return @"球类";
			break;
		case TYPE_TRAVEL:
			return @"其它";
			break;
		case TYPE_OTHER:
			return @"其它";
			break;
		case TYPE_DRIVERING:
			return @"自驾";
			break;
		case TYPE_GONGYI:
			return @"其它";
			break;
            
        case TYPE_SWIMMING:
            return @"游泳";
            break;
			
		default:
			return @"其它";
			break;
	}
    return @"其它";
}

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#define KUUID_Key   @"uuidkey_com.richinfo.DCalendar"
#define KUUID_Value @"uuid_com.richinfo.DCalendar"
+ (NSString *)GetDeviceToken{

    NSString *uuid = [SFHFKeychainUtils getPasswordForUsername:KUUID_Value andServiceName:KUUID_Key error:nil];
	if ( [self isEmptyString:uuid]) {
		CFUUIDRef puuid = CFUUIDCreate(nil);
		CFStringRef uuidstring = CFUUIDCreateString(nil, puuid);
		
		uuid =(__bridge NSString*) CFStringCreateCopy(NULL, uuidstring);
		CFRelease(puuid);
		CFRelease(uuidstring);
		
        [SFHFKeychainUtils storeUsername:KUUID_Value andPassword:uuid forServiceName:KUUID_Key updateExisting:YES error:nil];
	}
	return uuid;
}

+ (NSString *)GetGidFromCFUUID{
	NSString *CFUUIDString = @"";
	CFUUIDRef puuid = CFUUIDCreate(nil);
	CFStringRef uuidstring = CFUUIDCreateString(nil, puuid);

	CFUUIDString =(__bridge NSString*) CFStringCreateCopy(NULL, uuidstring);
	CFRelease(puuid);
	CFRelease(uuidstring);

	return CFUUIDString;
}

+(NSString*)EncryptTripleDES:(NSString*)plainText key:(NSString*)key{
	
//	if (key == nil) {
//		NSString* deskey = [DESKEY stringByAppendingString:[Utility GetDeviceToken]];
//		return [self TripleDES:plainText key:deskey encryptOrDecrypt:kCCEncrypt];
//	}
//	else{
		return [self TripleDES:plainText key:key encryptOrDecrypt:kCCEncrypt];
//	}
}

+(NSString*)DecryptTripleDES:(NSString*)plainText key:(NSString*)key{
//	if (key == nil) {
//		NSString* deskey = [DESKEY stringByAppendingString:[Utility GetDeviceToken]];
//		return [self TripleDES:plainText key:deskey encryptOrDecrypt:kCCDecrypt];
//	}
//	else{
		return [self TripleDES:plainText key:key encryptOrDecrypt:kCCDecrypt];
//	}
}

+(NSString*)TripleDES:(NSString*)plainText key:(NSString*)key encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    if (!plainText || !key) return nil;
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [XDGTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
//	NSString* deskey = [DESKEY stringByAppendingString:[Utility GetUUID]];
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
	
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [XDGTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

+(UIImage*)zipImageData:(UIImage *)image{

    CGFloat scale = [[UIScreen mainScreen] scale];//设备的分辨率: 1代表320*480  2代表640*960
    if(scale >1) scale = 1.5;
    CGRect winRect = [[UIScreen mainScreen] bounds];
    CGSize winSize = CGSizeMake(winRect.size.width*scale, winRect.size.height*scale);
    CGSize imageSize = image.size;
    if ((winSize.width < imageSize.width) || (winSize.height < imageSize.height)){
        
        // calculate min/max zoomscale
        CGFloat xScale = winSize.width  / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = winSize.height / imageSize.height;   // the scale needed to perfectly fit the image height-wise
        
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        //    BOOL imagePortrait = _imageSize.height > _imageSize.width;
        //    BOOL phonePortrait = boundsSize.height > boundsSize.width;
        CGFloat minScale = MIN(xScale, yScale);//imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);

        imageSize.width = imageSize.width*minScale;
        imageSize.height = imageSize.height*minScale;
    }

    UIGraphicsBeginImageContext(imageSize);
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
    
//    NSData *imgdata = UIImageJPEGRepresentation(image, 0.5f);
//    NSLog(@"---src length:%lu", (unsigned long)imgdata.length);
//    return [UIImage imageWithData:imgdata];
/*
    float i = 0.9;
    NSData *imgdata = UIImageJPEGRepresentation(image, i);
    while (imgdata.length >= KMAXIMAGESIZE && i > 0.01) {
        imgdata = UIImageJPEGRepresentation(image, i);
        i = i *0.9f;
        NSLog(@"---lenght: %lu, %d, %f", (unsigned long)imgdata.length, KMAXIMAGESIZE,i);
    }
    
    return [UIImage imageWithData:imgdata];*/
}

//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)sourceImage :(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
	 extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
	 把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
	 x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
	 NSLog("%02X", 0x888);  //888
	 NSLog("%02X", 0x4); //04
     */
}
+ (NSString *)md5NameWithImage:(UIImage *)image{
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
	NSData* data;
	if (UIImagePNGRepresentation(image)) {
		data = UIImagePNGRepresentation(image);
	}
	else {
		data = UIImageJPEGRepresentation(image, 1.0);
	}
	
	if (!data || ! [data length]) {
		return nil;
	}
	
	char *cStr=(char*)[data bytes];
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
			 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3],
			 result[4], result[5], result[6], result[7],
			 result[8], result[9], result[10], result[11],
			 result[12], result[13], result[14], result[15]
			 ] lowercaseString];
}


+ (NSString *)md5NameWithFile:(NSString *)path{
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
		return nil;
	}
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done){
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
	
	return [s lowercaseString];
}

+ (NSString *)circleMD5NameWithImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    return [self circleMD5NameWithData:data];
}

+ (NSString *)circleMD5NameWithData:(NSData *)data
{
    if (!data || ! [data length]) {
        return nil;
    }
    NSInteger readLength = 0;
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    char *buffer[256];
    while(readLength < data.length){
        NSInteger length = 256;
        if (data.length - readLength < 256) {
            length = data.length - readLength;
        }
        [data getBytes:buffer range:NSMakeRange(readLength, length)];
        CC_MD5_Update(&md5, buffer, length);
        readLength += length;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return [s lowercaseString];
}

+ (NSString *)md5NameWithData:(NSData *)data{
	
	
	if (!data || ! [data length]) {
		return nil;
	}
	
	char *cStr=(char*)[data bytes];
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
			 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3],
			 result[4], result[5], result[6], result[7],
			 result[8], result[9], result[10], result[11],
			 result[12], result[13], result[14], result[15]
			 ] lowercaseString];
	
}

+ (MLNavigationController *)mainNavController
{
    CAppDelegate *app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
    MLNavigationController *mainNavControll =(MLNavigationController*)app.window.rootViewController;
    return mainNavControll;
}

+ (NSString *)model
{
    return [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
}


@end
