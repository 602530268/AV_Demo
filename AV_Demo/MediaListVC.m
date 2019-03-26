//
//  MediaListVC.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "MediaListVC.h"
#import "PlayerVC.h"
#import "CCRecord.h"

@interface MediaListVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *datas;

@end

@implementation MediaListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Media List";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.datas = [CCRecord mediaList];
    
    UIBarButtonItem *removeAllBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(removeAllFiles)];
    self.navigationItem.rightBarButtonItem = removeAllBtnItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *path = self.datas[indexPath.row];
    cell.textLabel.text = path.lastPathComponent;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *path = self.datas[indexPath.row];
    PlayerVC *vc = [[PlayerVC alloc] init];
    vc.path = path;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)removeAllFiles {
    [CCRecord removeAllMedia];
    self.datas = @[].mutableCopy;
    [self.tableView reloadData];
}

@end
