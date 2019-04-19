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
#import "TestView.h"
#import "CNotificationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "testViewController.h"
#import "zlib.h"
//#import "NSNull+XY.h"

static NSString *StartRecord = @"开始";
static NSString *StopRecord = @"结束";

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#define AnimationDuration (0.3)


UIWindow *_window;
// 窗口的高度
#define XWWindowHeight 20
// 动画的执行时间
#define XWDuration 0.5
// 窗口的停留时间
#define XWDelay 1.5
// 字体大小
#define XWFont [UIFont systemFontOfSize:12]

@interface ViewController () <RPBroadcastActivityViewControllerDelegate,RPPreviewViewControllerDelegate, NSStreamDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong)UIButton *btnStart;
@property (nonatomic, strong)UIButton *btnStop;
@property (nonatomic, strong)UIButton *secondBarButton;

@property (nonatomic, strong)NSTimer *progressTimer;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, strong)UIView *tipView;
@property (nonatomic, strong)UILabel *lbTip;
@property (nonatomic, strong)UILabel *lbTime;
@property (nonatomic, strong)TestView *testView;
@property (nonatomic, assign)NSInteger testInteger;

//test Switch效果

@property (nonatomic, strong) UIView *switchBGView;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) UIView *oneView;

@property (nonatomic, strong) UIButton *testButton;
@property (strong, nonatomic) IBOutlet UIButton *testButton11;

@property (strong, nonatomic) CLLocationManager *locationManager; //定位服务管理类
@property (strong, nonatomic) CLGeocoder *geocoder; //初始化地理编码器

@end

@implementation ViewController





- (UIView *)createViewWithColor:(UIColor *)color rect:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    return view;
}

- (void)rotateView:(UIImageView *)view
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:-M_PI*0.2];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*0.2];
    rotationAnimation.duration = 4;
    //rotationAnimation.repeatCount = 1;
    //rotationAnimation.autoreverses = YES;
    //[view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    CABasicAnimation *rotationAnimation2;
    rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.fromValue = [NSNumber numberWithFloat:M_PI*0.2];
    rotationAnimation2.toValue = [NSNumber numberWithFloat:M_PI*0.4];
    rotationAnimation2.duration = 1;
    //rotationAnimation2.repeatCount = 1;
    //rotationAnimation2.autoreverses = YES;
    //[view.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation"];
    
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:rotationAnimation, rotationAnimation2, nil];
    animGroup.duration = 8;
    //animGroup.repeatCount = 5;
    //animGroup.autoreverses = YES;

    [view.layer addAnimation:animGroup forKey:nil];
}

