//
//  settingSwitchCell.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/22.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "settingSwitchCell.h"

#define KMargin 10
@implementation settingSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initViews{
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lblTitle];
    self.lblTitle = lblTitle;
    
    UISwitch *sw = [[UISwitch alloc] init];
    self.sw = sw;
    self.sw.hidden = NO;
    [sw addTarget:self action:@selector(swChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:sw];
    
    
    // add  yueshu
    self.lblTitle.sd_layout
    .leftSpaceToView(self.contentView,KMargin)
    .rightSpaceToView(self.contentView,100)
    .topSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    self.sw.sd_layout
    .leftSpaceToView(self.lblTitle,KMargin)
    .rightSpaceToView(self.contentView,KMargin)
    .centerYEqualToView(self.contentView);
    
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}


-(void)initTitle:(NSString *)title isSwitchOn:(BOOL)isOn{
    self.lblTitle.text = title;
    [self.sw setOn:isOn];
}

-(void)setSwitchStatus:(BOOL)isOn{
    [self.sw setOn:isOn];
}

-(void)setHide{
    self.sw.hidden = YES;
}

-(void)swChanged{
    self.isOnStatus = self.sw.isOn;
    
    if ([self.delegate respondsToSelector:@selector(settingSwitchCellDidValueChanged:)]) {
        [self.delegate settingSwitchCellDidValueChanged:self.sw.isOn];
    }
}
@end
