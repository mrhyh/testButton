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

@property (nonatomic , strong) MGPickerViewManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGPickerViewManager *model = (MGPickerViewManager *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MGPickerViewManager_LastTime"]];
//    MGPickerViewManager *model  = (MGPickerViewManager *)[NSKeyedUnarchiver unarchivedObjectOfClass:MGPickerViewManager.class fromData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MGPickerViewManager_LastTime"] error:nil];


    _manager = [[MGPickerViewManager alloc] init];
    _manager.pickerTitleSelectColor = [UIColor blackColor];
    
    if (model != nil) {
        _manager.defaultRow = model.defaultRow;
        _manager.defaultComponent = model.defaultComponent;
    }
    
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
    
    MGStringPickerView *strPickerView = [[MGStringPickerView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH/4*3, 200) dataSource:dataSources defaultSelValue:defaultSelValueArr isAutoSelect:YES manager:_manager resultBlock:^(id selectRow, id selectComponent) {
        NSLog(@"左：%@ 右：%@",selectRow,selectComponent);
        
        MGPickerViewManager *model = [[MGPickerViewManager alloc] init];
        model.defaultRow = [selectRow integerValue];
        model.defaultComponent = [selectComponent integerValue];
        
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [userd setObject:data forKey:@"MGPickerViewManager_LastTime"];
        [userd synchronize];
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:strPickerView];
    self.view.backgroundColor = [UIColor greenColor];
}

@end
