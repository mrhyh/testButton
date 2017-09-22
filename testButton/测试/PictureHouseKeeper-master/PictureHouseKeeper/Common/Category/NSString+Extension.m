//
//  NSString+Extension.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/16.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(NSString *)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

@end
