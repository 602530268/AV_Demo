//
//  ViewController.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/12.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Audio/Video demo";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _datas = @[@[@{@"title":@"视音频播放",
                   @"class":@"PlayerVC",
                   @"nav":@(NO)
                   }],
               @[@{@"title":@"视音频编辑",
                   @"class":@"VideoEditVC",
                   @"nav":@(NO)
                   }],
               @[@{@"title":@"视音频录制:AVCaptureMovieFileOutput",
                   @"class":@"RecordByFileOutputVC",
                   @"nav":@(NO)
                   },
                 @{@"title":@"视音频录制:AVAssetWriter",
                   @"class":@"RecordByAssetWriterVC",
                   @"nav":@(NO)
                   }],
               @[@{@"title":@"本地视音频列表",
                   @"class":@"MediaListVC",
                   @"nav":@(YES)
                   }]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    });
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *info = _datas[indexPath.section][indexPath.row];
    cell.textLabel.text = info[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = _datas[indexPath.section][indexPath.row];
    NSString *title = info[@"title"];
    NSString *className = info[@"class"];
    BOOL nav = [info[@"nav"] boolValue];

    Class class = NSClassFromString(className);
    if (!class) {
        NSLog(@"控制器不存在.");
        return;
    }
    UIViewController *vc = (UIViewController *)[[class alloc] init];
    vc.title = title;
    if (nav) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
