//
//  CGXStringPickerView.m
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2017/8/22.
//  Copyright © 2017年 曹贵鑫. All rights reserved.
//

#import "CGXStringPickerView.h"
#import <UIKit/UIKit.h>

@interface CGXStringPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
// 字符串选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIPickerView *pickerView;
// 是否是单列
@property (nonatomic, assign) BOOL isSingleColumn;
// 数据源是否合法（数组的元素类型只能是字符串或数组类型）
@property (nonatomic, assign) BOOL isDataSourceValid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *dataSource;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
@property (nonatomic, copy) CGXStringResultBlock resultBlock;
//@property (nonatomic, copy) CGXStringResultSelectBlock reuultSelectBlcok;

// 单列选中的项
@property (nonatomic, copy) NSString *selectedItem;
// 多列选中的项
@property (nonatomic, strong) NSMutableArray *selectedItems;

@property (nonatomic, strong) UILabel *leftUnitLabel;
@property (nonatomic, strong) UILabel *rightUnitLabel;

@end
@implementation CGXStringPickerView

- (CGXPickerViewManager *)manager
{
    if (!_manager ) {
        _manager = [CGXPickerViewManager new];
    }
    return _manager;
}
#pragma mark - 背景遮罩图层
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.20];
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:myTap];
    }
    return _backgroundView;
}

#pragma mark - 弹出视图
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.manager.kTopViewH - self.manager.kPickerViewH, SCREEN_WIDTH, self.manager.kTopViewH + self.manager.kPickerViewH)];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)topView {
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.manager.kTopViewH + 0.5)];
        _topView.backgroundColor = RGB_HEX(0xFDFDFD, 1.0f);
    }
    return _topView;
}

