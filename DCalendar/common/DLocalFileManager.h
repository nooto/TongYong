//
//  DLocalFileManager.h
//  DCalendar
//
//  Created by GaoAng on 14-6-17.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DFileManager [DLocalFileManager shareInstace]

@interface DLocalFileManager : NSObject
+(DLocalFileManager*) shareInstace;

- (BOOL)deleteCurAccountFolder;

- (UIImage*)queryImageByGid:(NSString*)gid withName:(NSString*)name;

//本地数据
- (BOOL)saveImageByGid:(NSString*)gid withName:(NSString*)name image:(UIImage*)image;
- (NSString*)getImagePathByGid:(NSString*)gid withName:(NSString*)name;

-(BOOL)moveItemAtPath:(NSString*)srcPath ToFiLE:(NSString*)newFile;
-(NSData*)queryDataByGid:(NSString*)gid withName:(NSString*)name;

//服务器的数据。
- (BOOL)deleteImageByGid:(NSString*)gid withName:(NSString*)name;
- (BOOL)deleteFolderByGid:(NSString*)gid;

//查询用户头像。
//- (UIImage*)queryUserImageByName:(NSString*)name;
//- (NSString*)saveUserImageToName:(UIImage*)image;
//- (NSString *)getFullPathAvatorByName:(NSString*)name;
//- (void)saveUserImage:(UIImage*)image WithName:(NSString*)name;
//- (BOOL)deleteUserImageByName:(NSString*)name;

- (NSString *)getBuddyAvatorFullPathByName:(NSString*)name;
- (NSString *)saveBuddyAvator:(UIImage*)image;
- (BOOL)saveBuddyAvator:(UIImage*)image withName:(NSString*)name;
- (BOOL)deleteBuddyAvatorWithName:(NSString*)name;

/**
 *  更据图片文件名字 查询本地是否有对应图片
 *
 *  @param avatorName 图片文件名字
 *
 *  @return uiimage
 */
-(UIImage*)getBuddyAvatorImageByName:(NSString*)avatorName;

/**
 *  本地是否已经存在该头像
 *
 *  @param imageName 头像名
 *
 *  @return 是否存在
 */
- (BOOL)isBuddyAvatorImageExist:(NSString *)imageName;

/**
 *  根据 image  获取 对应的 md5 文件签名。
 *
 *  @param image 需要签名的图片
 *
 *  @return 签名。
 */
- (NSString*)getImageMD5Name:(UIImage*)image;

    
-(NSString*)saveImageWithMD5ByGid:(NSString*)gid withImage:(UIImage*)image;

-(BOOL)changeEventFolder:(NSString*)scourceGid toDestGidName:(NSString*)destGid;

@end
