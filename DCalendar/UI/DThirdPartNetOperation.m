//
//  DThirdPartNetOperation.m
//  DCalendar
//
//  Created by hunanldc on 14-11-5.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DThirdPartNetOperation.h"

@interface DThirdPartNetOperation ()

@property (strong, nonatomic)DBaseRequest *request;

@end

@implementation DThirdPartNetOperation

- (DThirdPartNetOperation *)initWithRequest:(DBaseRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}


@end