//3.实现代理方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
    //    NSStreamEventOpenCompleted = 1UL << 0,     // 输入流打开完成
    //    NSStreamEventHasBytesAvailable = 1UL << 1,  //获取到字节数
    //    NSStreamEventHasSpaceAvailable = 1UL << 2, //有可用的空间,不知道怎么翻译..
    //    NSStreamEventErrorOccurred = 1UL << 3,     // 发生错误
    //    NSStreamEventEndEncountered = 1UL << 4     //输入完成
    
    NSInputStream *inputStream = (NSInputStream *)aStream;
    
    switch (eventCode) {
            
            //开始输入
        case NSStreamEventHasBytesAvailable:
            
        {
            
            //定义一个数组
            uint8_t streamData[1000000];
            
            //返回输入长度
            NSUInteger length = [inputStream read:streamData maxLength:1000000];
            
            if (length) {
                
                //转换为data
                NSData *data = [NSData dataWithBytes:streamData length:length];
                
                NSLog(@"读取的数据%lu",(unsigned long)data.length);
                
            }else{
                
                
                NSLog(@"没有数据");
            }
        }
            break;
            
            //异常处理
        case NSStreamEventErrorOccurred:
            
            NSLog(@"进行异常处理");
            
            break;
            
            //输入完成
        case NSStreamEventEndEncountered:
        {
            //输入流关闭处理
            [inputStream close];
            //从运行循环中移除
            [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            //置为空
            inputStream = nil;
            
        }
            break;
        default:
            break;
    }
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _secondBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondBarButton.frame = CGRectMake(50, 150, 50, 50);
    //[_secondBarButton setImage:[UIImage imageNamed:@"icon_revert_co2"] forState:UIControlStateNormal];
    //_secondBarButton.showsTouchWhenHighlighted = YES;
    [_secondBarButton setImage:[[UIImage imageNamed:@"icon_revert_co2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal ];
    [_secondBarButton setImage:[[UIImage imageNamed:@"icon_revert_co2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted ];
    //[_secondBarButton setImage:[[UIImage imageNamed:@"icon_gedan_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    //[_secondBarButton setImage:[[UIImage imageNamed:@"icon_gedan_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    //_secondBarButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:_secondBarButton];
    
    return;
    
    
    NSDictionary *tempDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                              @"male", @"21",
                              @"20", @"age",
                              @"Tom", @"name",
                              @"run",@"hobby", nil ];
    
    NSLog(@"====%@",tempDic[@"male"]);
    
    NSArray *testArray = @[@"1",@"2",@"",[NSNull null],@"3",@[],@1,@{}];
    for (int i=0; i<testArray.count; i++) {
        id a = testArray[i];
        NSLog(@"testArray i%d=%@",i,a);
    }
    NSLog(@"结束");
    
    return;
    
    NSDictionary *headers = @{ @"content-type": @"text/html",
                               @"cache-control": @"no-cache" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dol.tianya.cn/s?z=tianya&c=10030221&op=1&_v=30&u=app-funinfo"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    // 设置头部参数
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setAllHTTPHeaderFields:headers];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                        
                                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
    
    
    
    NSDictionary *dic = @{@"key":@"1",@"key2":@"",@"key3":@""};
    NSString *key = dic[@"key"];
    NSString *key2 = dic[@"key2"];
    NSString *key4 = dic[@"key4"];
    
    NSMutableDictionary *testDic = nil;
    [testDic writeToFile:nil atomically:YES];

    NSLog(@"=====%@",testDic);
    return ;
    
    
    int i = 0;
    for (i=0; i<12; i++) {
//        NSLog(@"%d==,%ld",i,i/2 + i%2);
//        NSLog(@"%di/==,%ld",i,i/2);
        NSLog(@"%di%==,%ld",i,i%2);
    }
    
    
    [self initializeLocationService];
    
    
    //创建NSInputStream对象 , 配置路径 , 加入运行循环等..
    NSString *path = [[NSBundle mainBundle]pathForResource:@"xxxx.pdf" ofType:nil];
    
    //[NSInputStream inputStreamWithURL:<#(nonnull NSURL *)#>]
    //[NSInputStream inputStreamWithData:<#(nonnull NSData *)#>]
    
    //根据路径创建输入流 , 创建输入流的方法有很多,如上
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    
    //设置代理
    inputStream.delegate = self;
    
    //加入运行循环
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    //打开输入流
    [inputStream open];
    
    
    
    return ;
    
    dispatch_queue_t queue = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 100000000; i++) {

        dispatch_async(queue, ^{

            @autoreleasepool {
                NSString *str = @"Abc";
                str = [str lowercaseString];
                str = [str stringByAppendingString:@"xyz"];
    
                NSLog(@"%@", str);
            }
            
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ });
    }
    
    
    
    //[self showMessage:@"测试提醒" image:[UIImage imageNamed:@"1.jpeg"]];
    
   
//    for (int i = 0; i < 1000000000; ++i) {
//        @autoreleasepool {
//            NSString *str = @"Abc";
//            str = [str lowercaseString];
//            str = [str stringByAppendingString:@"xyz"];
//            
//            NSLog(@"%@", str);
//        }
//    }
    
    

    [CNotificationManager showMessage:@"欢迎回来，我最亲爱的主人" withOptions:@{CN_TEXT_COLOR_KEY:[UIColor redColor],CN_BACKGROUND_COLOR_KEY:[UIColor blackColor]}];
    
    [CNotificationManager showMessage:@"11欢迎回来，我最亲爱的主人" withOptions:@{CN_TEXT_COLOR_KEY:[UIColor whiteColor],CN_BACKGROUND_COLOR_KEY:[UIColor blueColor]} completeBlock:^{
        
        NSLog(@"notification display end");
        
    }];
    

    
    self.liveVideoProgressView_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 50, 100, 50)];
    self.liveVideoProgressView_timeLabel.textAlignment = NSTextAlignmentCenter;
    self.liveVideoProgressView_timeLabel.textColor = [UIColor redColor];
    self.liveVideoProgressView_timeLabel.text = @"11:11";
    self.liveVideoProgressView_timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:self.liveVideoProgressView_timeLabel];
    
    UIImageView *image1View = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    image1View.image = [UIImage imageNamed:@"3.jpeg"];
    [self.view addSubview:image1View];
    
    [self rotateView:image1View];
    
    //[self.playStatusImageView.layer removeAllAnimations];//停止动画
//    
//    UIView *bgBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,200 , 200)];
//    [self.view addSubview:bgBGView];
//    bgBGView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0];
//    
//    UIView *bgBGBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100 , 100)];
//    [bgBGView addSubview:bgBGBGView];
//    bgBGBGView.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.0];
    
    [self addobserver];
    
    
    _testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, 50, 50)];
    //_testButton.backgroundColor = [UIColor blueColor];
    [_testButton setImage:[UIImage imageNamed:@"1.jpeg"] forState:UIControlStateNormal];
    [_testButton setImage:[UIImage imageNamed:@"4.jpeg"] forState:UIControlStateSelected];
    
    _testButton.adjustsImageWhenHighlighted = NO;
   _testButton.adjustsImageWhenDisabled = NO;
    
    [_testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view33 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view33.backgroundColor = [UIColor redColor];
    [_testButton addSubview:view33];
    
    [self.view addSubview:_testButton];
    
    _testView = [[TestView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _testView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_testView];
    
    
    return;
    
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
    
}

-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        // chadeltu 加了(Bytef *)
        strm.next_out = (Bytef *)[decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

- (void)testButtonAction {
    _testButton.selected = !_testButton.selected;
    _testView.frame = CGRectMake(200, 0, 400, 100);
}




- (void)addobserver{
    // Do any additional setup after loading the view from its nib.
    //----- SETUP DEVICE ORIENTATION CHANGE NOTIFICATION -----
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}
- (void)removeobserver{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}
- (void)orientationChanged:(NSNotification *)note  {      UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
            [self  rotation_icon:0.0];
            break;
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            [self  rotation_icon:180.0];
            break;
        case UIDeviceOrientationLandscapeLeft :      // Device oriented horizontally, home button on the right
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            
            [self  rotation_icon:90.0*3];
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            
            [self  rotation_icon:90.0];
            break;
        default:
            break;
    }
}

-(void)rotation_icon:(float)n {
    if (0.0 == n || 180.0 == n) {
        
        _testView.frame = CGRectMake(0, 0, 200, 100);
    }else {
        _testView.frame = CGRectMake(400, 0, 500, 100);
    }
}



- (IBAction)testButton11Action:(UIButton *)sender {
    // hack, turn to landscape code.
    self.testInteger += 20;
    self.liveVideoProgressView_timeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.testInteger];
    
    testViewController *vc = [[testViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

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


/**
 *  显示信息
 *
 *  @param msg   文字内容
 *  @param image 图片对象
 */
- (void)showMessage:(NSString *)msg image:(UIImage *)image
{
    
    if (_window) return;
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置按钮文字大小
    btn.titleLabel.font = XWFont;
    
    // 切掉文字左边的 10
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 设置数据
    [btn setTitle:msg forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    
    // 创建窗口
    _window = [[UIWindow alloc] init];
    // 窗口背景
    _window.backgroundColor = [UIColor blackColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.frame = CGRectMake(0, -XWWindowHeight, [UIScreen mainScreen].bounds.size.width, XWWindowHeight);
    btn.frame = _window.bounds;
    [_window addSubview:btn];
    _window.hidden = NO;
    
    // 状态栏 也是一个window
    // UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    
    // 动画
    [UIView animateWithDuration:XWDuration animations:^{
        CGRect frame = _window.frame;
        frame.origin.y = 0;
        _window.frame = frame;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:XWDuration delay:XWDelay options:kNilOptions animations:^{
            CGRect frame = _window.frame;
            frame.origin.y = -XWWindowHeight;
            _window.frame = frame;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }];
}

//开始定位

-(void)startLocation{
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = 10.0f;
    
    [self.locationManager startUpdatingLocation];
    
}



//定位代理经纬度回调

-(void)locationManager:(CLLocationManager *)managerdidUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray*placemarks, NSError *error){
        
        for(CLPlacemark * placemark in placemarks) {
            

            NSDictionary *test = [placemark addressDictionary];
            
            /*Country(国家) State(城市) SubLocality(区)*/
            
            NSLog(@"%@", [test objectForKey:@"State"]);
            
        }
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog([@"LocationManager didFailWithError" stringByAppendingString:[error localizedDescription]]);
}

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    // NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    // [manager stopUpdatingLocation];不用的时候关闭更新位置服务
}

- (void)dealloc {
    NSLog(@"dealloc.......");
}

@end
