//
//  TouchWindow.m
//  TouchIDDemo
//
//  Created by Ben on 16/3/11.
//  Copyright © 2016年 https://github.com/CoderBBen/YBTouchID.git. All rights reserved.
//

#import "TouchWindow.h"
#import <LocalAuthentication/LAContext.h>



@interface TouchWindow ()<UIAlertViewDelegate>



@property (nonatomic, strong) LAContext *context;

@end

@implementation TouchWindow{
   
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *zhiwen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 64)];
        zhiwen.center = CGPointMake(KScreenWidth/2, 200);
        zhiwen.image = [UIImage imageNamed:@"zhiwen"];
        [self addSubview:zhiwen];
        
    

    }
    
    return self;
}

- (void)show
{
    [self alertEvaluatePolicyWithTouchID];
}

- (void)dismiss
{
    if (_context) {
        _context = nil;
    }
    [self removeFromSuperview];
}


- (void)alertEvaluatePolicyWithTouchID
{
    _context = [LAContext new];
    NSError *error;
    if([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
        NSLog(@"Yeah,Support touch ID");
        
        //if return yes,whether your fingerprint correct.
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按下Home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                [self imageViewShowAnimation];
            }
            else
            {
                NSLog(@"＝＝＝＝＝＝＝＝＝＝＝%@",error.localizedDescription);
                switch (error.code) {
                    case kLAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case kLAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case kLAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        //用户选择其他验证方式，切换主线程处理
                        [self dismiss];

                        break;
                    }
                    default:
                    {
                        NSLog(@" default ");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
                
                
//                NSLog(@"指纹认证失败，%@",error.description);
//                // 错误码 error.code
//                // -1: 连续三次指纹识别错误
//                // -2: 在TouchID对话框中点击了取消按钮
//                // -3: 在TouchID对话框中点击了输入密码按钮
//                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
//                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码

            }
        }];
    }
    else
    {

        NSLog(@"Sorry,The device doesn't support touch ID");
    }
    
}

- (void)imageViewShowAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            [self dismiss];
        }];
    });
}


@end
