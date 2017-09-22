//
//  PictureCell.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/17.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "PictureCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation PictureCell{
    UIButton *btnDelete;
    UIButton *btnvideoPlay;
    NSString *localPath;
}

#define btnWH 25

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_imgView];
        
        [self hideDeleteBtn];
    }
    
    return self;
}


-(void)addDeleteBtn{
    self.isSelected = YES;
    if (btnDelete == nil) {
        btnDelete = [[UIButton alloc] init];
        [btnDelete setImage:[UIImage imageNamed:@"cellSelected"] forState:UIControlStateNormal];
        btnDelete.frame = CGRectMake(self.frame.size.width-btnWH, 0, btnWH, btnWH);
        [btnDelete addTarget:self action:@selector(btnDidSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];

    }

    
}


-(void)addVideoBuuton:(NSString *)path{
    [self hideDeleteBtn];
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.masksToBounds = YES;
    
    if (path.length<=0) {
        _imgView.image = [UIImage imageNamed:@"empty_failed"];
        return;
    }
    
    localPath = path;
    
    UIImage *bgImg = [self thumbnailImageForVideo: [NSURL fileURLWithPath:path] atTime:1];
    _imgView.image = bgImg;
    
    if (btnvideoPlay == nil) {
        btnvideoPlay = [[UIButton alloc] initWithFrame:self.bounds];
        [btnvideoPlay setImage:[UIImage imageNamed:@"playblue"] forState:UIControlStateNormal];
        [btnvideoPlay addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnvideoPlay];
    }
    
    btnvideoPlay.enabled = YES;
    
}

-(void)playVideo{
    if (btnvideoPlay.selected) {
        NSLog(@"stop");
    }else{
        NSLog(@"play");
        if ([self.delegate respondsToSelector:@selector(PictureCellDidPlayVideoWithpath:)]) {
            [self.delegate PictureCellDidPlayVideoWithpath:localPath];
        }
    }
    btnvideoPlay.selected = !btnvideoPlay.selected;
}
                          
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
  NSParameterAssert(asset);
  AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
  assetImageGenerator.appliesPreferredTrackTransform = YES;
  assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
  
  CGImageRef thumbnailImageRef = NULL;
  CFTimeInterval thumbnailImageTime = time;
  NSError *thumbnailImageGenerationError = nil;
  thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
  
  if(!thumbnailImageRef)  
      NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);  
  
  UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;  
  
  return thumbnailImage;  
}
                          
                        

-(void)hideDeleteBtn{
    
    self.isSelected = NO;
    if (btnDelete != nil) {
        [btnDelete removeFromSuperview];
        btnDelete = nil;
    }
}

-(void)btnDidSelect{
    if ([self.delegate respondsToSelector:@selector(PictureCellDidDeleteAtIndexpath:)]) {
        [self.delegate PictureCellDidDeleteAtIndexpath:self.cellTag];
    }
}


-(void)addDeleteIcon{
    btnvideoPlay.enabled = NO;
    self.isSelected = YES;
    if (btnDelete == nil) {
        btnDelete = [[UIButton alloc] init];
        [btnDelete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        btnDelete.frame = CGRectMake(self.frame.size.width-btnWH, 0, btnWH, btnWH);
        [btnDelete addTarget:self action:@selector(btnDeleteByIcon) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];
        
        
    }

}


-(void)btnDeleteByIcon{
    if ([self.delegate respondsToSelector:@selector(PictureCellDidDeleteVideoWithpath:andIndexpath:)]) {
        [self.delegate PictureCellDidDeleteVideoWithpath:localPath andIndexpath:self.cellTag];
    }
}
@end
