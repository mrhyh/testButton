//
//  YLGStaticDefine.h
//  SGSecurityAlbum
//
//  Created by hyh on 2017/5/24.
//  Copyright © 2017年 soulghost. All rights reserved.
//

#ifndef YLGStaticDefine_h
#define YLGStaticDefine_h


#endif /* YLGStaticDefine_h */

// 尺寸常量
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)

// 相册选取界面相关
#define SGPhotoCellMargin      0
#define SGPhotoCellGutter      1
#define SGnumberOfPhotosPerRow 3

/*!
 *  将前一个参数转为__weak类型的指针，第二个参数就是__weak型的
 */
#define SGWeakify(src, tgt) __weak __typeof(src) tgt = src

// 颜色
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define RGBColor(r, g, b)     RGBAColor((r), (g), (b), 1.0f)


static NSString * const YLGSGWelcomeViewLoginName       = @"密码锁";
static NSString * const YLGSGWelcomeViewPasswordHint    = @"请输入您的密码";
static NSString * const YLGSGWelcomeViewConfirmPassword = @"请确认您的密码";
static NSString * const YLGSGWelcomeViewPasswordErrorHint = @"密码错误";
static NSString * const YLGSGWelcomeViewAddAccountHint  = @"添加账户";
static NSString * const YLGSGWelcomeViewLoginHint       = @"登录";
static NSString * const YLGSGWelcomeViewRegisterHint    = @"注册";
static NSString * const YLGSGWelcomeViewRLogoutHint     = @"退出";
