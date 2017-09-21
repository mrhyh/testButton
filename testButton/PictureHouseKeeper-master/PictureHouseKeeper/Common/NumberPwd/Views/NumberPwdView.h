//
//  NumberPwdView.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/23.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LogintypeInit,      //初始化设置
    LogintypeLogin      //登录
}Logintype;

@interface NumberPwdView : UIView


//初始化 (含密码长度)
-(instancetype)initWithFrame:(CGRect)frame withPwdLength:(NSInteger)len withLoginType:(Logintype)type;

//初始化(不含密码长度，默认6位)
-(instancetype)initWithFrame:(CGRect)frame withLoginType:(Logintype)type;

-(void)initValues:(NSInteger)len withLoginType:(Logintype)type;

//输入完成
@property (nonatomic,copy) void(^textInputCompleteBlock)(NSString *result);

//隐藏
-(void)hide;
@end
