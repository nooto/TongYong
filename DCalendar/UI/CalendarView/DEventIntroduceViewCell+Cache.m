//
//  DEventIntroduceViewCell+Cache.m
//  DCalendar
//
//  Created by hunanldc on 14-10-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DEventIntroduceViewCell+Cache.h"
#import <objc/runtime.h>

@implementation DEventIntroduceViewCell (Cache)

- (NSMutableDictionary *)shareImageViewCache
{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wgnu"
    id object = objc_getAssociatedObject(self,@selector(shareImageViewCache));
    if (!object) {
        objc_setAssociatedObject(self, @selector(shareImageViewCache), [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self,@selector(shareImageViewCache));;
//#pragma clang diagnostic pop
}

- (UIImageView *)imageViewWithGid:(NSString *)gid name:(NSString *)imageName originY:(CGFloat)framHight
{
    UIImageView *imageView = [[self shareImageViewCache] valueForKey:[gid stringByAppendingString:imageName]];
    if (imageView) {
        imageView.frame = CGRectMake(16, framHight, ScreenWidth - 16*2, 40);
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, framHight, ScreenWidth - 16*2, 40)];
        
        UIImage *locimage= [DFileManager queryImageByGid:gid withName:imageName];
        if (locimage) {
            CGSize imageSize = [self contrainSize:CGSizeMake(300.f, 200.f) image:locimage];
            imageView.frame = CGRectMake((ScreenWidth - imageSize.width)/2, framHight + 10, imageSize.width, imageSize.height);
            [imageView setImage:locimage];
        }
        else{
            NSString *urlStr = [NSString stringWithFormat:IMAGESERVERURL,imageName];
            NSURL *URL= [NSURL URLWithString:urlStr];
            
            __weak typeof(UIImageView*) _iamgeView = imageView;
            __weak typeof(DEventIntroduceViewCell*) _self = self;
            imageView.tag = 0;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];

            [imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"上传失败-默认图片"]
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          if (image) {
                                              CGSize imageSize = [self contrainSize:CGSizeMake(ScreenWidth -16*2, 200.f) image:image];
                                              _iamgeView.frame = CGRectMake((ScreenWidth - imageSize.width)/2, framHight + (200 - imageSize.height)/2, imageSize.width, imageSize.height);
                                              _iamgeView.image = image;
                                              [DFileManager saveImageByGid:gid withName:imageName image:image];
                                              
//                                              UITableView *superView = (UITableView *)_self.superview;
//                                              if (![superView isKindOfClass:[UITableView class]]) {
//                                                  superView = (UITableView *)_self.superview.superview;
//                                              }
//                                              if (superView) {
//                                                  [superView reloadData];
//                                                  [superView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[superView indexPathForCell:_self]] withRowAnimation:UITableViewRowAnimationMiddle];
//                                              }
                                              [_self reloadData];
                                              _iamgeView.tag = 1;
                                          }
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          _iamgeView.tag = 0;
                                      }];
        }
        
        //缓存ImageView
        [[self shareImageViewCache] setObject:imageView forKey:[gid stringByAppendingString:imageName]];

    }
    return imageView;
}

- (void)reloadData
{
    UITableView *superView = (UITableView *)self.superview;
    if (![superView isKindOfClass:[UITableView class]]) {
        superView = (UITableView *)self.superview.superview;
    }
    if ([[superView visibleCells] containsObject:self]) {
        [superView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[superView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (CGSize)contrainSize:(CGSize)maxSize image:(UIImage *)image
{
    if (image.size.width >= 300) {
        CGFloat  hiht = image.size.height * 300 /image.size.width;
        return CGSizeMake(300, hiht);
    }
    else{
        return image.size;
    }
    
}

@end
