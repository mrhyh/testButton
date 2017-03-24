//
//  ViewController.m
//  testButton
//
//  Created by hyh on 2017/3/13.
//  Copyright © 2017年 hyh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *tempList = [NSNull null];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:tempList.count];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0, 80, 40)];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    imageView.backgroundColor = [UIColor yellowColor];
    
    imageView.contentMode = UIViewContentModeTopRight;
    imageView.layer.borderWidth = 3.0;
    imageView.layer.borderColor = [UIColor yellowColor].CGColor;
    [imageView setImage:[UIImage imageNamed:@"3.jpeg"]];
    [imageView sizeToFit];
    //[imageView sizeThatFits:CGSizeMake(80, 40)];
    
    
    UITapGestureRecognizer *generalizeViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generalizeViewAction)];
    generalizeViewTapGesture.numberOfTapsRequired = 1;
    generalizeViewTapGesture.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:generalizeViewTapGesture];
    
    
    //测试异常捕获
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"1"];
    [array addObject:@"2"];
    
    NSLog(@"%@",array[9]);
}

- (void) generalizeViewAction {
    NSLog(@"11111111");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
