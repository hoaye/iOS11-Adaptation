//
//  MainViewController.m
//  iOS11Adaptation
//
//  Created by YJHou on 2017/9/21.
//  Copyright © 2017年 https://github.com/stackhou. All rights reserved.
//

#import "MainViewController.h"
#import <ElegantTableView/ElegantTableViewGenerator.h>

#import "SubTableViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *dataSource; /**< 数据源 */
@property (nonatomic, strong) NSArray *gotoVCClasses; /**< 跳转类集合 */

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setUpMainView];
}

- (void)_setUpMainView{
    
    [[ElegantTableViewGenerator shareInstance] createTableViewWithTitles:self.dataSource subTitles:nil rowHeight:50 superView:self.view didSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row < self.gotoVCClasses.count) {
            
            id  class = (UIViewController *)self.gotoVCClasses[indexPath.row];
            if (class) {
                UIViewController * vc = [[class alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } didScrollBlock:^(UIScrollView *tableView, CGPoint contentOffset) {
        
    }];
}

#pragma mark - Lazy
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"TableView 适配", @"运动传感器"];
    }
    return _dataSource;
}

- (NSArray *)gotoVCClasses{
    if (!_gotoVCClasses) {
        _gotoVCClasses = @[[SubTableViewController class], [SubTableViewController class]];
    }
    return _gotoVCClasses;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
