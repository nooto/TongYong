//
//  DLocalFileManager.m
//  DCalendar
//
//  Created by GaoAng on 14-6-17.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DLocalFileManager.h"
#include <sys/xattr.h>

@interface DLocalFileManager ()
@end

@implementation DLocalFileManager
static DLocalFileManager* dbconfigShareInstance;

+(DLocalFileManager*) shareInstace{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (dbconfigShareInstance == nil) {
			dbconfigShareInstance = [[ DLocalFileManager alloc] init];
		}
	});
	return dbconfigShareInstance;
}

- (void)dealloc{
}


-(id) init{
	@synchronized(self) {
		if ((self = [super init])) {
		}
		return self;
	}
}

- (void)AddSkipBackupAttributeToFilePath: (NSString *)strFile{
    u_int8_t b = 1;
    setxattr([strFile fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}


-(NSMutableString*)getAccountFolderPath{
    NSString *account = [NSString stringWithFormat:@"%d",[DAccountManagerInstance curAccountInfoUserID]];
    if (account.length <= 0) {
        account= @"EeventPlaza";
    }
	NSString *filePath=@"";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	filePath=[paths objectAtIndex:0];
    [self AddSkipBackupAttributeToFilePath:filePath];

	NSMutableString * aTPath=[NSMutableString stringWithString:filePath];

	[aTPath appendString:@"/"];
	NSMutableString * tempPath =[NSMutableString stringWithString:aTPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",account]];
//    NSMutableString * tempPath =[self getAccountFolderPath];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
            return tempPath;
        }
    }
	return tempPath;
}

- (BOOL)deleteCurAccountFolder{
	NSMutableString * tempPath =[self getAccountFolderPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = FALSE;
	BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir)){
		return YES;
	}
	
	NSError *error = nil;
	[fileManager removeItemAtPath:tempPath error:&error];
	if (error) {
		NSLog(@"removeItemAtPath error:%@",error);
		return NO;
	}
	
	return YES;
}

- (NSString *)filePathWithGid:(NSString *)gid{
    if ([gid length] == 0) return nil;
    NSString *account = [NSString stringWithFormat:@"%d",[DAccountManagerInstance curAccountInfoUserID]];
    if (account.length <= 0) {
        account= @"EeventPlaza";
    }
    NSString *filePath=@"";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    filePath=[paths objectAtIndex:0];
    //阻止被itunes icloud 同步
    [self AddSkipBackupAttributeToFilePath:filePath];
    return [filePath stringByAppendingFormat:@"/%@/%@/",account,gid];
}

- (void)createDirectoryAtPath:(NSString *)path{
    BOOL isDir = FALSE;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || !isDir)
    {
        BOOL bCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
}

-(NSString*)saveImageWithMD5ByGid:(NSString*)gid withImage:(UIImage*)image{
	if (image == nil) {
		return @"";
	}
    
    NSString * gidDir = [self filePathWithGid:gid];
    [self createDirectoryAtPath:gidDir];
    
    __weak NSData *imgData = UIImagePNGRepresentation(image);
    NSString *circleMD5Name = [NSString stringWithFormat:@"%@.jpeg",[Utility circleMD5NameWithData:imgData]];
    [imgData writeToFile:[gidDir stringByAppendingPathComponent:circleMD5Name] atomically:YES];
	return circleMD5Name;
}

-(UIImage*)queryImageByGid:(NSString*)gid withName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
		return nil;
    }
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];

	UIImage *localImage=[[UIImage alloc]initWithContentsOfFile:tempPath];
	return localImage;
}

-(NSData*)queryDataByGid:(NSString*)gid withName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
		return nil;
    }
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];
	NSData *data = [NSData dataWithContentsOfFile:tempPath];
	return data;
}


//查询用户头像。
- (UIImage*)queryUserImageByName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = FALSE;
	BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir))
	{
		return nil;
	}
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];
	
	UIImage *localImage=[[UIImage alloc]initWithContentsOfFile:tempPath];
	return localImage;
}

