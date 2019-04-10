//
//  CGXStringPickerView.h
//  CGXPickerView
//
//  Created by ylgwhyh on 2019/4/8.
//  Copyright © 2019年 ylgwhyh. All rights reserved.
//


#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

/// RGB颜色(16进制)
#define CGXPickerRGBColor(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MGPickerViewManager;

typedef void(^MGStringResultBlock)(id selectHour,id selectMinute);

@interface MGStringPickerView : UIView

@property (nonatomic , strong) MGPickerViewManager *manager;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                      manager:(MGPickerViewManager *)manager
                  resultBlock:(MGStringResultBlock)resultBlock;
@end

@interface MGPickerViewManager : NSObject <NSCoding>

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)enCoder;

@property (nonatomic, assign) CGFloat kPickerViewH;//选择器高度 默认200
@property (nonatomic, assign) CGFloat kTopViewH;//按钮高度 默认 50

@property (nonatomic, strong) UIColor *pickerTitleColor;//字体颜色  默认黑色
@property (nonatomic, assign) CGFloat pickerTitleSize;//字体大小  默认15

@property (nonatomic, strong) UIColor *pickerTitleSelectColor;//字体颜色  默认黑色
@property (nonatomic, assign) CGFloat pickerTitleSelectSize;//字体大小  默认15

@property (nonatomic, assign) CGFloat titleSize;//字体大小
@property (nonatomic, assign) CGFloat rowHeight; //单元格高度 默认30

@property (nonatomic, assign) NSInteger defaultRow; 
@property (nonatomic, assign) NSInteger defaultComponent;

@end
