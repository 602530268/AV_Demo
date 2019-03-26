//
//  RecordBaseUIViewController.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "RecordBaseUIViewController.h"

@interface RecordBaseUIViewController ()

@end

@implementation RecordBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _recordView = [[CCRecordView alloc] init];
    [self.view addSubview:_recordView];
    [_recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(StateBarAndNavBarHeight, 0, 0, 0));
    }];
}

- (void)dealloc {
    NSLog(@"dealloc: %@",[self class]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
