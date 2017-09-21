//
//  NewFearureViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/9/12.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "NewFearureViewController.h"
#import "EAIntroView.h"
#import "AppDelegate.h"

#define newFeatureCount 4

@interface NewFearureViewController ()<EAIntroDelegate,UIScrollViewDelegate>
@property (nonatomic,weak) UIPageControl *pageControl;
@end

@implementation NewFearureViewController{
    UIScrollView *scroll;
}

-(NSArray *)imgsArry{
    NSArray *arry = [NSArray arrayWithObjects:@"",@"",@"",@"", nil];
    return arry;
}

-(NSArray *)titleArry{
    NSArray *arry = [NSArray arrayWithObjects:@"今天天气不错哦",@"用了你会爱上它",@"不信你打我",@"开启新的APP之旅吧", nil];
    return arry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.创建scrollview
    scroll=[[UIScrollView alloc] init];
    
    //2.设置scroll的大小及其他属性
    scroll.frame=self.view.bounds;
    scroll.bounces=NO;      //弹簧设置NO
    scroll.pagingEnabled=YES;
    [scroll setShowsHorizontalScrollIndicator:NO];      //去除底部滚动条
    scroll.delegate=self;
    
    CGFloat scrollW=self.view.width;
    CGFloat scrollH=self.view.height;
    
    scroll.contentSize=CGSizeMake(newFeatureCount*scrollW, 0);
    [self.view addSubview:scroll];
    
    //3.添加4张图片
    for (int i=0; i<newFeatureCount; i++) {
        NSString *str=[NSString stringWithFormat:@"new_feature_%d",i+1];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        image.backgroundColor = KColorWithRGB(43, 81, 110);
        image.width=scrollW;
        image.height=scrollH;
        image.x=i*scrollW;
        
        //如果是最后一张，添加说明及跳转连接
        if (i==newFeatureCount-1) {
            [self setLastImage:image];
        }
        
        [scroll addSubview:image];
        
        //添加文字说明（可选）
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:20];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = self.titleArry[i];
        lbl.frame = CGRectMake(0, 0, kScreenW-20, 100);
        lbl.center = CGPointMake(i*scrollW+scrollW/2, 160);
        [scroll addSubview:lbl];
        
    }
    
    
    //4.添加分页
    UIPageControl *page=[[UIPageControl alloc] init];
    page.numberOfPages=newFeatureCount;
    page.centerX=scrollW*0.5;
    page.centerY=scrollH-50;
    [page setPageIndicatorTintColor:KColorWithDecimal(0.81, 0.9, 0.7)];
    [page setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    
    self.pageControl=page;
    [self.view addSubview: page];
}

-(void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
    if (wasSkipped) {
        NSLog(@"skip");
    }else{
        NSLog(@"no skip");
    }
    
    CATransition * animation = [CATransition animation];
    
    animation.duration = 0.3;    //  时间
    
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    //animation.type = @"rippleEffect";
    
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    //animation.type = kCATransitionFade;
    //PS：type 更多效果请 搜索： CATransition
    
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
    animation.subtype = kCATransitionFromRight;
    
    //[self.view.window.layer addAnimation:animation forKey:nil];                   //  添加动作
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.mainVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:app.mainVC animated:YES completion:nil];

}


-(void)shareClick:(UIButton *)btn{
    btn.selected=!btn.isSelected;
    
}

-(void)setLastImage:(UIImageView *)image{
    
    image.userInteractionEnabled=YES;
    
    UIButton *btnTurn=[[UIButton alloc] init];
    [btnTurn setTitle:@"开始使用" forState:UIControlStateNormal];
    [btnTurn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTurn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [btnTurn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    btnTurn.titleLabel.font = [UIFont systemFontOfSize:25];
    btnTurn.layer.cornerRadius = 5;
    btnTurn.layer.masksToBounds = YES;
    btnTurn.layer.borderWidth =1;
    btnTurn.layer.borderColor = [UIColor redColor].CGColor;
    [btnTurn setBackgroundColor:KColorWithRGB(151, 55, 161)];
    btnTurn.alpha = 0.5;
    
    btnTurn.width=150;
    btnTurn.height=40;
    btnTurn.centerX=image.width*0.5;
    btnTurn.centerY=image.height*0.75;
    
    [btnTurn addTarget:self action:@selector(turnClick) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:btnTurn];
}

-(void)turnClick{
    
    [UIView animateWithDuration:0.5 animations:^{
        scroll.alpha = 0;
    } completion:^(BOOL finished) {
        //跳转新的主页
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.mainVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:app.mainVC animated:YES completion:nil];
        

    }];

   
 }


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //YJLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    double scrollX=scrollView.contentOffset.x/scrollView.width;
    
    //这里x+0.5再四舍五入更准确
    self.pageControl.currentPage=(int)(scrollX+0.5);
    
}


@end
