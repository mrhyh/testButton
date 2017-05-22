//
//  ViewController.m
//  testButton
//
//  Created by hyh on 2017/3/13.
//  Copyright © 2017年 hyh. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSString *StartRecord = @"开始";
static NSString *StopRecord = @"结束";

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#define AnimationDuration (0.3)

@interface ViewController () <RPBroadcastActivityViewControllerDelegate,RPPreviewViewControllerDelegate>

@property (nonatomic, strong)UIButton *btnStart;
@property (nonatomic, strong)UIButton *btnStop;
@property (nonatomic, strong)NSTimer *progressTimer;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, strong)UIView *tipView;
@property (nonatomic, strong)UILabel *lbTip;
@property (nonatomic, strong)UILabel *lbTime;


//test Switch效果

@property (nonatomic, strong) UIView *switchBGView;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) UIView *oneView;


@property (nonatomic, strong) UIButton *testButton;

@property (strong, nonatomic) IBOutlet UIButton *testButton11;

@property (strong, nonatomic) IBOutlet UIView *testView;

@end



@implementation ViewController

- (UIView *)createViewWithColor:(UIColor *)color rect:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString *ipString = [self getIPAddress];
    
    //方法二：个人推荐用这个请求，速度比较快
    /*
     http://ipof.in/json
     http://ipof.in/xml
     http://ipof.in/txt
     If you want HTTPS you can use the same URLs with https prefix. The advantage being that even if you are on a Wifi you will get the public address.
     */
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://ipof.in/txt"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"1");
    dispatch_queue_t main = dispatch_get_main_queue();
    
    if ( dispatch_get_current_queue() != main ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2");
        });
    }
    
    NSLog(@"3");
    
    NSString *a = @"Ab的...";
    NSLog(@"%lu",(unsigned long)a.length);
    NSString *b = @"Ab的..";
    NSLog(@"%lu",(unsigned long)b.length);
    NSString *c = @"中国..";
    NSLog(@"%lu",(unsigned long)c.length);
    NSString *d = @"中国";
    NSLog(@"%lu",(unsigned long)d.length);
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 80, 80)];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view2.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view2.bounds;
    maskLayer.path = maskPath.CGPath;
    view2.layer.mask = maskLayer;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0, 80, 40)];
    //imageView.alpha = 0.0;
    imageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0];
    
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    imageView.backgroundColor = [UIColor yellowColor];
    
    imageView.contentMode = UIViewContentModeTopRight;
    imageView.layer.borderWidth = 3.0;
    imageView.layer.borderColor = [UIColor yellowColor].CGColor;
    [imageView setImage:[UIImage imageNamed:@"3.jpeg"]];
    [imageView sizeToFit];
    //[imageView sizeThatFits:CGSizeMake(80, 40)];
    
    UIView *onImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 300)];
    onImageView.backgroundColor = [UIColor redColor];
    onImageView.userInteractionEnabled = YES;
    [imageView addSubview:onImageView];
    
    UITapGestureRecognizer *generalizeViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generalizeViewAction)];
//    generalizeViewTapGesture.numberOfTapsRequired = 1;
//    generalizeViewTapGesture.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:generalizeViewTapGesture];
    
    
    //测试异常捕获
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"1"];
    [array addObject:@"2"];
    //NSLog(@"%@",array[9]);
    
    UIButton *testScreenCAPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 80, 40)];
    [testScreenCAPButton setTitle:@"录屏" forState:UIControlStateNormal];
    testScreenCAPButton.backgroundColor = [UIColor grayColor];
    [testScreenCAPButton addTarget:self action:@selector(testScreenCAPButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testScreenCAPButton];
    
    
    [self testSwitchButton];
    
    
    
    
    
    _testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, 50, 50)];
    _testButton.backgroundColor = [UIColor blueColor];
    [_testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view33 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view33.backgroundColor = [UIColor redColor];
    [_testButton addSubview:view33];
    
    [self.view addSubview:_testButton];
    
    
    _testView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    _testView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_testView];
    
}

- (void)testButtonAction {
    _testButton.frame = CGRectMake(250, 400, 100, 100);
}


- (IBAction)testButton11Action:(UIButton *)sender {
    _testView.frame = CGRectMake(250, 400, 100, 100);
}


- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


- (void)testSwitchButton {
    _switchBGView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    _switchBGView.layer.cornerRadius = 20;
    _switchBGView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_switchBGView];
    
    _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    _switchButton.userInteractionEnabled = NO;
    _switchButton.backgroundColor = [UIColor whiteColor];
    [_switchButton setImage:[UIImage imageNamed:@"弹按钮灰-"] forState:UIControlStateNormal];
    _switchButton.layer.cornerRadius = 18.0;
    [_switchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_switchBGView addSubview:_switchButton];
    
    _switchBGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_switchBGView addGestureRecognizer:tapGesture];
}


