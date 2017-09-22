//
//  SeetingViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/15.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "SeetingViewController.h"
#import "settingCell.h"
#import "settingSwitchCell.h"
#import "SecretSettingViewController.h"
#import "FeedbackViewController.h"
#import "PCCircleViewConst.h"
#import "AboutViewController.h"

#import "XMShareView.h"
#import "CommonMarco.h"

@interface SeetingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  *myTableview;
@property (nonatomic,strong) NSArray  *titlesArry;
@property (nonatomic,strong) NSArray  *titleSectionArry;
@property (nonatomic,strong) NSMutableArray  *titleDescArry;

@property (nonatomic, strong) XMShareView *shareView;

@end

static NSString * const CellID = @"cellID";
static NSString * const CellSwitchID = @"cellSwitchID";



@implementation SeetingViewController


/**
 *  基本信息：相册数量、视频数量
 *  安全设置：手势密码、数字密码、TouchID
 *  其他设置：意见反馈、APP评论、关于
 *  闯入警报：闯入警报
 *
 *  @return <#return value description#>
 */
-(NSArray *)titlesArry{
    if(_titlesArry==nil){
        _titlesArry=[NSArray array];
        _titlesArry = @[@[@"相册数量",@"视频数量",@"分享应用"],
                        @[@"安全设置",@"闯入警报"],
                        @[@"意见反馈",@"到App Store评分",@"关于"]
                        ];
    }
    return  _titlesArry;
}

-(NSArray *)titleSectionArry{
    if(_titleSectionArry==nil){
        _titleSectionArry=[NSArray array];
        _titleSectionArry = @[@"基本信息",@"安全设置",@"其他设置"];
    }
    return  _titleSectionArry;
}
-(NSMutableArray *)titleDescArry{
    if(_titleDescArry==nil){
        _titleDescArry=[NSMutableArray array];
        
        //照片数量
        NSString *photoNum = @"";
        NSString *filePath = [[PublicMethod getDocumentMainPath] stringByAppendingPathComponent:FileListName];
        if ([PublicMethod isFileExist:filePath]) {
            NSMutableArray *arry = [NSMutableArray arrayWithContentsOfFile:filePath];
            photoNum = [NSString stringWithFormat:@"%lu",(unsigned long)arry.count];
        }
        
        //视频
        NSString *path = [PublicMethod getDocumentVideoPath];
        NSFileManager *file = [NSFileManager defaultManager];
        NSArray *folderarry = [file subpathsOfDirectoryAtPath:path error:nil];
        NSString *videoNum = [NSString stringWithFormat:@"%lu",(unsigned long)folderarry.count];
        
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:photoNum,videoNum,@"", nil];
        NSString *isopenGesturePwd = [[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]>0?@"已开启":@"未开启";
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:isopenGesturePwd,@"未开启", nil];
        NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        [_titleDescArry addObject:arr1];
        [_titleDescArry addObject:arr2];
        [_titleDescArry addObject:arr3];
      
        
        
    
    
    }
    return  _titleDescArry;
}

-(UITableView *)myTableview{
    if(_myTableview==nil){
        _myTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        
        [_myTableview registerClass:[settingCell class] forCellReuseIdentifier:CellID];
        [_myTableview registerClass:[settingSwitchCell class] forCellReuseIdentifier:CellSwitchID];
        _myTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return  _myTableview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = KColorWithRGB(249, 249, 249);
    [self.view addSubview:self.myTableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSaveGesture) name:SetGestureSaveSuccess object:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveSaveGesture{
    self.titleDescArry[1][0] = @"已开启";
    [self.myTableview reloadData];
}

#pragma mark - uitableview  delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.titleSectionArry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry = self.titlesArry[section];
    return arry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arryTitle = self.titlesArry[indexPath.section];
    NSArray *arryDesc = self.titleDescArry[indexPath.section];
    settingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    [cell initTitle:arryTitle[indexPath.row] withDesc:arryDesc[indexPath.row]];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    
    UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth-10, bgView.height)];
    head.text = self.titleSectionArry[section];
    bgView.backgroundColor = KColorWithRGB(249, 249, 249);
    head.textColor = blueColor;
    head.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:head];
    return bgView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 2) {
                //分享应用
                if(!self.shareView){
                    
                    self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
                    
                    self.shareView.alpha = 0.0;
                    
                    self.shareView.shareTitle = NSLocalizedString(@"分享标题", nil);
                    
                    self.shareView.shareText = NSLocalizedString(@"分享内容", nil);
                    
                    self.shareView.shareUrl = @"http://www.cnblogs.com/yajunLi/";
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        self.shareView.alpha = 1.0;
                    }];
                    
                    
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        self.shareView.alpha = 1.0;
                    }];
                    
                }
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                //安全设置
                SecretSettingViewController *secret = [[SecretSettingViewController alloc] init];
                secret.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:secret animated:YES];
                
            }else if (indexPath.row == 1) {
                //闯入警报
                
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                //反馈意见
                FeedbackViewController *feed = [[FeedbackViewController alloc] init];
                feed.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feed animated:YES];
                
            }else if (indexPath.row == 1) {
                //appstore评分
                NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/shang-hai-shi-jue-xue-sheng/id1123953138?mt=8"];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }else if (indexPath.row == 2) {
                //关于
                AboutViewController *about = [[AboutViewController alloc] init];
                about.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:about animated:YES];
                
                
            }
            

            break;
            
        default:
            break;
    }
    
}


#pragma mark - 代理回调
/**
 *  处理来自微信的请求
 *
 *  @param resp 响应体。根据 errCode 作出对应处理。
 */
- (void)onResp:(BaseResp *)resp
{
    NSString *message;
    if(resp.errCode == 0) {
        message = @"分享成功";
    }else{
        message = @"分享失败";
    }
    showAlert(message);
}



@end


