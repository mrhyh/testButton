//
//  AboutViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/9/20.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关 于";
    
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 0, kScreenW-30, 200);
    lbl.center = self.view.center;
    [self.view addSubview:lbl];
    
    lbl.textColor = [UIColor lightGrayColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"有问题可以邮箱：\n 994825763@qq.com\n\n谢谢！";
    lbl.numberOfLines = 0;
    
    
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
