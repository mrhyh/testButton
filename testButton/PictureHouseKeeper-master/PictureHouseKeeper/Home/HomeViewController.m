//
//  HomeViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/15.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "HomeViewController.h"
#import "FolderCell.h"
#import "HomeDetailViewController.h"
#import "GestureViewController.h"


@interface HomeViewController ()<UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FolderCellDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UICollectionView  *mycollectionView;
@property (nonatomic,strong) NSMutableArray  *picArry;

@property (nonatomic,strong) NSMutableArray  *fileList;

@end


#define KMarginLeftRight 25
#define KMarginCenter 20

@implementation HomeViewController{
    UIButton *btnAdd;
    UILabel *lblDesc;
    NSString *pushPage;
    NSString *filePath;
    
    NSInteger deleteFolderIndex;
    
}

static NSString * const headerID = @"hederID";
static NSString * const cellID = @"cellID";




-(NSMutableArray *)fileList{
    if(_fileList==nil){
        _fileList=[NSMutableArray array];
        if ([PublicMethod isFileExist:filePath]) {
            _fileList = [NSMutableArray arrayWithContentsOfFile:filePath];
        }else{
            //新建
            [_fileList writeToFile:filePath atomically:YES];
        }
        
    }
    return  _fileList;
}


-(UICollectionView *)mycollectionView{
    if(_mycollectionView==nil){
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mycollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowlayout];
        _mycollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mycollectionView];
        
    }
    
    return  _mycollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    filePath = [[PublicMethod getDocumentMainPath] stringByAppendingPathComponent:FileListName];
    
    [self initCollectionView];
    
    
    //每次打开期间只显示一次
    if (![[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
//        如果数字密码设置了，就不提示
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:NumberPwdSettingKey] length]>0){
            return;
        }
        
        if ([CommonGlobal shareinstance].isShowtoSettingGesture == YES) {
            return;
        }
        [CommonGlobal shareinstance].isShowtoSettingGesture = YES;
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alerView.tag = 1002;
        [alerView show];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([pushPage isEqual:@""]) {
        return;
    }
    NSString *path = [[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:pushPage];
    NSFileManager *file = [NSFileManager defaultManager];
    NSArray *folderarry = [file subpathsOfDirectoryAtPath:path error:nil];
    if (folderarry && folderarry.count>0) {
        for (int i =0; i<self.fileList.count; i++) {
            NSMutableDictionary *dict = self.fileList[i];
            if ([dict[folderName] isEqual:pushPage]) {
                NSString *imageName = folderarry[0];
                dict[folderImage] = imageName;
                self.fileList[i] = dict;
                [self.fileList writeToFile:filePath atomically:YES];
                [self.mycollectionView reloadData];
                break;
            }
        }
        
    }
    

    
}


-(void)initCollectionView{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(beginAddNewFolder)];

    
    [self.mycollectionView registerClass:[FolderCell class] forCellWithReuseIdentifier:cellID];
    self.mycollectionView.delegate = self;
    self.mycollectionView.dataSource = self;
    
    if (self.fileList.count<=0) {
        [self showEmptyAddBtn];
        
    }
    
    
    

}



-(void)showEmptyAddBtn{
    if (btnAdd == nil) {
        btnAdd = [[UIButton alloc] init];
        [btnAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KScreenWidth-150)/2, (KScreenHeight-150-64)/2, 150, 180);
        [btnAdd addTarget:self action:@selector(beginAddNewFolder) forControlEvents:UIControlEventTouchUpInside];

        lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 150, 30)];
        lblDesc.text = @"添加一个吧";
        lblDesc.textAlignment = NSTextAlignmentCenter;
        lblDesc.textColor = [UIColor lightGrayColor];
        [btnAdd addSubview:lblDesc];
        
        [self.view addSubview:btnAdd];
    }
    
}