#pragma mark - 左边取消按钮
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, 7, 60, self.manager.kTopViewH-14);
        _leftBtn.backgroundColor = self.manager.leftBtnBGColor;
        _leftBtn.layer.cornerRadius = self.manager.leftBtnCornerRadius;;
        _leftBtn.layer.borderColor = self.manager.leftBtnborderColor.CGColor;
        _leftBtn.layer.borderWidth = self.manager.leftBtnBorderWidth;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:self.manager.leftBtnTitleSize];
        [_leftBtn setTitleColor:self.manager.leftBtnTitleColor forState:UIControlStateNormal];
        [_leftBtn setTitle:self.manager.leftBtnTitle forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 65, 7, 60, self.manager.kTopViewH-14);
        _rightBtn.backgroundColor = self.manager.rightBtnBGColor;;
        _rightBtn.layer.cornerRadius = self.manager.rightBtnCornerRadius;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.borderWidth = self.manager.rightBtnBorderWidth;
        _rightBtn.layer.borderColor = self.manager.rightBtnborderColor.CGColor;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:self.manager.rightBtnTitleSize];
        [_rightBtn setTitleColor:self.manager.rightBtnTitleColor forState:UIControlStateNormal];
        [_rightBtn setTitle:self.manager.rightBtnTitle forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark - 中间标题按钮
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH - 130, self.manager.kTopViewH)];
        _titleLabel.backgroundColor = self.manager.titleLabelBGColor;
        _titleLabel.font = [UIFont systemFontOfSize:self.manager.titleSize];
        _titleLabel.textColor = self.manager.titleLabelColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor  = self.manager.lineViewColor;
        [self.alertView addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource
              DefaultSelValue:(id)defaultSelValue
                 IisAutoSelect:(BOOL)isAutoSelect
                     Manager:(CGXPickerViewManager *)manager
                  ResultBlock:(CGXStringResultBlock)resultBlock
{
    if (self = [super init]) {
        self.title = title;
        self.dataSource = dataSource;
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        self.manager = manager;
        if (defaultSelValue) {
            if ([defaultSelValue isKindOfClass:[NSString class]]) {
                self.selectedItem = defaultSelValue;
            } else if ([defaultSelValue isKindOfClass:[NSArray class]]){
                self.selectedItems = [defaultSelValue mutableCopy];
            }
        }
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    self.frame = SCREEN_BOUNDS;
    // 背景遮罩图层
    //[self addSubview:self.backgroundView];
    // 弹出视图
    [self addSubview:self.alertView];
    // 设置弹出视图子视图
    // 添加顶部标题栏
    [self.alertView addSubview:self.topView];
    // 添加左边取消按钮
    [self.topView addSubview:self.leftBtn];
    // 添加右边确定按钮
    [self.topView addSubview:self.rightBtn];
    // 添加中间标题按钮
    [self.topView addSubview:self.titleLabel];
    // 添加分割线
    [self.topView addSubview:self.lineView];
    
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 加载自定义字符串数据
- (void)loadData {
    if (self.dataSource == nil || self.dataSource.count == 0) {
        self.isDataSourceValid = NO;
        return;
    } else {
        self.isDataSourceValid = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    // 遍历数组元素 (遍历多维数组一般用这个方法)
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        static Class itemType;
        if (idx == 0) {
            itemType = [obj class];
            // 判断数据源数组的第一个元素是什么类型
            if ([obj isKindOfClass:[NSArray class]]) {
                weakSelf.isSingleColumn = NO; // 非单列
            } else if ([obj isKindOfClass:[NSString class]]) {
                weakSelf.isSingleColumn = YES; // 单列
            } else {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                return;
            }
        } else {
            // 判断数组的元素类型是否相同
            if (itemType != [obj class]) {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                *stop = YES;
                return;
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (((NSArray *)obj).count == 0) {
                    weakSelf.isDataSourceValid = NO;
                    *stop = YES;
                    return;
                } else {
                    for (id subObj in obj) {
                        if (![subObj isKindOfClass:[NSString class]]) {
                            weakSelf.isDataSourceValid = NO;
                            *stop = YES;
                            return;
                        }
                    }
                }
            }
        }
    }];
    
    if (self.isSingleColumn) {
        if (self.selectedItem == nil) {
            // 如果是单列，默认选中数组第一个元素
            self.selectedItem = _dataSource.firstObject;
        }
    } else {
        BOOL isSelectedItemsValid = YES;
        for (id obj in self.selectedItems) {
            if (![obj isKindOfClass:[NSString class]]) {
                isSelectedItemsValid = NO;
                break;
            }
        }
        if (self.selectedItems == nil || self.selectedItems.count != self.dataSource.count || !isSelectedItemsValid) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSArray* componentItem in _dataSource) {
                [mutableArray addObject:componentItem.firstObject];
            }
            self.selectedItems = [NSMutableArray arrayWithArray:mutableArray];
        }
    }
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= self.manager.kTopViewH + self.manager.kPickerViewH;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += self.manager.kTopViewH + self.manager.kPickerViewH;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
//    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(_resultBlock) {
        if (self.isSingleColumn) {
            NSString  *str = [NSString stringWithFormat:@"%ld",[_dataSource indexOfObject:self.selectedItem]];
                _resultBlock([self.selectedItem copy],[str copy]);
        } else {
            NSMutableArray *selectRowAry = [NSMutableArray array];
            for (int i = 0; i<_dataSource.count; i++) {
                NSArray *arr = _dataSource[i];
                NSString *str = self.selectedItems[i];
                [selectRowAry addObject:[NSString stringWithFormat:@"%ld" , [arr indexOfObject:str]]];
            }
                _resultBlock([self.selectedItems copy],[selectRowAry copy]);
        }
    }
}

