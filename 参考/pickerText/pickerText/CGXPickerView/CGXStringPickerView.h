//
//  CGXStringPickerView.h
//  CGXPickerView
//
//  Created by ylgwhyh on 2017/8/22.
//  Copyright © 2017年 ylgwhyh. All rights reserved.
//


#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CGXPickerViewManager;

/**
 *  @param selectValue     选择的行标题文字
 *  @param selectRow       选择的行标题下标
 */
typedef void(^CGXStringResultBlock)(id selectValue,id selectRow);

@interface CGXStringPickerView : UIView

@property (nonatomic , strong) CGXPickerViewManager *manager;
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 弹出视图
@property (nonatomic, strong) UIView *alertView;
// 顶部视图
@property (nonatomic, strong) UIView *topView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *leftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *rightBtn;
// 中间标题
@property (nonatomic, strong) UILabel *titleLabel;
// 分割线视图
@property (nonatomic, strong) UIView *lineView;

/** 初始化子视图 */
- (void)initUI;

/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;

/** 取消按钮的点击事件 */
- (void)clickLeftBtn;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;

- (instancetype)initWithTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource
              DefaultSelValue:(id)defaultSelValue
                IisAutoSelect:(BOOL)isAutoSelect
                      Manager:(CGXPickerViewManager *)manager
                  ResultBlock:(CGXStringResultBlock)resultBlock;
@end

@interface CGXPickerViewManager : NSObject

@property (nonatomic , assign) CGFloat kPickerViewH;//选择器高度 默认200
@property (nonatomic , assign) CGFloat kTopViewH;//按钮高度 默认 50

@property (nonatomic , strong) UIColor *pickerTitleColor;//字体颜色  默认黑色
@property (nonatomic , assign) CGFloat pickerTitleSize;//字体大小  默认15

@property (nonatomic , strong) UIColor *pickerTitleSelectColor;//字体颜色  默认黑色
@property (nonatomic , assign) CGFloat pickerTitleSelectSize;//字体大小  默认15

@property (nonatomic , strong) UIColor *lineViewColor;//分割线颜色
@property (nonatomic , strong) UIColor *titleLabelColor;//中间标题颜色
@property (nonatomic , strong) UIColor *titleLabelBGColor;//中间标题背景颜色
@property (nonatomic , assign) CGFloat titleSize;//字体大小
@property (nonatomic , assign) CGFloat rowHeight; //单元格高度 默认30

@property (nonatomic , strong) UIColor *rightBtnTitleColor;//右侧标题颜色
@property (nonatomic , strong) UIColor *rightBtnBGColor;//右侧标题背景颜色
@property (nonatomic , assign) CGFloat rightBtnTitleSize;//字体大小
@property (nonatomic , strong) NSString *rightBtnTitle;//右侧文字
@property (nonatomic , assign) CGFloat rightBtnCornerRadius;//右侧圆角
@property (nonatomic , assign) CGFloat rightBtnBorderWidth;//右侧边框宽
@property (nonatomic , strong) UIColor *rightBtnborderColor;//右侧边框颜色


@property (nonatomic , strong) UIColor *leftBtnTitleColor;//右侧标题颜色
@property (nonatomic , strong) UIColor *leftBtnBGColor;//右侧标题背景颜色
@property (nonatomic , assign) CGFloat leftBtnTitleSize;//字体大小
@property (nonatomic , strong) NSString *leftBtnTitle;//右侧文字
@property (nonatomic , assign) CGFloat leftBtnCornerRadius;//右侧圆角
@property (nonatomic , assign) CGFloat leftBtnBorderWidth;//右侧边框宽
@property (nonatomic , strong) UIColor *leftBtnborderColor;//右侧边框颜色


@property (nonatomic , assign) BOOL isHaveLimit; //是否有 “不限”选项  默认没有

@end
