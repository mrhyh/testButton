//
//  HomeDetailViewController.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/17.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "PictureCell.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <MWPhotoBrowser.h>

#define KMarginLeftRight 10
#define KMarginCenter 10

@interface HomeDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,MWPhotoBrowserDelegate,PictureCellDelegate>

@property (nonatomic,strong) UICollectionView  *mycollectionView;

@property (nonatomic,strong) NSMutableArray  *picArry;              //记录照片名称，如20160809124433222
@property (nonatomic,strong) NSMutableArray  *picShowArry;          //MWPhoto数组
@property (nonatomic,strong) NSMutableArray  *picSelectArry;        //选择删除的照片，存放照片名称

@property (nonatomic,strong) MWPhotoBrowser *browser;

@end

#define KMarginLeftRight 10
#define KMarginCenter 10

#define maxPicCount 15



@implementation HomeDetailViewController{
    NSString *PrePath;
    BOOL isOpenDelete;
    
    UIView *toolBar;
    UIButton *btnSelectAll;
    UIButton *btnFinish;
    
    
    UIButton *btnEdit;
    
    UILabel *lblEmpty;
}

static NSString * const cellID = @"pictureCell";

-(NSString *)folderPath{
    if(_folderPath==nil){
        _folderPath=@"";
    }
    return  _folderPath;
}

-(NSMutableArray *)picArry{
    if(_picArry==nil){
        _picArry=[NSMutableArray array];
    }
    return  _picArry;
}

-(NSMutableArray *)picSelectArry{
    if(_picSelectArry==nil){
        _picSelectArry=[NSMutableArray array];
    }
    return  _picSelectArry;
}

-(NSMutableArray *)picShowArry{
    if(_picShowArry==nil){
        _picShowArry=[NSMutableArray array];
    }
    return  _picShowArry;
}

-(MWPhotoBrowser *)browser{
    if(_browser==nil){
        _browser=[[MWPhotoBrowser alloc] initWithDelegate:self];
        _browser.displayActionButton = NO;
        _browser.displayNavArrows = NO;
        _browser.displaySelectionButtons = NO;
        _browser.zoomPhotosToFill = NO;
        _browser.alwaysShowControls = NO;
        _browser.enableGrid = YES;
        _browser.startOnGrid = NO;
    }
    return  _browser;
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
    
    self.title = @"照片列表";
    isOpenDelete = false;

    
    PrePath = [[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:_folderPath];
    [self getFolderArry];
    
    [self.mycollectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:cellID];
    self.mycollectionView.delegate = self;
    self.mycollectionView.dataSource = self;
 
    [self showNavRight];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addEditToolBar];
    
    self.title = _folderPath;
}



-(void)newPicture{
    NSLog(@"new");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍 照",@"相册导入", nil];
    [sheet showInView:self.view];
    
}

/**
 *  <#Description#>
 */
-(void)getFolderArry{
    NSString *path = [[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:_folderPath];
    NSFileManager *file = [NSFileManager defaultManager];
    NSArray *folderarry = [file subpathsOfDirectoryAtPath:path error:nil];
    self.picArry = [NSMutableArray arrayWithArray:folderarry];
    
    if (self.picArry.count<=0){
        [self showEmptyTip];
       
    }else{
        [self hideEmptyTip];
        
        
        //添加浏览数组
        [self.picShowArry removeAllObjects];
        for (int i=0;i<self.picArry.count;i++) {
            MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,self.picArry[i]]]];
            [self.picShowArry addObject:photo];
        }

    }
    [self.mycollectionView reloadData];

    
}

-(void)showEmptyTip{
    lblEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight/2-30, KScreenWidth, 60)];
    lblEmpty.text = @"还没有任何照片哦\n可点击右上角＋号添加照片";
    lblEmpty.numberOfLines = 0;
    lblEmpty.font = [UIFont systemFontOfSize:22];
    lblEmpty.textColor = [UIColor lightGrayColor];
    lblEmpty.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:lblEmpty aboveSubview:self.mycollectionView];
    
}

-(void)hideEmptyTip{
    if (lblEmpty != nil) {
        [lblEmpty removeFromSuperview];
        lblEmpty = nil;
    }
}


