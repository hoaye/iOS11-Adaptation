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
    
//    UITabBarItem *selectedTabBarItem = ((UITabBar *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).view.subviews[1]).selectedItem;
//
//    selectedTabBarItem.landscapeImagePhone = [UIImage imageNamed:@"01"];
    
//    NSLog(@"-->%@-- %@", self.tabBarItem, self.navigationController.tabBarItem);
    
//    self.navigationController.tabBarItem.landscapeImagePhone = [UIImage imageNamed:@"01"];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.tabBarItem.largeContentSizeImage = [UIImage imageNamed:@"01"];
    } else {
        // Fallback on earlier versions
    }
    
    // 大标题
    self.navigationItem.title = @"iOS11 适配";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
    }
    
    [self _setUpNavView];
}

- (void)_setUpNavView{
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemClick:)];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleView.text = @"我是TitleView";
    self.navigationItem.titleView = titleView;
}

- (void)barButtonItemClick:(UIBarButtonItem *)item{
    NSLog(@"-->%@", @"---------");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)_setUpMainView{
    
    UITableView *tableView =  [[ElegantTableViewGenerator shareInstance] createTableViewWithTitles:self.dataSource subTitles:nil rowHeight:50 superView:self.view didSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row < self.gotoVCClasses.count) {
            
            id  class = (UIViewController *)self.gotoVCClasses[indexPath.row];
            if (class) {
                UIViewController * vc = [[class alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } didScrollBlock:^(UIScrollView *tableView, CGPoint contentOffset) {
        
    }];
    
    if (@available(iOS 11.0, *)) {
//        tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - Lazy
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"TableView 适配"];
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
