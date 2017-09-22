//
//  settingSwitchCell.h
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/22.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol settingSwitchCellDelegate <NSObject>

-(void)settingSwitchCellDidValueChanged:(BOOL)isOn;

@end

@interface settingSwitchCell : UITableViewCell
@property (nonatomic,strong) UILabel  *lblTitle;
@property (nonatomic,strong) UISwitch  *sw;

@property (nonatomic,assign) BOOL  isOnStatus;

-(void)initTitle:(NSString *)title isSwitchOn:(BOOL)isOn;

-(void)setSwitchStatus:(BOOL)isOn;

-(void)setHide;

@property (nonatomic,weak) id<settingSwitchCellDelegate> delegate;
@end
