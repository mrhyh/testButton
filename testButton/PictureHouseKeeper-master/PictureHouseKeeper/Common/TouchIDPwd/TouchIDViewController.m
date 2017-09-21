//
//  TouchIDViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/9/14.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "TouchIDViewController.h"
#import "TouchWindow.h"
#import "NumberPwdView.h"


@interface TouchIDViewController ()

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TouchWindow *touch = [[TouchWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [touch show];
    touch.myBlock = ^{
        //数字密码
        NumberPwdView *number = [[NumberPwdView alloc] initWithFrame:[UIScreen mainScreen].bounds withPwdLength:4 withLoginType:LogintypeLogin];
        [self.view addSubview:number];
        __weak typeof (number)weakself = number;
        number.textInputCompleteBlock = ^(NSString *result){
            [weakself hide];
            
        };
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
