//
//  SecretSettingViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/23.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "SecretSettingViewController.h"
#import "settingCell.h"
#import "settingSwitchCell.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "NumberPwdViewController.h"
#import <LocalAuthentication/LAContext.h>

#import "TouchWindow.h"

@interface SecretSettingViewController ()<UITableViewDelegate,UITableViewDataSource,settingSwitchCellDelegate>
@property (nonatomic,strong) UITableView  *myTableview;
@property (nonatomic,strong) NSMutableArray  *pwdArry;
@property (nonatomic,strong) NSMutableArray  *pwdAnswerArry;

@end

static NSString * const CellID = @"cellID";
static NSString * const CellSwitchID = @"cellSwitchID";

@implementation SecretSettingViewController

-(NSMutableArray *)pwdArry{
    if(_pwdArry==nil){
        _pwdArry=[NSMutableArray array];
        NSArray *arr1 = [NSArray arrayWithObjects:@"设置手势密码",@"修改手势密码", nil];
        NSArray *arr2 = [NSArray arrayWithObjects:@"数字密码",@"TouchID", nil];
        [_pwdArry addObject:arr1];
        [_pwdArry addObject:arr2];
        
        
    }
    return  _pwdArry;
}

-(NSMutableArray *)pwdAnswerArry{
    if(_pwdAnswerArry==nil){
        _pwdAnswerArry=[NSMutableArray array];

        NSString *isopenGesturePwd = [[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]>0?@"已开启":@"未开启";
        NSString *modifyGestureFlag = [isopenGesturePwd  isEqual: @"已开启"]? @"已开启":@"-1";
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:isopenGesturePwd,modifyGestureFlag, nil];
        
        NSMutableArray *arr2 = nil;
        NSString *isopenNumber = [[NSUserDefaults standardUserDefaults] valueForKey:NumberPwdSettingKey]?@"已开启":@"未开启";
        NSString *isopenTouch = [PublicMethod getValue:TouchIDPwdSettingKey]?[PublicMethod getValue:TouchIDPwdSettingKey]:@"OFF";
        arr2 = [NSMutableArray arrayWithObjects:isopenNumber,isopenTouch, nil];

        
        [_pwdAnswerArry addObject:arr1];
        [_pwdAnswerArry addObject:arr2];

        
    }
    return  _pwdAnswerArry;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableview];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetNumberPwdSave) name:SetNumberPwdSaveSuccess object:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)SetNumberPwdSave{
    self.pwdAnswerArry[1][0] = @"已开启";
    [self.myTableview reloadData];
}

#pragma mark - uitableview  delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 1 && indexPath.row == 1) {
        settingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSwitchID];
        BOOL isOn = [self.pwdAnswerArry[indexPath.section][indexPath.row]  isEqual: @"ON"]?YES:NO;
        [cell initTitle:self.pwdArry[indexPath.section][indexPath.row] isSwitchOn:isOn];
        cell.delegate = self;
        LAContext *context = [LAContext new];
        if(![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
        {
            [cell setHide];
        }

        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 0){
        if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]>0) {
            return [UITableViewCell new];
        }
        
    }
    
    settingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    [cell initTitle:self.pwdArry[indexPath.section][indexPath.row] withDesc:self.pwdAnswerArry[indexPath.section][indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]>0) {
            return 0;
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *modifyFlag = self.pwdAnswerArry[indexPath.section][indexPath.row];
        if ([modifyFlag isEqualToString:@"-1"]) {
            return 0;
            
        }
    }else if(indexPath.section == 1 && indexPath.row == 1){
        LAContext *context = [LAContext new];
        if(![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] )
        {
            
            NSLog(@"Yeah,NO  Support touch ID");
            return 0;
        }else if([[UIDevice currentDevice].systemVersion floatValue]<8.0){
            return 0;
        }
    }
    
    return 40;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
                //设置手势密码
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                gestureVc.type = GestureViewControllerTypeSetting;
                [self.navigationController pushViewController:gestureVc animated:YES];
            
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                //数字密码
                NumberPwdViewController *numberVC = [[NumberPwdViewController alloc] init];
                numberVC.logType = LogintypeInit;
                numberVC.pwdCount = 4;
                [self.navigationController pushViewController:numberVC animated:YES];
                
            }else if (indexPath.row == 1) {
                //touchID
                if (![[[NSUserDefaults standardUserDefaults] valueForKey:NumberPwdSettingKey] length]) {
                    showAlert(@"开启TouchID前，必须先设置数字密码");
                    
                    settingSwitchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell setSwitchStatus:NO];
                }
                
            }
            break;
       
            
        default:
            break;
    }
    
}


#pragma  mark - cellSwitch delegate
-(void)settingSwitchCellDidValueChanged:(BOOL)isOn{
    if (isOn) {
        [PublicMethod savekeyValue:@"ON" withKey:TouchIDPwdSettingKey];
    }else{
        [PublicMethod savekeyValue:@"OFF" withKey:TouchIDPwdSettingKey];
    }
}


@end