- (void)click:(UITapGestureRecognizer *)gesture {
    _isSwitchOn = !_isSwitchOn;
    
    if (_isSwitchOn) {
         _switchBGView.backgroundColor = [UIColor blueColor];
        [_switchButton setImage:[UIImage imageNamed:@"弹按钮蓝-"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            _switchButton.transform = CGAffineTransformMakeTranslation(60, 0); // 移动位置
        }];
        
    }else {
         _switchBGView.backgroundColor = [UIColor greenColor];
        [_switchButton setImage:[UIImage imageNamed:@"弹按钮灰-"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 animations:^{
            _switchButton.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)testScreenCAPButtonAction {
    [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
        broadcastActivityViewController.delegate = self;
        [self presentViewController:broadcastActivityViewController animated:YES completion:nil];
    }];
}

- (void) generalizeViewAction {
    NSLog(@"11111111");
}



- (void)viewDidAppear:(BOOL)animated {
    BOOL isVersionOk = [self isSystemVersionOk];
    
    if (!isVersionOk) {
        NSLog(@"系统版本需要是iOS9.0及以上才支持ReplayKit");
        return;
    }
    if (SIMULATOR) {
        [self showSimulatorWarning];
        return;
    }
    
    UILabel *lb = nil;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    
    //标题
    lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    lb.font = [UIFont boldSystemFontOfSize:32];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 3;
    lb.text = @"苹果ReplayKit Demo";
    lb.center =  CGPointMake(screenSize.width/2, 80);
    [self.view addSubview:lb];
    
    //创建按钮
    UIButton *btn = [self createButtonWithTitle:StartRecord andCenter:CGPointMake(screenSize.width/2 - 100, 200)];
    [self.view addSubview:btn];
    self.btnStart = btn;
    
    btn = [self createButtonWithTitle:StopRecord andCenter:CGPointMake(screenSize.width/2 + 100, 200)];
    [self.view addSubview:btn];
    self.btnStop = btn;
    [self setButton:btn enabled:NO];
    
    //loading指示
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 8.0f;
    view.center = CGPointMake(screenSize.width/2, 300);
    activity.center = CGPointMake(30, view.frame.size.height/2);
    [view addSubview:activity];
    [activity startAnimating];
    self.activity = activity;
    lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
    lb.font = [UIFont boldSystemFontOfSize:20];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.layer.cornerRadius = 4.0;
    lb.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lb];
    self.lbTip = lb;
    self.tipView = view;
    [self hideTip];
    
    
    //显示时间（用于看录制结果时能知道时间）
    lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    lb.font = [UIFont boldSystemFontOfSize:20];
    lb.backgroundColor = [UIColor redColor];
    lb.textColor = [UIColor blackColor];
    lb.layer.cornerRadius = 4.0;
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat: @"HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    lb.text =  dateString;
    lb.center = CGPointMake(screenSize.width/2, screenSize.height/2 + 100);
    lb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lb];
    self.lbTime = lb;
    
    //进度条 （显示动画，不然看不出画面的变化）
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width*0.8, 10)];
    progress.center = CGPointMake(screenSize.width/2, screenSize.height/2 + 150);
    progress.progressViewStyle = UIProgressViewStyleDefault;
    progress.progress = 0.0;
    [self.view addSubview:progress];
    self.progressView = progress;
    
    //计时器
    //更新时间
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateTimeString)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - UI控件
//显示 提示信息
- (void)showTipWithText:(NSString *)tip activity:(BOOL)activity{
    [self.activity startAnimating];
    self.lbTip.text = tip;
    self.tipView.hidden = NO;
    if (activity) {
        self.activity.hidden = NO;
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
        self.activity.hidden = YES;
    }
}
//隐藏 提示信息
- (void)hideTip {
    self.tipView.hidden = YES;
    [self.activity stopAnimating];
}

//创建按钮
- (UIButton *)createButtonWithTitle:(NSString *)title andCenter:(CGPoint)center {
    
    CGRect rect = CGRectMake(0, 0, 160, 60);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    btn.layer.cornerRadius = 5.0;
    btn.layer.borderWidth = 2.0;
    btn.layer.borderColor = [[UIColor blackColor] CGColor];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.center = center;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchDown];
    return btn;
    
}

//设置按钮是否可点击
- (void)setButton:(UIButton *)button enabled:(BOOL)enabled {
    if (enabled) {
        button.alpha = 1.0;
    } else {
        button.alpha = 0.2;
    }
    button.enabled = enabled;
}

//提示不支持模拟器
- (void)showSimulatorWarning {
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ReplayKit不支持模拟器" message:@"请使用真机运行这个Demo工程" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:actionCancel];
    [alert addAction:actionOK];
    
    [self presentViewController:alert animated:NO completion:nil];
}

//显示弹框提示
- (void)showAlert:(NSString *)title andMessage:(NSString *)message {
    if (!title) {
        title = @"";
    }
    if (!message) {
        message = @"";
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:NO completion:nil];
}

