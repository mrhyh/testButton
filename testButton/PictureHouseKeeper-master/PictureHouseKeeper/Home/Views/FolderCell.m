//
//  FolderCell.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/16.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "FolderCell.h"

@implementation FolderCell{
    UIImageView *imgView;
    UILabel *lblName;
    UIButton *btnDel;
}

#define cornerRadiusWH 5


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = cornerRadiusWH;
        
        [self initViews];
    }
    
    return  self;
}


-(void)initViews{
    imgView = [[UIImageView alloc] init];
    lblName = [[UILabel alloc] init];
    lblName.textColor = [UIColor whiteColor];
    lblName.backgroundColor = KColorWithRGBA(0, 0, 0, 0.4);
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.layer.cornerRadius = cornerRadiusWH;
    lblName.layer.masksToBounds = YES;
    
    btnDel = [[UIButton alloc] init];
    [btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDel setImage:[UIImage imageNamed:@"deleteFolder"] forState:UIControlStateNormal];
    [btnDel addTarget:self action:@selector(deleFolder) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:imgView];
    [self addSubview:lblName];
    [self addSubview:btnDel];
    
}


-(void)initWithImg:(UIImage *)img andName:(NSString *)name{
    imgView.image = img;
    lblName.text = name;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    imgView.frame = CGRectMake(2,2, self.frame.size.height-4, self.frame.size.width-4);
    
    lblName.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30);
    
    btnDel.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);


}

-(void)deleFolder{
    

    if ([self.delegate respondsToSelector:@selector(FolderCellDidDeleteFolderAtIndex:)]) {
        [self.delegate FolderCellDidDeleteFolderAtIndex:self.index];
    }
    

}




@end
