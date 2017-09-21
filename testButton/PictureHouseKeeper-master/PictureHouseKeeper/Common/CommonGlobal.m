//
//  FilePicManager.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/17.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "CommonGlobal.h"

@implementation CommonGlobal

+(CommonGlobal *)shareinstance{
    static CommonGlobal *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CommonGlobal alloc] init];
    });
    return instance;
}



@end
