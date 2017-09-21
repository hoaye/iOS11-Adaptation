//
//  ViewController.m
//  ElegantTableViewDemo
//
//  Created by YJHou on 2017/7/3.
//  Copyright © 2017年 侯跃军. All rights reserved.
//

#import "ViewController.h"
#import "ElegantTableViewGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *dataSources = @[@"我的", @"你的", @"大家的"];
    
    [[ElegantTableViewGenerator shareInstance] createTableViewWithTitles:dataSources subTitles:nil rowHeight:44 superView:self.view didSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"-->%ld", (long)indexPath.row);
    } didScrollBlock:^(UIScrollView *tableView, CGPoint contentOffset) {
        NSLog(@"-->%@", NSStringFromCGPoint(contentOffset));
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
