//
//  FilePicManager.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/17.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonGlobal : NSObject


+(CommonGlobal *)shareinstance;

@property (nonatomic,assign) BOOL  isShowtoSettingGesture;

@end
