//
//  AppDelegate.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/11.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "AppDelegate.h"

#import "GestureVerifyViewController.h"
#import "GestureViewController.h"
#import "SeetingViewController.h"
#import "NewFearureViewController.h"
#import "TouchIDViewController.h"
#import "NumberPwdViewController.h"

#import "CommonMarco.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface AppDelegate ()<WeiboSDKDelegate, QQApiInterfaceDelegate>

@end
static NSString * const newFearureId = @"newFearureId";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    self.mainVC = [[MainTabbarVC alloc] init];
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:newFearureId]) {
         self.window.rootViewController = self.mainVC;
    }else{
        NewFearureViewController *newF = [[NewFearureViewController alloc] init];
        self.window.rootViewController = newF;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:newFearureId];
    }


    
    [CommonGlobal shareinstance].isShowtoSettingGesture = NO;
   
    
    [self init3rdParty];
    
    return YES;
}

-(void)LoginWithGesturePwd{
    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeLogin];
         self.window.rootViewController = gestureVc;
    } 
}

-(void)LoginwithTouchID{
//    TouchIDViewController *vc = [[TouchIDViewController alloc] init];
//    self.window.rootViewController = vc;
    
    [self LoginWithGesturePwd];
}


-(void)LoginwithNumberPwd{

    //数字密码
    NumberPwdViewController *numberVC = [[NumberPwdViewController alloc] init];
    numberVC.logType = LogintypeLogin;
    numberVC.pwdCount = 4;
    self.window.rootViewController = numberVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    优先级：touchID－》手势密码－》数字密码
//    开启touchID
    if ([[PublicMethod getValue:TouchIDPwdSettingKey] isEqual:@"ON"]) {
        [self LoginwithTouchID];
    }else if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]>0) {
        [self LoginWithGesturePwd];
    }else if ([[[NSUserDefaults standardUserDefaults] valueForKey:NumberPwdSettingKey] length]>0){
        [self LoginwithNumberPwd];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        //        return [TencentOAuth HandleOpenURL:url];
        return [QQApiInterface handleOpenURL:url delegate:self];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if([[url absoluteString] hasPrefix:@"wx"]) {
        
        SeetingViewController *vc = [[SeetingViewController alloc] init];
        return [WXApi handleOpenURL:url delegate:vc];
        
    }
    
    return NO;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else{
        
        SeetingViewController *vc = [[SeetingViewController alloc] init];
        return [WXApi handleOpenURL:url delegate:vc];

        
    }
}



/**
 *  初始化第三方组件
 */
- (void)init3rdParty
{
    //微信
    [WXApi registerApp:APP_KEY_WEIXIN];
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:APP_KEY_WEIBO];
    
}


#pragma mark - 实现代理回调
/**
 *  微博
 *
 *  @param response 响应体。根据 WeiboSDKResponseStatusCode 作对应的处理.
 *  具体参见 `WeiboSDKResponseStatusCode` 枚举.
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSString *message;
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeSuccess:
            message = @"分享成功";
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
            message = @"取消分享";
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            message = @"分享失败";
            break;
        default:
            message = @"分享失败";
            break;
    }
    showAlert(message);
}

/**
 *  处理来至QQ的请求
 *
 *  @param req QQApi请求消息基类
 */
- (void)onReq:(QQBaseReq *)req
{
    
}

/**
 *  处理来至QQ的响应
 *
 *  @param resp 响应体，根据响应结果作对应处理
 */
- (void)onResp:(QQBaseResp *)resp
{
    NSString *message;
    if([resp.result integerValue] == 0) {
        message = @"分享成功";
    }else{
        message = @"分享失败";
    }
    showAlert(message);
}



@end
