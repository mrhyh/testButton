//
//  FeedbackViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/31.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()  <UITextViewDelegate>

@property (nonatomic,strong) UITextView  *txtView;

@end

#define maxContentCount 20

@implementation FeedbackViewController{
    UILabel *lblEmptyTip;
    UILabel *lblLeftCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"反馈意见";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initViews];
}


-(void)initViews{
    UIScrollView *bgScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    bgScroll.scrollEnabled = YES;
    bgScroll.alwaysBounceVertical = YES;
    [self.view addSubview:bgScroll];
    
    _txtView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth-30, 150)];
    [bgScroll addSubview:_txtView];
    _txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _txtView.layer.borderWidth = 1;
    _txtView.layer.cornerRadius = 5;
    _txtView.font = [UIFont systemFontOfSize:15];
    _txtView.backgroundColor = [UIColor whiteColor];
    _txtView.textColor = [UIColor lightGrayColor];
    _txtView.delegate = self;
    
    
    if (lblEmptyTip == nil) {
        lblEmptyTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _txtView.width-10, 20)];
        lblEmptyTip.textColor = [UIColor lightGrayColor];
        lblEmptyTip.text = @"请输入反馈内容";
        lblEmptyTip.font = [UIFont systemFontOfSize:15];
        [_txtView addSubview:lblEmptyTip];
    }
    
    
    if (lblLeftCount == nil) {
        lblLeftCount = [[UILabel alloc] initWithFrame:CGRectMake(_txtView.width-50, CGRectGetMaxY(_txtView.frame)-30, 50, 20)];
        lblLeftCount.textColor = [UIColor lightGrayColor];
        [self setLeftCount:maxContentCount];
        lblLeftCount.textAlignment = NSTextAlignmentCenter;
        lblLeftCount.font = [UIFont systemFontOfSize:12];
        [_txtView addSubview:lblLeftCount];
    }
    
    
    //提交按钮
    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_txtView.frame)+50, KScreenWidth-30, 40)];
    [bgScroll addSubview:btnConfirm];
    [btnConfirm addTarget:self action:@selector(btnConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnConfirm setTitle:@"提  交" forState:UIControlStateNormal];
    [btnConfirm setBackgroundColor:KColorWithRGB(244, 158, 17)];
    btnConfirm.layer.cornerRadius = 5;
    btnConfirm.layer.masksToBounds = YES;
}


-(void)setLeftCount:(NSInteger)leftCount{
   lblLeftCount.text = [NSString stringWithFormat:@"%ld",(long)leftCount];
    
}


-(void)btnConfirmClick{
    NSLog(@"ti jiao");
    
}


#pragma mark - uitextview delegate
-(void)textViewDidChange:(UITextView *)textView{
    NSString *txt = [_txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    lblEmptyTip.hidden = txt.length>0;
    
    if (txt.length>maxContentCount) {
        _txtView.text = [txt substringToIndex:maxContentCount];
        
    }
    [self setLeftCount:(maxContentCount-txt.length)];
    
    
}



@end
