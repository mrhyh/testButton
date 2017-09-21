//
//  MainTabbarVC.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/15.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "MainTabbarVC.h"
#import "HomeViewController.h"
#import "SeetingViewController.h"
#import "VideoViewController.h"


@interface MainTabbarVC ()

@end

@implementation MainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    home.title = @"相册";
    home.navigationItem.title = @"相册";
    home.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    VideoViewController *pic = [[VideoViewController alloc] init];
    UINavigationController *picNav = [[UINavigationController alloc] initWithRootViewController:pic];
    pic.title = @"视频";
    pic.navigationItem.title = @"视频";
    pic.tabBarItem.image = [[UIImage imageNamed:@"picture"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    pic.tabBarItem.selectedImage = [[UIImage imageNamed:@"picture_selected"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    SeetingViewController *setting = [[SeetingViewController alloc] init];
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:setting];
    setting.tabBarItem.title = @"设置";
    setting.navigationItem.title = @"设置";
    setting.tabBarItem.image = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    setting.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_selected"] imageWithRenderingMode:UIImageRenderingModeAutomatic];


    
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    [arry addObject:homeNav];
    [arry addObject:picNav];
    [arry addObject:setNav];
    [self setViewControllers:arry animated:YES];
    
   
    //－－－－－－－－－－－ceshi－－－－－－－－－－－
//    UIButton *btn = [[UIButton alloc] init];
//    btn.layer.cornerRadius = 30;
//    btn.layer.masksToBounds = YES;
//    btn.backgroundColor = [UIColor redColor];
//    btn.frame = CGRectMake(0, 0, 60, 60);
//    CGPoint center = self.tabBar.center;
//    center.y=center.y-15;
//    btn.center = center;
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(hhhCLick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)hhhCLick{
    
    SeetingViewController *setting111 = [[SeetingViewController alloc] init];
    UINavigationController *setNav111 = [[UINavigationController alloc] initWithRootViewController:setting111];
    setting111.tabBarItem.title = @"";
    setting111.navigationItem.title = @"设置1";
    
    [self presentViewController:setNav111 animated:YES completion:nil];
    
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
