//
//  VideoViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/25.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "VideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PictureCell.h"
#import <ZFPlayerView.h>

#define KMarginLeftRight 10
#define KMarginCenter 10


@interface VideoViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PictureCellDelegate,ZFPlayerDelegate>

@property (nonatomic,strong) UICollectionView  *mycollectionView;

@property (nonatomic,strong) NSMutableArray  *picArry;

@property (nonatomic,strong) NSMutableArray  *toDeletePathArry;

/**是否抖动*/
@property (nonatomic,assign) BOOL isBegin;
/**抖动手势*/
@property (nonatomic,strong) UILongPressGestureRecognizer *recognize;


@property (nonatomic,strong) ZFPlayerView *playerView;

@end
static NSString * cellID = @"cellID";

@implementation VideoViewController{
    NSString *prefixpath;
    UIButton *btnAdd;
    UILabel *lblDesc;
    NSString *deleteLogPath;
    NSInteger deleteIndexpath;
    
    
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

-(NSMutableArray *)picArry{
    if(_picArry==nil){
        _picArry=[NSMutableArray array];
    }
    return  _picArry;
}

-(NSMutableArray *)toDeletePathArry{
    if(_toDeletePathArry==nil){
        _toDeletePathArry=[NSMutableArray array];
    }
    return  _toDeletePathArry;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    prefixpath = [PublicMethod getDocumentVideoPath];
    
    //本地生成一个文件夹
    [PublicMethod addNewFolder:@"" inNextPath:[PublicMethod getDocumentVideoPath]];
    
    [self getFolderArry];
    
    [self.mycollectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:cellID];
    self.mycollectionView.delegate = self;
    self.mycollectionView.dataSource = self;
    
    [self setupNav:NO];
    
    [self addRecognize];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.picArry.count<=0){
        [self showEmptyAddBtn];
    }else{
        [self.mycollectionView reloadData];
    }
}

- (void)setupNav:(BOOL)isEdit {
    
    if (isEdit) {
        UIButton *btnFinish = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
        [btnFinish setTitleColor:blueColor forState:UIControlStateNormal];
        [btnFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btnFinish addTarget:self action:@selector(btnFinishClick) forControlEvents:UIControlEventTouchUpInside];
        btnFinish.titleLabel.font = [UIFont systemFontOfSize:17];
        UIBarButtonItem *barbtnFinish =  [[UIBarButtonItem alloc] initWithCustomView:btnFinish];
        
        self.navigationItem.rightBarButtonItem = barbtnFinish;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(btnCancelDelete)];
        

    }else{
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [btnEdit setTitleColor:blueColor forState:UIControlStateNormal];
        [btnEdit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btnEdit addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
        btnEdit.titleLabel.font = [UIFont systemFontOfSize:17];
        UIBarButtonItem *barEdit =  [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
        if (self.picArry.count<=0) {
            btnEdit.enabled = NO;
        }else{
            btnEdit.enabled = YES;
        }
        
        self.navigationItem.leftBarButtonItem = barEdit;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newPicture)];
        
    }

}

-(void)btnEditClick:(UIButton *)sender{
    if (self.picArry.count<=0) {
        return;
    }
    _isBegin = YES;
    [_mycollectionView removeGestureRecognizer:_recognize];
    [self setupNav:YES];
    [_mycollectionView reloadData];
    
}

-(void)btnFinishClick{
    NSLog(@"btnFinishClick");
}

-(void)btnCancelDelete{
    [self.toDeletePathArry removeAllObjects];
    _isBegin = NO;
    [self.mycollectionView reloadData];
    [self setupNav:NO];
}

-(void)newPicture{
    NSLog(@"new");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍 照",@"相册导入", nil];
    [sheet showInView:self.view];
    
}

-(void)getFolderArry{
    NSString *path = [PublicMethod getDocumentVideoPath];
    NSFileManager *file = [NSFileManager defaultManager];
    NSArray *folderarry = [file subpathsOfDirectoryAtPath:path error:nil];
    self.picArry = [NSMutableArray arrayWithArray:folderarry];
    if (self.picArry.count>0) {
        [self hideEmptyTip];
        if (!_isBegin) {
             [self setupNav:NO];
        }
       
    }else if(_isBegin){
        [self setupNav:NO];
    }
    [self.mycollectionView reloadData];
    
}


-(void)showEmptyAddBtn{
    if (btnAdd == nil) {
        btnAdd = [[UIButton alloc] init];
        [btnAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KScreenWidth-150)/2, (KScreenHeight-150-64)/2, 150, 180);
        [btnAdd addTarget:self action:@selector(newPicture) forControlEvents:UIControlEventTouchUpInside];
        
        lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 150, 30)];
        lblDesc.text = @"还木有视频...";
        lblDesc.textAlignment = NSTextAlignmentCenter;
        lblDesc.textColor = [UIColor lightGrayColor];
        [btnAdd addSubview:lblDesc];
        
        [self.view addSubview:btnAdd];
    }
    
}