-(UIImage *)getImage:(NSInteger)index{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:_folderPath],self.picArry[index]];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    return  img;
    
}

-(void)btnEditClick:(UIButton *)sender{
 
    isOpenDelete = YES;
    [self hideNavRight];
    
    btnFinish.enabled = NO;
    [self showToolBar];
   
    
}

#pragma mark - 控制右导航
-(void)showNavRight{
    
    UIBarButtonItem *barNew =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newPicture)];
    
    
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit setTitleColor:blueColor forState:UIControlStateNormal];
    [btnEdit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btnEdit addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    btnEdit.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem *barEdit =  [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = @[barNew,barEdit];
    
    if (self.picArry.count>0) {
        btnEdit.enabled = YES;
    }else{       
        btnEdit.enabled = NO;
    }
}

-(void)hideNavRight{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClick)];

    
}

-(void)btnCancelClick{
    isOpenDelete = NO;
    [self showNavRight];
    
    [self hideToolBar];
    [self.mycollectionView reloadData];
    
}


#pragma mark - 显示／隐藏编辑工具栏
-(void)showToolBar{
    [UIView animateWithDuration:0.5 animations:^{
        toolBar.frame = CGRectMake(0, KScreenHeight-toolBar.height, KScreenWidth, toolBar.height);
    }];
}

-(void)hideToolBar{
    [UIView animateWithDuration:0.5 animations:^{
        toolBar.frame = CGRectMake(0, KScreenHeight, KScreenWidth, toolBar.height);
    }];
}

-(void)addEditToolBar{
    toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 50)];
    toolBar.backgroundColor = KColorWithRGB(11,22,33);
    [self.view addSubview:toolBar];
    
    btnSelectAll = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 100, 40)];
    [btnSelectAll setImage:[UIImage imageNamed:@"all"] forState:UIControlStateNormal];
    [btnSelectAll setImage:[UIImage imageNamed:@"all_selected"] forState:
     UIControlStateSelected];
    btnSelectAll.tag = 999;
    btnSelectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSelectAll setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnSelectAll setTitle:@"全部选中" forState:UIControlStateNormal];
    [btnSelectAll setTitle:@"取消全选" forState:UIControlStateSelected];
    [btnSelectAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelectAll setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnSelectAll addTarget:self action:@selector(btnSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:btnSelectAll];
    
    
    btnFinish = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth-100, 0, 100, toolBar.height)];
    [btnFinish setTitle:@"删除" forState:UIControlStateNormal];
    [btnFinish setImage:[UIImage imageNamed:@"deletePic"] forState:UIControlStateDisabled];
    [btnFinish setImage:[UIImage imageNamed:@"deletePic_selected"] forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [toolBar addSubview:btnFinish];
    [btnFinish addTarget:self action:@selector(btnFinishClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)btnFinishClick{
    NSLog(@"btnFinishClick");
    if (self.picSelectArry.count<=0) {
        return;
    }
    
    NSString *prePath = [NSString stringWithFormat:@"%@/%@",[PublicMethod getDocumentImagePath],_folderPath];
    for (NSString *path in self.picSelectArry) {
        @autoreleasepool {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",prePath,path];
            [PublicMethod deleteFile:fullPath];
        }
    }
    
    [self hideToolBar];
    btnEdit.selected = NO;
    isOpenDelete = NO;
    
    [self getFolderArry];
    
    [self showNavRight];
    
}

-(void)btnSelectAll:(UIButton *)sender{
    if (!sender.selected) {
        //全选
        isOpenDelete = YES;
        btnFinish.enabled = YES;
        sender.selected = YES;
        [self.picSelectArry removeAllObjects];
        self.picSelectArry = [self.picArry mutableCopy];
        
    }else{
        //取消全选
         sender.selected = NO;
        btnFinish.enabled = NO;
        
        [self.picSelectArry removeAllObjects];
    }
     [self.mycollectionView reloadData];
}

#pragma mark - collectionView  delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.picArry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",PrePath,self.picArry[indexPath.row]]];
    cell.cellTag = indexPath.row ;
    if (isOpenDelete) {
        if (btnSelectAll.selected) {
            [cell addDeleteBtn];
        }else{
            [cell hideDeleteBtn];
        }
    }else{
        [cell hideDeleteBtn];
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
    
    if (isOpenDelete) {
        PictureCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isSelected) {
            [cell hideDeleteBtn];
        }else{
            [cell addDeleteBtn];
        }
        
        [self RefreshPicArry:indexPath.row isAdd:cell.isSelected];
        
    }else{
        self.browser = nil;
        [self.browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:self.browser animated:YES];
        
        [self.browser showNextPhotoAnimated:YES];
        [self.browser showPreviousPhotoAnimated:YES];
    
    }

}


-(void)RefreshPicArry:(NSInteger)index isAdd:(BOOL)isAdd{
    if (isAdd) {
        [self.picSelectArry addObject:self.picArry[index]];
        
        
    }else if(self.picSelectArry.count>0){
        NSString *temp = self.picArry[index];
        for (NSInteger i= 0; i<self.picSelectArry.count; i++) {
            if (self.picSelectArry[i] == temp) {
                [self.picSelectArry removeObject:self.picSelectArry[i]];
                break;
            }
            
        }
        
    }
    
    btnFinish.enabled = self.picSelectArry.count>0;
    if (self.picSelectArry.count == self.picArry.count) {
        btnSelectAll.selected = YES;
    }else{
        btnSelectAll.selected = NO;
    }
    
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
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
//        [PublicMethod showAlert:@"相册功能不可用"];
//        return;
//    }
//    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
//    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    pc.delegate = self;
//    pc.allowsEditing = YES;
//    [self presentViewController:pc animated:YES completion:nil];

    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CTAssetsPickerController *ctPicker = [[CTAssetsPickerController alloc] init];
            ctPicker.delegate = self;
            ctPicker.showsNumberOfAssets = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                ctPicker.modalPresentationStyle = UIModalPresentationFormSheet;
            }
            
            [self presentViewController:ctPicker animated:YES completion:nil];
            
        });
    }];

    
}



