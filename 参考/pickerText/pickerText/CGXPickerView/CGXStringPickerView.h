//
//  CGXStringPickerView.h
//  CGXPickerView
//
//  Created by ylgwhyh on 2017/8/22.
//  Copyright © 2017年 ylgwhyh. All rights reserved.
//

#import "CGXPickerUIBaseView.h"
/**
 *  @param selectValue     选择的行标题文字
 *  @param selectRow       选择的行标题下标
 */
typedef void(^CGXStringResultBlock)(id selectValue,id selectRow);

@interface CGXStringPickerView : CGXPickerUIBaseView

- (instancetype)initWithTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource
              DefaultSelValue:(id)defaultSelValue
                IisAutoSelect:(BOOL)isAutoSelect
                      Manager:(CGXPickerViewManager *)manager
                  ResultBlock:(CGXStringResultBlock)resultBlock;
@end