- (void)saveUserImage:(UIImage*)image WithName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = FALSE;
	BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir))
	{
		BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
		if(!bCreateDir){
			NSLog(@"Create Audio Directory Failed.");
		}
	}
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];

	NSData *imgData = UIImagePNGRepresentation(image);
	[imgData writeToFile:tempPath atomically:YES];
	
}
- (NSString*)getImageMD5Name:(UIImage*)image{
    NSMutableString * tempPath =[self getAccountFolderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    
    //保存图片到临时文件中。
    NSString *tempName = [Utility md5NameWithImage:image];
    [tempPath appendString:[NSString stringWithFormat:@"%@.png",tempName]];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:tempPath atomically:YES];
    
    //对文件签名
    NSString*newName = [Utility md5NameWithFile:tempPath];
    
    //删除临时文件。
    [fileManager removeItemAtPath:tempPath error:nil];
    return [NSString stringWithFormat:@"%@.png",newName];
}

- (NSString*)saveUserImageToName:(UIImage*)image{
	//
	if (image == nil) {
		return @"";
	}
    NSMutableString * tempPath =[self getAccountFolderPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = FALSE;
	BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir))
	{
		BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
		if(!bCreateDir){
			NSLog(@"Create Audio Directory Failed.");
		}
	}
	NSMutableString *newPath = [NSMutableString stringWithString:tempPath];

	//保存图片到临时文件中。
	NSString *tempName = [Utility md5NameWithImage:image];
	[tempPath appendString:[NSString stringWithFormat:@"%@.png",tempName]];
	
	NSData *imgData = UIImagePNGRepresentation(image);
	[imgData writeToFile:tempPath atomically:YES];
	
	//保存到新文件中。
	NSString*newName = [Utility md5NameWithFile:tempPath];

	[newPath appendString:[NSString stringWithFormat:@"%@.png",newName]];
    [fileManager removeItemAtPath:newPath error:nil];
	NSError *error;
	if ([fileManager moveItemAtPath:tempPath toPath:newPath error:&error]) {
		return [NSString stringWithFormat:@"%@.png",newName];
	}
	else{
		NSLog(@"remlace:error  %@", error);
		return @"";
	}
}

- (NSString *)getFullPathAvatorByName:(NSString*)name{
	if (name.length <= 0) {
		return nil;
	}
    NSMutableString * tempPath =[self getAccountFolderPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = FALSE;
	BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir)){
		return nil;
	}
    [tempPath appendString:[NSString stringWithFormat:@"%@",name]];
    return tempPath;
}

- (BOOL)deleteUserImageByName:(NSString*)name{
	if (name.length <= 0) {
		return YES;
	}
    NSString *path = [self getFullPathAvatorByName:name];

    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	[fileManager removeItemAtPath:path error:&error];
	if (error) {
		NSLog(@"removeItemAtPath error:%@",error);
		return NO;
	}
	
	return YES;
}

- (NSString *)getBuddyAvatorPath{
    NSString *homeDir = NSHomeDirectory();
    NSString *tempPath = [homeDir stringByAppendingPathComponent:@"Library"];
    tempPath = [tempPath stringByAppendingPathComponent:@"BuddyAvator"];
    
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        [fileManager removeItemAtPath:tempPath error:nil];//这里有可能有重名的其它文件
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:&err];
        if(!bCreateDir){
            NSLog(@"Create BuddyAvator Directory Failed:%@",err);
        }
    }
    return tempPath;
}


-(UIImage*)getBuddyAvatorImageByName:(NSString*)avatorName{
    NSString *avatorPath = [DFileManager getBuddyAvatorFullPathByName:avatorName];
    UIImage *avatorImage = [UIImage imageWithContentsOfFile:avatorPath];
    return avatorImage;
}

