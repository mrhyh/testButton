//
//  NumberPwdViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/23.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "NumberPwdViewController.h"
#import "AppDelegate.h"

@interface NumberPwdViewController ()

@end

@implementation NumberPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NumberPwdView *number = [[NumberPwdView alloc] initWithFrame:self.view.bounds withPwdLength:self.pwdCount withLoginType:self.logType];
    [self.view addSubview:number];
    __weak typeof (number)weakself = number;
    number.textInputCompleteBlock = ^(NSString *result){
        [weakself hide];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.logType == LogintypeInit) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SetNumberPwdSaveSuccess object:nil];
        }else if(self.logType == LogintypeLogin){
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            delegate.window.rootViewController = delegate.mainVC;

        }
        
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