-(void)hideEmptyTip{
    [btnAdd removeFromSuperview];
    btnAdd = nil;
}



#pragma mark - UIActionSheet
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [actionSheet setHidden:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog([NSString stringWithFormat:@"%d",buttonIndex]);
    if (buttonIndex == 0) {
        //拍照
        [self takePhoto];
        
    }else if (buttonIndex == 1){
        //相册
        [self takePhotoByLib];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
       
        
        [PublicMethod deleteFile:deleteLogPath];
        
        [self getFolderArry];
    }
}

-(void)takePhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [PublicMethod showAlert:@"拍照功能不可用"];
        return;
    }
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.sourceType = UIImagePickerControllerSourceTypeCamera;
    pc.delegate = self;
    pc.allowsEditing = YES;
    [self presentViewController:pc animated:YES completion:nil];
    
    
}


-(void)takePhotoByLib{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [PublicMethod showAlert:@"相册功能不可用"];
            return;
        }
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pc.mediaTypes = @[(NSString *)kUTTypeMovie];
        pc.delegate = self;
        pc.allowsEditing = YES;
        [self presentViewController:pc animated:YES completion:nil];
    
    
    
}

#pragma mark -   system UIImagePickerController  代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  
    NSLog([NSString stringWithFormat:@"%@",info]);
    
    [YJProgressHUD showProgress:@"保存中..." inView:[[UIApplication sharedApplication].windows lastObject]];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        //NSString *urlStr=[url path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *path = [[PublicMethod getDocumentVideoPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[PublicMethod getPicName]]];
        [data writeToFile:path atomically:YES];
        
        [self getFolderArry];
    }
    
    
    //关闭
    [picker dismissViewControllerAnimated:YES completion:^{
        [YJProgressHUD hide];
    }];
}


#pragma mark - collectionView  delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.picArry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell addVideoBuuton:[NSString stringWithFormat:@"%@/%@",prefixpath,self.picArry[indexPath.row]]];
    cell.cellTag = indexPath.row ;
    cell.delegate = self;
    if(_isBegin == YES ){
        [self starLongPress:cell];
        [cell addDeleteIcon];
    }
    return  cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat WH = (KScreenWidth-(KMarginLeftRight+KMarginCenter)*2)/3;
    return CGSizeMake(WH, WH);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(KMarginCenter, KMarginLeftRight, KMarginCenter, KMarginLeftRight);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return KMarginCenter;
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  KMarginCenter;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


#pragma mark - dianji  bofang
-(void)PictureCellDidPlayVideoWithpath:(NSString *)path{
    
    self.playerView = [[ZFPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.fatherView = [UIApplication sharedApplication].keyWindow;
    playerModel.videoURL = [NSURL fileURLWithPath:path];
    playerModel.title = @"视频";
    self.playerView.delegate = self;
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.playerView playerControlView:controlView playerModel:playerModel];
    [self.playerView autoPlayTheVideo];
    
}

-(void)zf_playerBackAction{
    self.playerView.removeFromSuperview;
    self.playerView = nil;
}


-(void)PictureCellDidDeleteVideoWithpath:(NSString *)path andIndexpath:(NSInteger)indexpath{
//     NSLog([NSString stringWithFormat:@"path:%@",path]);
    deleteLogPath = path;
    deleteIndexpath = indexpath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除操作不可撤销，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}



#pragma mark - cell doudong

//开始抖动
- (void)starLongPress:(PictureCell*)cell{
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    if (animation == nil) {
        [self shakeImage:cell];
    }else {
        [self resume:cell];
    }
}

//这个参数的理解比较复杂，我的理解是所在layer的时间与父layer的时间的相对速度，为1时两者速度一样，为2那么父layer过了一秒，而所在layer过了两秒（进行两秒动画）,为0则静止。
- (void)pause:(PictureCell*)cell {
    cell.layer.speed = 0.0;
}

- (void)resume:(PictureCell*)cell {
    cell.layer.speed = 1.0;
}


- (void)shakeImage:(PictureCell*)cell {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.08];
    
    //抖动角度
    animation.fromValue = @(-M_1_PI/5);
    animation.toValue = @(M_1_PI/5);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [cell.layer addAnimation:animation forKey:@"rotation"];
}

- (void)addRecognize{
    //添加长按抖动手势
    if(!_recognize){
        _recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    }
    //长按响应时间
    _recognize.minimumPressDuration = 1;
    [_mycollectionView addGestureRecognizer:_recognize];
}


- (void)longPress:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.mycollectionView indexPathForItemAtPoint:[longGesture locationInView:self.mycollectionView]];
            _isBegin = YES;
            [_mycollectionView removeGestureRecognizer:_recognize];
            [self setupNav:YES];
            [_mycollectionView reloadData];
            NSLog(@"1");

        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"2");
            break;
        }
        case UIGestureRecognizerStateEnded:
            NSLog(@"3");
            break;
        default:
            NSLog(@"4");
            break;
    }
}



@end
