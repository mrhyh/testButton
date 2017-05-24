//
//  TestView.m
//  testButton
//
//  Created by hyh on 2017/5/22.
//  Copyright © 2017年 hyh. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // must call super method
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    
}

@end