-(void)beginAddNewFolder{
    NSLog(@"add");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 1001;
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.clearButtonMode = UITextFieldViewModeAlways;
    txtName.placeholder = @"请输入名称";
    [alert show];
    
}


#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            
            UITextField *txt = [alertView textFieldAtIndex:0];
            NSString *name = [txt.text trim];
            if (name.length == 0) {
                [PublicMethod showAlert:@"名称不能为空"];
                
            }else{
                NSString *msg = @"";
                for (NSMutableDictionary *obj in self.fileList) {
                    if ([((NSString *)obj[folderName]) isEqual:name]) {
                        msg = @"该名称已存在";
                        break;
                    }
                }
                if (![msg  isEqual: @""]) {
                    [PublicMethod showAlert:msg];
                    return;
                }
                
                
                //删除
                if (btnAdd != nil) {
                    [btnAdd removeFromSuperview];
                }
                
                //本地生成一个文件夹
                [PublicMethod addNewFolder:name inNextPath:[PublicMethod getDocumentImagePath]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[folderName]=name;
                NSString *defaultPath = [[PublicMethod getDocumentMainPath] stringByAppendingPathComponent:@"defaultBGImage.png"];
                if (![PublicMethod isFileExist:defaultPath]) {
                    NSData *defaultData = UIImageJPEGRepresentation([UIImage imageNamed:@"PhotoGroup"], 0.5);
                    [defaultData writeToFile:defaultPath atomically:YES];
                }
                dict[folderImage]=@"defaultBGImage.png";
                [self.fileList addObject:dict];
                [PublicMethod saveFileList:self.fileList];
                [self.mycollectionView reloadData];
                
                
            }
        }else if(alertView.tag == 1002){
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            gestureVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gestureVc animated:YES];
        }else if(alertView.tag == 1009){
            
            NSLog(@"dle");
            NSMutableDictionary *dict = self.fileList[deleteFolderIndex];
            NSString *name = dict[folderName];
            NSString *deletPath = [[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:name];
            NSFileManager *manager = [NSFileManager defaultManager];
            BOOL flag = [manager removeItemAtPath:deletPath error:nil];
            if (flag) {
                [YJProgressHUD showSuccess:@"删除成功" inview:self.view];
                [self.fileList removeObject:dict];
                [self.fileList writeToFile:filePath atomically:YES];
                [self.mycollectionView reloadData];
            }else{
                [YJProgressHUD showMsgWithoutView:@"删除失败"];
            }
        }
        

        
    }

    
}


#pragma mark - collectionView  daili
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fileList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    NSMutableDictionary *dict = self.fileList[indexPath.row];
    
    //如果是默认图片
    if ([dict[folderImage] isEqual:@"defaultBGImage.png"]) {
        [cell initWithImg:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[PublicMethod getDocumentMainPath],dict[folderImage]]] andName:dict[folderName]];

    }else{
        
        [cell initWithImg:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@",[PublicMethod getDocumentImagePath],dict[folderName],dict[folderImage]]] andName:dict[folderName]];

    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat WH = (KScreenWidth-(KMarginLeftRight*2)-KMarginCenter)/2;
    return CGSizeMake(WH, WH);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  KMarginCenter;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return KMarginCenter;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(KMarginCenter, KMarginLeftRight, KMarginCenter, KMarginLeftRight);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = self.fileList[indexPath.row];
    
    HomeDetailViewController * detail = [[HomeDetailViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.folderPath =dict[folderName];
    pushPage = dict[folderName];
    [self.navigationController pushViewController:detail animated:YES];

 
}


#pragma  mark - cell  delegate

-(void)FolderCellDidDeleteFolderAtIndex:(NSInteger)index{
    
    
    UIAlertView *alertDelete = [[UIAlertView alloc] initWithTitle:@"提示" message:@"将会一起删除相册内所有照片，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertDelete.tag = 1009;
    deleteFolderIndex = index;
    [alertDelete show];
    

    
}




@end







