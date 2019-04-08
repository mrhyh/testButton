//
//  ViewController.m
//  pickerText
//
//  Created by ylgwhyh on 16/7/8.
//  Copyright © 2019年 ios3. All rights reserved.
//

#import "ViewController.h"
#import "MGStringPickerView.h"

@interface ViewController ()

@property (nonatomic , strong) CGXPickerViewManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.manager = [[CGXPickerViewManager alloc] init];
    self.manager.pickerTitleSelectColor = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *dataSources1 = [[NSMutableArray alloc] init];
    for (int i=0; i<=12; i++) {
        [dataSources1 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *dataSources2 = [[NSMutableArray alloc] init];
    for (int i=0; i<=59; i++) {
        [dataSources2 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSArray *dataSources = @[dataSources1,dataSources2];
    NSArray *defaultSelValueArr = @[@"4"];
    if (dataSources == nil || dataSources.count == 0) {
        return;
    }
    
    MGStringPickerView *strPickerView = [[MGStringPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) dataSource:dataSources defaultSelValue:defaultSelValueArr isAutoSelect:YES manager:_manager resultBlock:^(id selectValue, id selectRow) {
        NSLog(@"选择1：%@ 选择2：%@",selectValue,selectRow);
    }];
    
    [self.view addSubview:strPickerView];
}

@end
