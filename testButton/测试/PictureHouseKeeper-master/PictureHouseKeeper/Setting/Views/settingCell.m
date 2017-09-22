//
//  settingCell.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/22.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "settingCell.h"


#define KMargin 10

@implementation settingCell

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
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.font = [UIFont systemFontOfSize:14];
    lblDesc.textColor = [UIColor lightGrayColor];
    lblDesc.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:lblDesc];
    self.lblDesc = lblDesc;
    
    
    // add  yueshu
    self.lblTitle.sd_layout
    .leftSpaceToView(self.contentView,KMargin)
    .rightSpaceToView(self.contentView,100)
    .topSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    self.lblDesc.sd_layout
    .leftSpaceToView(self.lblTitle,KMargin)
    .rightSpaceToView(self.contentView,KMargin)
    .topSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}


-(void)initTitle:(NSString *)title withDesc:(NSString *)desc{
    self.lblTitle.text = title;
    self.lblDesc.text = desc;
}

@end
