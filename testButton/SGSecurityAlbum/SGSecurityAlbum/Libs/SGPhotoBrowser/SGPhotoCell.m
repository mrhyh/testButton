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
#import "SGTool.h"

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
        
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-20-10, CGRectGetMaxY(self.frame)-20-10, 20, 20)];
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

@property (nonatomic, weak)   UIImageView         *imageView;
@property (nonatomic, weak)   SGPhotoCellMaskView *selectMaskView;
@property (nonatomic, strong) UIImageView         *selectImageView;

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
    }
    return self;
}

- (void)setModel:(SGPhotoModel *)model {
    _model = model;
    NSURL *thumbURL = model.thumbURL;
    self.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    
    if (SGPMediaTypeMediaTypeImage == model.mediaType) {
        [_imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if ([thumbURL isFileURL]) {
            self.imageView.image = [UIImage imageWithContentsOfFile:thumbURL.path];
        } else {
            [self.imageView sg_setImageWithURL:thumbURL model:model];
        }
    }else if (SGPMediaTypeMediaTypeVideo == model.mediaType) {
        
        UIImage *image = [SGTool getVideoPreViewImageWithVideoPath:model.videoURL];
        _imageView.image = image;
        _imageView.userInteractionEnabled = YES;
        
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        playImageView.image = [UIImage imageNamed:@"tyh_playIcon"];
        playImageView.center = _imageView.center;
        [_imageView addSubview:playImageView];
        
        [self addSubview:_imageView];
    }

    if (_model.isSelected) {
        UIImage *selectImage = [UIImage imageNamed:@"SelectButton"];
        UIImageView *selectImageView = [[UIImageView alloc] initWithImage:selectImage];
        selectImageView.frame = CGRectMake(CGRectGetWidth(self.frame)-20-10, CGRectGetHeight(self.frame)-20-10, 20, 20);
        self.selectImageView = selectImageView;
        [self addSubview:self.selectImageView];
        self.selectImageView.hidden = NO;
    }else {
        self.selectImageView.hidden = YES;
    }
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