- (BOOL)isBuddyAvatorImageExist:(NSString *)imageName
{
    NSString *avatorPath = [DFileManager getBuddyAvatorFullPathByName:imageName];
    BOOL isDirectory = YES;
    return [[NSFileManager defaultManager] fileExistsAtPath:avatorPath isDirectory:&isDirectory] && !isDirectory;
}

- (NSString *)getBuddyAvatorFullPathByName:(NSString*)name{
    NSString *tempPath = [self getBuddyAvatorPath];
    return [tempPath stringByAppendingPathComponent:name];
}

- (NSString *)saveBuddyAvator:(UIImage*)image{
    if (image == nil) {
        return @"";
    }
    NSString *tempdir = [self getBuddyAvatorPath];
    NSString *tempPath = [tempdir stringByAppendingPathComponent:@"Avator.png"];
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:tempPath error:nil];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:tempPath atomically:YES];
    
    //保存到新文件中。
    NSString*newName = [Utility md5NameWithFile:tempPath];
    newName = [NSString stringWithFormat:@"%@.png",newName];
    NSString *newPath = [tempdir stringByAppendingPathComponent:newName];
    [fileManager removeItemAtPath:newPath error:nil];
    NSError *error;
    if ([fileManager moveItemAtPath:tempPath toPath:newPath error:&error]) {
        return newName;
    }
    else{
        NSLog(@"remlace:error  %@", error);
        return @"";
    }
}

- (BOOL)saveBuddyAvator:(UIImage*)image withName:(NSString*)name{
    NSString *tempPath = [self getBuddyAvatorFullPathByName:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:tempPath error:nil];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    return [imgData writeToFile:tempPath atomically:YES];
}

- (BOOL)deleteBuddyAvatorWithName:(NSString*)name{
    NSString *tempPath = [self getBuddyAvatorFullPathByName:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    return [fileManager removeItemAtPath:tempPath error:&error];
}

-(BOOL)changeEventFolder:(NSString*)scourceGid toDestGidName:(NSString*)dest{
	NSString *scorcePath = [[self getAccountFolderPath] stringByAppendingPathComponent:scourceGid];
	
	NSString *destPath = [[self getAccountFolderPath] stringByAppendingPathComponent:dest];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	if ([fileManager moveItemAtPath:scorcePath toPath:destPath error:&error]) {
		return YES;
	}
	else{
		NSLog(@"remlace:error  %@", scorcePath);
		return NO;
	}
}

- (BOOL)saveImageByGid:(NSString*)gid withName:(NSString*)name image:(UIImage*)image{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];
	NSData *imgData = UIImagePNGRepresentation(image);
	return  [imgData writeToFile:tempPath atomically:YES];
}

-(BOOL)moveItemAtPath:(NSString*)srcPath ToFiLE:(NSString*)newFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	if ([fileManager moveItemAtPath:srcPath toPath:newFile error:&error]) {
		return YES;
	}
	else{
		NSLog(@"remlace:error  %@", srcPath);
		return NO;
	}
}

- (NSString*)getImagePathByGid:(NSString*)gid withName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
	if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
	[tempPath appendString:[NSString stringWithFormat:@"%@",name]];
	return tempPath;
}

- (BOOL)deleteImageByGid:(NSString*)gid withName:(NSString*)name{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir)){
		return YES;
    }
	NSError *error = nil;
	 [fileManager removeItemAtPath:tempPath error:&error];
	if (error) {
		NSLog(@"removeItemAtPath error:%@",error);
		return NO;
	}
	
	return YES;
}

- (BOOL)deleteFolderByGid:(NSString*)gid{
    NSMutableString * tempPath =[self getAccountFolderPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",gid]];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir)){
		return YES;
    }
	NSError *error = nil;
	[fileManager removeItemAtPath:tempPath error:&error];
	if (error) {
		NSLog(@"removeItemAtPath error:%@",error);
		return NO;
	}
	
	return YES;
}

@end
