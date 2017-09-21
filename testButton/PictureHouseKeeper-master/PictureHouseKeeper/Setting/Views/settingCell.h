//
//  settingCell.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/22.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingCell : UITableViewCell

@property (nonatomic,strong) UILabel  *lblTitle;

@property (nonatomic,strong) UILabel  *lblDesc;

-(void)initTitle:(NSString *)title withDesc:(NSString *)desc;

@end
