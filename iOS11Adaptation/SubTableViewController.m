//
//  SubTableViewController.m
//  iOS11Adaptation
//
//  Created by YJHou on 2017/9/21.
//  Copyright © 2017年 https://github.com/stackhou. All rights reserved.
//

#import "SubTableViewController.h"

@interface SubTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setUpSubTableViewNavgationView];
    [self _setUpSubTableViewMainView];
}

- (void)_setUpSubTableViewNavgationView{
    self.navigationItem.title = @"TableView适配";
}

- (void)_setUpSubTableViewMainView{
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate


#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
