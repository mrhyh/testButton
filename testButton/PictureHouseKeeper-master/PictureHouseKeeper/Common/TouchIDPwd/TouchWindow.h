//
//  TouchWindow.h
//  TouchIDDemo
//
//  Created by Ben on 16/3/11.
//  Copyright © 2016年 https://github.com/CoderBBen/YBTouchID.git. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^showNumberVCBlock)();

@interface TouchWindow : UIView

@property (nonatomic,assign) showNumberVCBlock myBlock;

- (void)show;
- (void)dismiss;

@end