//显示视频预览页面，animation=是否要动画显示
- (void)showVideoPreviewController:(RPPreviewViewController *)previewController withAnimation:(BOOL)animation {
    
    __weak ViewController *weakSelf = self;
    
    //UI需要放到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect rect = [UIScreen mainScreen].bounds;
        
        if (animation) {
            
            rect.origin.x += rect.size.width;
            previewController.view.frame = rect;
            rect.origin.x -= rect.size.width;
            [UIView animateWithDuration:AnimationDuration animations:^(){
                previewController.view.frame = rect;
            } completion:^(BOOL finished){
                
            }];
            
        } else {
            previewController.view.frame = rect;
        }
        
        [weakSelf.view addSubview:previewController.view];
        [weakSelf addChildViewController:previewController];
        
        
    });
    
}

//关闭视频预览页面，animation=是否要动画显示
- (void)hideVideoPreviewController:(RPPreviewViewController *)previewController withAnimation:(BOOL)animation {
    
    //UI需要放到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect rect = previewController.view.frame;
        
        if (animation) {
            
            rect.origin.x += rect.size.width;
            [UIView animateWithDuration:AnimationDuration animations:^(){
                previewController.view.frame = rect;
            } completion:^(BOOL finished){
                //移除页面
                [previewController.view removeFromSuperview];
                [previewController removeFromParentViewController];
            }];
            
        } else {
            //移除页面
            [previewController.view removeFromSuperview];
            [previewController removeFromParentViewController];
        }
    });
}

#pragma mark - 按钮 回调
//按钮事件
- (void)onBtnPressed:(UIButton *)sender {
    
    //点击效果
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    float duration = 0.3;
    [UIView animateWithDuration:duration
                     animations:^{
                         sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }completion:^(BOOL finish){ }];
                     }];
    
    NSString *function = sender.titleLabel.text;
    if ([function isEqualToString:StartRecord]) {
        [self startRecord];
    }
    else if ([function isEqualToString:StopRecord]) {
        [self stopRecord];
    }
}


- (void)startRecord {
    
    //    [self setButton:self.btnStart enabled:NO];
    
    NSLog(@"ReplayKit只支持真机录屏，支持游戏录屏，不支持录avplayer播放的视频");
    NSLog(@"检查机器和版本是否支持ReplayKit录制...");
    if ([[RPScreenRecorder sharedRecorder] isAvailable]) {
        NSLog(@"支持ReplayKit录制");
    } else {
        NSLog(@"!!不支持支持ReplayKit录制!!");
        return;
    }
    
    __weak ViewController *weakSelf = self;
    
    NSLog(@"%@ 录制", StartRecord);
    [self showTipWithText:@"录制初始化" activity:YES];
    
    
    [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError *error){
        NSLog(@"录制开始...");
        [weakSelf hideTip];
        if (error) {
            NSLog(@"错误信息 %@", error);
            [weakSelf showTipWithText:error.description activity:NO];
        } else {
            //其他处理
            [weakSelf setButton:self.btnStop enabled:YES];
            [weakSelf setButton:self.btnStart enabled:NO];
            
            [weakSelf showTipWithText:@"正在录制" activity:NO];
            //更新进度条
            weakSelf.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                                      target:self
                                                                    selector:@selector(changeProgressValue)
                                                                    userInfo:nil
                                                                     repeats:YES];
        }
    }];
    
}

- (void)stopRecord {
    NSLog(@"%@ 录制", StopRecord);
    
    [self setButton:self.btnStart enabled:YES];
    [self setButton:self.btnStop enabled:NO];
    
    __weak ViewController *weakSelf = self;
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
        
        
        if (error) {
            NSLog(@"失败消息:%@", error);
            [weakSelf showTipWithText:error.description activity:NO];
        } else {
            
            [weakSelf showTipWithText:@"录制完成" activity:NO];
            
            //显示录制到的视频的预览页
            NSLog(@"显示预览页面");
            previewViewController.previewControllerDelegate = weakSelf;
            
            //去除计时器
            [weakSelf.progressTimer invalidate];
            weakSelf.progressTimer = nil;
            
            [self showVideoPreviewController:previewViewController withAnimation:YES];
        }
    }];
}

#pragma mark - 视频预览页面 回调
//关闭的回调
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [self hideVideoPreviewController:previewController withAnimation:YES];
}

//选择了某些功能的回调（如分享和保存）
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    
    __weak ViewController *weakSelf = self;
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlert:@"保存成功" andMessage:@"已经保存到系统相册"];
        });
    }
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlert:@"复制成功" andMessage:@"已经复制到粘贴板"];
        });
    }
}

#pragma mark - 计时器 回调

//改变进度条的显示的进度
- (void)changeProgressValue {
    float progress = self.progressView.progress + 0.01;
    [self.progressView setProgress:progress animated:NO];
    if (progress >= 1.0) {
        self.progressView.progress = 0.0;
    }
}

//更新显示的时间
- (void)updateTimeString {
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat: @"HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    self.lbTime.text =  dateString;
}

#pragma mark - 其他
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断对应系统版本是否支持ReplayKit
- (BOOL)isSystemVersionOk {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        return NO;
    } else {
        return YES;
    }
}



@end