#pragma mark -   system UIImagePickerController  代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //关闭
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog([NSString stringWithFormat:@"%@",info]);
    
    UIImage *image=nil;
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //图片
        image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        
    }else if(picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary){
        NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"]) {
            image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
        }else if([type isEqualToString:@""]){
            NSLog(@"shipin");
        }
        
    }
    
    [self savePic:image];
    
    [self getFolderArry];
}

-(void)savePic:(UIImage *)image{
    NSData *iconData=UIImageJPEGRepresentation(image, 0.3);
    
    //保存本地
    NSString *path=[[PublicMethod getDocumentImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",_folderPath,[PublicMethod getPicName]]];
    
    //一定要先保存本地，不然上传时本地路径娶不到data
    [iconData writeToFile:path atomically:YES];
    
    
    

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - ctassets  delegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    
    [YJProgressHUD showProgress:@"保存中..." inView:[[UIApplication sharedApplication].windows lastObject]];
    for (PHAsset *set in assets) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        [[PHImageManager defaultManager] requestImageForAsset:set targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //设置图片
            [self savePic:result];
        
        }];
    }
    
    [YJProgressHUD hide];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self getFolderArry];
    }];
    
    btnEdit.enabled = YES;
}

-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    if (picker.selectedAssets.count>= (NSInteger)maxPicCount) {
        [YJProgressHUD showMsgWithoutView:[NSString stringWithFormat:@"最多选择 %d 张",(NSInteger)maxPicCount]];
        return false;
    }
    
    return  true;
    
}




#pragma mark - mwPhotoBrowser  delegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.picShowArry.count;
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index<self.picShowArry.count) {
        return self.picShowArry[index];
    }
    
    return nil;
    
}

-(BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index{
    if (index<self.picShowArry.count) {
        UIImage *img = [self getImage:index];
        UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
        
    }
    
    return true;
    
}


#pragma mark - cell 删除代理
-(void)PictureCellDidDeleteAtIndexpath:(NSInteger)index{
    NSLog([NSString stringWithFormat:@"删除 %d",index]);
}


@end
