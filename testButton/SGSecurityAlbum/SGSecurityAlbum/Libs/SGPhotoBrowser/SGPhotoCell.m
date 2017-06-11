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

@property (nonatomic, weak) UIImageView *selectImageView;

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

@end

@implementation SGPhotoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPaht:(NSIndexPath *)indexPath {
    static NSString *ID = @"SGPhotoCell";
    [collectionView registerClass:[SGPhotoCell class] forCellWithReuseIdentifier:ID];
    SGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        SGPhotoCellMaskView *selectMaskView = [[SGPhotoCellMaskView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:selectMaskView];
        self.selectMaskView = selectMaskView;
    }
    return self;
}

- (void)setModel:(SGPhotoModel *)model {
    _model = model;
    NSURL *thumbURL = model.thumbURL;
    
    if (SGPMediaTypeMediaTypeImage == model.mediaType) {
        if ([thumbURL isFileURL]) {
            self.imageView.image = [UIImage imageWithContentsOfFile:thumbURL.path];
        } else {
            [self.imageView sg_setImageWithURL:thumbURL model:model];
        }
    }else if (SGPMediaTypeMediaTypeVideo == model.mediaType) {
        
#warning TODO Test
        UIImage *image = [self getVideoPreViewImageWithVideoPath:model.videoURL];
        self.imageView.image = image;
    }
    
    self.sg_select = model.isSelected;
}

// 获取视频的某一帧
- (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
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
