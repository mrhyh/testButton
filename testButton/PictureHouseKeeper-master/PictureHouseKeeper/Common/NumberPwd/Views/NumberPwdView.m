//
//  NumberPwdView.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/23.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "NumberPwdView.h"

//输入框边距，这里还可以用控制方框长宽来定制，可解决目前这种密码长度越小密码框越大的问题。
#define KMargin 60

#define basicTag 1000



@implementation NumberPwdView{
    UIView *pwdView;
    UITextField *txtInput;
    
    //提示lable
    UILabel *lblTip;
    
    //第一次输入纪录密码
     NSString *initPwdValue;
    
    //密码长度：不设置默认为6
     NSInteger  pwdCount;
    
    //输入类型：设置还是登录
     Logintype  logintype;

}


-(instancetype)initWithFrame:(CGRect)frame withPwdLength:(NSInteger)len withLoginType:(Logintype)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        pwdCount = len;
        logintype = type;
        [self initViews];
        
    }
    
    return self;

    
}

-(instancetype)initWithFrame:(CGRect)frame withLoginType:(Logintype)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = KColorWithRGBA(0, 0, 0, 0.3);
        logintype = type;
        [self initViews];
        
    }
    
    return self;

}


-(void)initValues:(NSInteger)len withLoginType:(Logintype)type{
    pwdCount = len;
    logintype = type;
}


-(void)initViews{
    //输入框显示view
    if (!pwdCount) {
        pwdCount = 6;
    }
    
    CGFloat lblHeight = (KScreenWidth-2*KMargin)/pwdCount;
    pwdView = [[UIView alloc] initWithFrame:CGRectMake(KMargin, KScreenHeight-222-lblHeight, KScreenWidth, lblHeight)];
    [self addSubview:pwdView];
    
    //隐藏输入框，用来弹出键盘
    txtInput = [[UITextField alloc] init];
    [self addSubview:txtInput];
    [txtInput addTarget:self action:@selector(txtChanged) forControlEvents:UIControlEventEditingChanged];
    txtInput.keyboardType = UIKeyboardTypeDecimalPad;
    [txtInput becomeFirstResponder];
    
    //输入结果提示
    lblTip = [[UILabel alloc] init];
    lblTip.frame = CGRectMake(0, 100, KScreenWidth, 30);
    lblTip.textAlignment = NSTextAlignmentCenter;
    lblTip.textColor = [UIColor redColor];
    [self addSubview:lblTip];
    
    
    for (int i=0; i<pwdCount; i++) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(i*lblHeight, 0, lblHeight, lblHeight);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.borderColor = [KColorWithRGB(216, 216, 216) CGColor];
        lbl.layer.borderWidth =1;
        lbl.tag = basicTag+i;
        lbl.backgroundColor = [UIColor lightGrayColor];
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont systemFontOfSize:40];
        [pwdView addSubview:lbl];
        
    }
    
}

-(void)txtChanged{
    lblTip.text = @"";
    NSInteger len = txtInput.text.length;
    if (len<=pwdCount) {
        [self addBlackPoint:len];
        if (len == pwdCount) {
            
            switch (logintype) {
                case LogintypeInit:
                    if (initPwdValue == nil || [initPwdValue  isEqual: @""]) {
                        initPwdValue = txtInput.text;
                        [self addBlackPoint:0];
                        [self showTip:@"请再次输入"];
                        txtInput.text = @"";
                    }else if([initPwdValue isEqualToString:txtInput.text]){
                        [self showTipNoShake:@"设置成功"];
                        [self savePwd:txtInput.text];
                        if (self.textInputCompleteBlock) {
                            self.textInputCompleteBlock(txtInput.text);
                        }
                    }else{
                        [self showTip:@"两次输入不匹配，请重新输入"];
                        [self addBlackPoint:0];
                        txtInput.text = @"";
                    }
                    
                    break;
                case LogintypeLogin:{
                    //比较答案
                    NSString *op = [self getPwd];
                    if ([op isEqualToString:txtInput.text]) {
                        [self showTipNoShake:@"登录成功"];
                        if (self.textInputCompleteBlock) {
                            self.textInputCompleteBlock(txtInput.text);
                        }

                    }else{
                        [self showTip:@"密码输入错误，请重新输入"];
                        [self addBlackPoint:0];
                        txtInput.text = @"";
                    }
                    
                break;
                }
                default:
                    break;
            }
            
           
        }
    }
    
}

-(void)addBlackPoint:(NSInteger)len{
    for (UILabel *lbl in pwdView.subviews) {
        if (lbl.tag<basicTag+len) {
            lbl.text = @"●";
        }else{
            lbl.text = @"";
        }
    }
    
}


-(void)hide{
    
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self endEditing:YES];
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

-(void)showTip:(NSString *)msg{
    
    lblTip.text = msg;
    
    [self shakeAnimationForView:lblTip];

}

-(void)showTipNoShake:(NSString *)msg{
    
    lblTip.text = msg;
    
}


//抖动效果
- (void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint frame1 = CGPointMake(position.x + 10, position.y);
    CGPoint frame2 = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:frame1]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:frame2]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

-(void)savePwd:(NSString *)pwd{
    
    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:NumberPwdSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getPwd{
    return [[NSUserDefaults standardUserDefaults] valueForKey:NumberPwdSettingKey];
}
@end
