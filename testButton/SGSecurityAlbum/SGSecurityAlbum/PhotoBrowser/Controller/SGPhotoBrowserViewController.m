//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowserViewController.h"
#import "QBImagePickerController.h"

@interface SGPhotoBrowserViewController () <QBImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<SGPhotoModel *> *photoModels;

@end

@implementation SGPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self loadFiles];
}

- (void)commonInit {
    self.numberOfPhotosPerRow = 4;
    self.title = [SGFileUtil getFileNameFromPath:self.rootPath];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    WS();
    [self setNumberOfPhotosHandlerBlock:^NSInteger{
        return weakSelf.photoModels.count;
    }];
    [self setphotoAtIndexHandlerBlock:^SGPhotoModel *(NSInteger index) {
        return weakSelf.photoModels[index];
    }];
    [self setReloadHandlerBlock:^{
        [weakSelf loadFiles];
    }];
}

- (void)loadFiles {
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *photoPath = [SGFileUtil photoPathForRootPath:self.rootPath];
    NSString *thumbPath = [SGFileUtil thumbPathForRootPath:self.rootPath];
    NSString *videoPath = [SGFileUtil videoPathForRootPath:self.rootPath];
    NSMutableArray *photoModels = @[].mutableCopy;
    NSArray *fileNames = [mgr contentsOfDirectoryAtPath:photoPath error:nil];
    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileName = fileNames[i];
        NSURL *photoURL = [NSURL fileURLWithPath:[photoPath stringByAppendingPathComponent:fileName]];
        NSURL *thumbURL = [NSURL fileURLWithPath:[thumbPath stringByAppendingPathComponent:fileName]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL  = photoURL;
        model.thumbURL  = thumbURL;
        model.mediaType = SGPMediaTypeMediaTypeImage;
        [photoModels addObject:model];
    }
    
    NSArray *videoFileNames = [mgr contentsOfDirectoryAtPath:videoPath error:nil];
    for (NSUInteger i = 0; i < videoFileNames.count; i++) {
        NSString *fileName = videoFileNames[i];
        NSURL *videoURL = [NSURL fileURLWithPath:[videoPath stringByAppendingPathComponent:fileName]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.videoURL  = videoURL;
        model.mediaType = SGPMediaTypeMediaTypeVideo;
        [photoModels addObject:model];
    }
    
    
    self.photoModels = photoModels;
    [self reloadData];
}

#warning TODO Test 
#pragma mark - UIBarButtonItem Action
- (void)addClick {
    QBImagePickerController *picker = [QBImagePickerController new];
    picker.delegate = self;
    picker.mediaType = QBImagePickerMediaTypeAny;
    picker.allowsMultipleSelection = YES;
    picker.showsNumberOfSelectedAssets = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#warning TODO Test 选中图片或者视频点击完成后的回调
#pragma mark - QBImagePickerController Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.synchronous = YES;
    
    PHVideoRequestOptions *videoOp = [[PHVideoRequestOptions alloc] init];
    videoOp.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:imagePickerController.view];
    [imagePickerController.view addSubview:hud];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    __block  NSInteger progressCount = 0;
    NSMutableArray *importAssets = @[].mutableCopy;
#warning TODO Test 这里为什么要*2呢？
    //NSInteger progressSum = assets.count * 2;
    NSInteger progressSum = assets.count * 1;
    void (^hudProgressBlock)(NSInteger currentProgressCount) = ^(NSInteger progressCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = (double)progressCount / progressSum;
            if (progressCount == progressSum) {
                [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                [hud hideAnimated:YES];
                [self loadFiles];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest deleteAssets:importAssets];
                } completionHandler:nil];
            }
        });
    };
    for (int i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        
        [importAssets addObject:asset];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        //NSString *fileName = [[NSString stringWithFormat:@"%@%@",dateStr,@(i)] MD5];
        NSString *fileName = [NSString stringWithFormat:@"%@%@",dateStr,@(i)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 获取一个资源（PHAsset）
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    
                    NSURL *url = urlAsset.URL;
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    
                    
                    [SGFileUtil saveVideo:data toRootPath:self.rootPath withName:fileName];
                    hudProgressBlock(++progressCount);
                }];
            }else if (asset.mediaType == PHAssetMediaTypeImage) {
                [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage *result, NSDictionary *info) {
                    
                    [SGFileUtil savePhoto:result toRootPath:self.rootPath withName:fileName];
                    hudProgressBlock(++progressCount);
                }];
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [SGFileUtil saveThumb:result toRootPath:self.rootPath withName:fileName];
                    hudProgressBlock(++progressCount);
                }];
            }
        });
        
    }
}

//获取Documents目录
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}


- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
