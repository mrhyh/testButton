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

    _manager = [[CGXPickerViewManager alloc] init];
    _manager.pickerTitleSelectColor = [UIColor blackColor];
    _manager.defaultRow = 2;
    _manager.defaultComponent = 0;
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *dataSources1 = [[NSMutableArray alloc] init];
    for (int i=0; i<=23; i++) {
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
    
    MGStringPickerView *strPickerView = [[MGStringPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3*2, 200) dataSource:dataSources defaultSelValue:defaultSelValueArr isAutoSelect:YES manager:_manager resultBlock:^(id selectValue, id selectRow) {
        NSLog(@"左：%@ 右：%@",selectValue,selectRow);
    }];
    
    [self.view addSubview:strPickerView];
}

@end
