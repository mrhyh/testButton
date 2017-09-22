//
//  FolderCell.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/16.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FolderCellDelegate <NSObject>

-(void)FolderCellDidDeleteFolderAtIndex:(NSInteger)index;

@end
@interface FolderCell : UICollectionViewCell

@property (nonatomic,weak) id<FolderCellDelegate>  delegate;

-(void)initWithImg:(UIImage *)img andName:(NSString *)name;

@property (nonatomic,assign) NSInteger  index;

@end
