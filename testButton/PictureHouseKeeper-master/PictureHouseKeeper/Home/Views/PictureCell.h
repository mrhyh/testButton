//
//  PictureCell.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/17.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureCellDelegate <NSObject>

-(void)PictureCellDidDeleteAtIndexpath:(NSInteger)index;
-(void)PictureCellDidPlayVideoWithpath:(NSString *)path;

-(void)PictureCellDidDeleteVideoWithpath:(NSString *)path andIndexpath:(NSInteger)indexpath;

@end

@interface PictureCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView  *imgView;

@property (nonatomic,assign) NSInteger  cellTag;

@property (nonatomic,assign) int  isSelected;

@property (nonatomic,weak) id<PictureCellDelegate>  delegate;

-(void)addVideoBuuton:(NSString *)path;

-(void)addDeleteBtn;

-(void)hideDeleteBtn;

//shiping  de  shanchu
-(void)addDeleteIcon;


@end