#pragma mark - 字符串选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH + 0.5, SCREEN_WIDTH, self.manager.kPickerViewH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        if (self.isSingleColumn) {
            [_dataSource enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
                if ([weakSelf.selectedItem isEqualToString:rowItem]) {
                    [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
                    *stop = YES;
                }
            }];
        } else {
            [self.selectedItems enumerateObjectsUsingBlock:^(NSString *selectedItem, NSUInteger component, BOOL *stop) {
                [_dataSource[component] enumerateObjectsUsingBlock:^(id rowItem, NSUInteger rowIdx, BOOL *stop) {
                    if ([selectedItem isEqualToString:rowItem]) {
                        [weakSelf.pickerView selectRow:rowIdx inComponent:component animated:NO];
                        *stop = YES;
                    }
                }];
            }];
        }
    }
    
    if (_leftUnitLabel == nil) {
        _leftUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pickerView.frame.size.width/4+50, _pickerView.frame.size.height/2 - 15, 50, 30)];
        _leftUnitLabel.text = @"小时";
        _leftUnitLabel.font = [UIFont systemFontOfSize:13];
        [_pickerView addSubview:_leftUnitLabel];
    }
    if (_rightUnitLabel == nil) {
        _rightUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pickerView.frame.size.width/4*3+50, _leftUnitLabel.frame.origin.y, _leftUnitLabel.frame.size.width, _leftUnitLabel.frame.size.height)];
        _rightUnitLabel.text = @"分钟";
        _rightUnitLabel.font = [UIFont systemFontOfSize:13];
        [_pickerView addSubview:_rightUnitLabel];
    }

    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isSingleColumn) {
        return 1;
    } else {
        return _dataSource.count;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return _dataSource.count;
    } else {
        return ((NSArray*)_dataSource[component]).count;
    }
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return _dataSource[row];
    } else {
        return ((NSArray*)_dataSource[component])[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        self.selectedItem = _dataSource[row];
    } else {
        self.selectedItems[component] = ((NSArray *)_dataSource[component])[row];
    }
     [pickerView reloadAllComponents];
    // 设置是否自动回调
    if (self.isAutoSelect) {
        if(_resultBlock) {
            if (self.isSingleColumn) {
                NSString  *str = [NSString stringWithFormat:@"%ld",[_dataSource indexOfObject:self.selectedItem]];
                    _resultBlock([self.selectedItem copy],[str copy]);
            } else {
                NSMutableArray *selectRowAry = [NSMutableArray array];
                for (int i = 0; i<_dataSource.count; i++) {
                    NSArray *arr = _dataSource[i];
                    NSString *str = self.selectedItems[i];
                    [selectRowAry addObject:[NSString stringWithFormat:@"%ld" , [arr indexOfObject:str]]];
                }
                _resultBlock([self.selectedItems copy],[selectRowAry copy]);
            }
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    NSLog(@"row:%ld--%ld--%@" , row,component,self.selectedItem);
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        }
    }
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        float width = SCREEN_WIDTH;
        if (self.isSingleColumn) {
            width = SCREEN_WIDTH;
        } else {
            width = SCREEN_WIDTH / 3.0;
        }
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.manager.rowHeight)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:self.manager.pickerTitleSize]];
        [pickerLabel setTextColor:self.manager.pickerTitleColor];
    }
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *normalRowString = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSString *selectRowString = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:component] forComponent:component];
    
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:normalRowString];
    [attriStr addAttribute:NSForegroundColorAttributeName value:self.manager.pickerTitleColor range:NSMakeRange(0, normalRowString.length)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.manager.pickerTitleSize] range:NSMakeRange(0, normalRowString.length)];
    
    NSMutableAttributedString * attriSelStr = [[NSMutableAttributedString alloc] initWithString:selectRowString];
    [attriSelStr addAttribute:NSForegroundColorAttributeName value:self.manager.pickerTitleSelectColor range:NSMakeRange(0, selectRowString.length)];
    [attriSelStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.manager.pickerTitleSelectSize] range:NSMakeRange(0, selectRowString.length)];
    
    
    if (row == [pickerView selectedRowInComponent:component]) {
        return attriSelStr;
    } else {
        return attriStr;
    }
}
// 设置分组的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.isSingleColumn) {
        return SCREEN_WIDTH;
    } else {
        float width = SCREEN_WIDTH / 3.0;
        return width;
    }
}
//设置单元格的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.manager.rowHeight;
}

@end
