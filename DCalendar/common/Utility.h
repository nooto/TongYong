//
//  Utility.h
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "GTMBase64.h"
#import "KeychainItemWrapper.h"
#import "DBlockAlertView.h"

#define UtilityLOG     [Utility getMillisecond:__FILE__  :__FUNCTION__ :__LINE__]

#define UIIMAGEVIEWKEY @"UiImageViewFinished"

@class MLNavigationController,CAppDelegate;

typedef enum{
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
}NSPUIImageType;

@interface Utility : NSObject

+ (void)showMessage:(NSString*)msg complete:(DBlockAlertViewComplete) complete;

+ (void)showMessage:(NSString*)msg;
+ (void)showMessage:(NSString*)msg title:(NSString*)title;

+(BOOL) isEmptyString:(id)id_;
/** 汉字转换拼音字符
 参数： @“中文”
 返回： @“zhongwen”
 */
+(NSString *)GetThePinYinString:(NSString *)title;
/** 判断字符串是否为空
 参数: NSString
 返回：BOOL  YES:空，NO：不空
 */
+(BOOL) stringIsNULL:(id)id_;

/**
 *	@brief	ios7 之后增加 相机权限设置  设置-隐私-相机
 *
 *	@return	YES:有相机权限  NO 无相机权限
 *
 *	Created by gao on 2014-07-30 14:45
 */
+(BOOL)getAVAuthorizationStatusEnable;



//字符串反转
+(NSString *)stringByReversed:(NSString *)str;

+(NSString*)getChineseCalendarWithDate:(NSDate *)date;


/**
 *  判断字符中是否有 汉字字符
 *
 *  @param sourceText <#sourceText description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)containChineseCharacter:(NSString*)sourceText;

/**
 *	@brief	根据时间间隔秒数进行本地时间显示 消除时区差 八个小时
 *
 *	@param 	val 距离1970.1.1的秒数间隔
 *
 *	@return	当地时间  nsdate
 *
 *	Created by gao on 2014-07-30 14:43
 */
+(NSDate*)getLocaleDataWithTimerInterval:(NSTimeInterval)val;

/**
 *	@brief	根据时间间隔秒数进行本地时间显示 消除时区差 八个小时
 *
 *	@param 	val 距离1970.1.1的秒数间隔
 *
 *	@return	当地时间 字符串 nsstring
 *
 *	Created by gao on 2014-07-30 14:44
 */
+(NSString*)getLocaleDataStringWithTimerInterval:(NSTimeInterval)val;


+ (NSString*)stringWithDate:(NSDate*)date;
+ (NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)formatStr;
+ (NSString*)getTimeStrWithTimeVal:(NSTimeInterval)val;

/**
 *  根据字符 OX000000 & #000000 生成对应的UIColor
 *
 *  @param colorString: OX000000 & #000000
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromColorString:(NSString *)colorString;

/**
 *  根据指定的颜色字符串和透明度 生成对应UIColor
 *
 *  @param colorString colorstring  OX000000 & #000000
 *  @param alpha       透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha;


+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (BOOL)isSystemVersionSeven;
+ (BOOL)isSystemVersionEight;
+(long long)getTimestamp;

+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5NameWithImage:(UIImage *)image;

+ (NSString *)circleMD5NameWithData:(NSData *)data;
+ (NSString *)circleMD5NameWithImage:(UIImage *)image;
+ (NSString *)md5NameWithFile:(NSString *)path;
+ (NSString *)md5NameWithData:(NSData *)data;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage*)getImageByEventType:(NSInteger)eventType;
+ (NSString*)getTitleByEventType:(NSInteger)eventType;

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)sourceImage :(CGSize)targetSize;
//+ (UIImage*)resetImageToMaxSize:(UIImage*)srcImage;

/**
 *	@brief	根据指定的颜色值 size 生成对应大小的纯色图片
 *
 *	@param 	color 	颜色值
 *	@param 	size 	图片大小
 *
 *	@return	uiImage
 *
 *	Created by gao on 2014-09-05 10:50
 */
+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size;

/**
 *	@brief	根据图片 返回图片类型 支持 jpeg
 *
 *	@param 	image 	图片对象
 *
 *	@return	图片类型
 *
 *	Created by gao on 2014-09-15 11:16
 */
+(UIImage*)zipImageData:(UIImage *)image;


//格式化当前时间
+ (NSString *)dateFormatterToString:(NSString *)formatter;

//通过钥匙串存粗uuid  确保删除app devicetoken不变。 但是还原手机后会改变。
+ (NSString *)GetDeviceToken;

//根据uuid 获取活动的gid。
+ (NSString *)GetGidFromCFUUID;

+ (float)getNavBarHight;

/**
 *	@brief  正则判断手机号码地址格式   ps:晨会确认客户端只做手机号码长度的判断，不做正则判断。2014-07-25 09:43:27
 *
 *	@param 	mobileNum
 *
 *	@return	YES or NO
 *
 *	Created by gao on 2014-07-30 14:49
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


// 正则判断电邮地址格式
+ (BOOL)isEmailValid:(NSString*)email;
+ (BOOL) validateMobile:(NSString *)mobile;
/**
 *	@brief	检测身份证号码是否正确
 *
 *	Created by gao on 2014-08-12 14:07
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

+(void)getMillisecond:(const char*)fileName :(const char*)function :(NSInteger)line;

+ (UIColor *)cellDevideLineColor;

typedef enum MOBILETYPE
{
    MOBILE_CM,        //中国移动：China Mobile
    MOBILE_CU,        //中国联通：China Unicom
    MOBILE_CT,        //中国电信：China Telecom
    MOBILE_UNKNOWN    //未知。
}MOBILETYPE;

//判断手机号类型
+ (MOBILETYPE) GetMobileType:(NSString *)mobileNum;

//kCCEncrypt  加密 , kCCDecrypt 解密
+(NSString*)EncryptTripleDES:(NSString*)plainText key:(NSString*)key;
+(NSString*)DecryptTripleDES:(NSString*)plainText key:(NSString*)key;

+ (MLNavigationController *)mainNavController;
//获取星座
+(NSString *)getAstroWithBirthday:(double)tiem;
//获取性别
+(NSString *)getSexWithStr:(NSString *)sex;

+ (NSString *)getAgeWithTime:(double)tiem;

+ (NSString *)model;

/**
 *  计算一段字符串的长度，两个英文字符占一个长度。
 *
 *  @param strtemp
 *
 *  @return nsinter
 */
+ (NSInteger)countOfStrLength:(NSString*)str;
+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font maxWidth:(float)w;

@end
