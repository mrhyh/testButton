//
//  SGPhotoCell.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoCell.h"
#import "SGPhotoModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
 #import <MediaPlayer/MediaPlayer.h>

@interface SGPhotoCellMaskView : UIView

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *itemImageView;
@end

@implementation SGPhotoCellMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
        self.hidden = YES;
        UIImage *selectImage = [UIImage imageNamed:@"SelectButton"];
        UIImageView *selectImageView = [[UIImageView alloc] initWithImage:selectImage];
        self.selectImageView = selectImageView;
        [self addSubview:selectImageView];
        
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:_itemImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 8;
    CGFloat selectWH = 28;
    CGFloat selectX = self.bounds.size.width - padding - selectWH;
    CGFloat selectY = self.bounds.size.height - padding - selectWH;
    self.selectImageView.frame = CGRectMake(selectX, selectY, selectWH, selectWH);
}

@end

@interface SGPhotoCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) SGPhotoCellMaskView *selectMaskView;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation SGPhotoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPaht:(NSIndexPath *)indexPath {
    static NSString *ID = @"SGPhotoCell";
    [collectionView registerClass:[SGPhotoCell class] forCellWithReuseIdentifier:ID];
    SGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.frame =  self.contentView.bounds;
        self.imageView = imageView;
        [self.contentView addSubview:self.imageView];
        
//        SGPhotoCellMaskView *selectMaskView = [[SGPhotoCellMaskView alloc] initWithFrame:self.contentView.bounds];
//        [self.contentView addSubview:selectMaskView];
//        self.selectMaskView = selectMaskView;
    }
    return self;
}

- (void)setModel:(SGPhotoModel *)model {
    _model = model;
    NSURL *thumbURL = model.thumbURL;
    self.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    
    if (SGPMediaTypeMediaTypeImage == model.mediaType) {
        if ([thumbURL isFileURL]) {
            self.imageView.image = [UIImage imageWithContentsOfFile:thumbURL.path];
        } else {
            [self.imageView sg_setImageWithURL:thumbURL model:model];
        }
    }else if (SGPMediaTypeMediaTypeVideo == model.mediaType) {
        
        UIImage *image = [self getVideoPreViewImageWithVideoPath:model.videoURL];
        _imageView.image = image;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }

    if (_model.isSelected) {
        UIImage *selectImage = [UIImage imageNamed:@"SelectButton"];
        UIImageView *selectImageView = [[UIImageView alloc] initWithImage:selectImage];
        selectImageView.frame = CGRectMake(0, 0, 50, 50);
        self.selectImageView = selectImageView;
        [self addSubview:self.selectImageView];
        self.selectImageView.hidden = NO;
    }else {
        self.selectImageView.hidden = YES;
    }
    

    //self.sg_select = model.isSelected;
}


// 获取视频的某一帧
- (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(0, 1); //当前第0秒第一帧，一秒60帧，当前时间  1/60
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

- (void)setSg_select:(BOOL)sg_select {
    _sg_select = sg_select;
    self.selectMaskView.hidden = !_sg_select;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
