//
//  ElegantTableViewGenerator.h
//  ElegantTableViewDemo
//
//  Created by YJHou on 2017/7/3.
//  Copyright © 2017年 侯跃军. All rights reserved.
//  一个实例方法 创建简单的 TableView

/** 
    版本号: 0.0.1
 */

#import <UIKit/UIKit.h>

typedef void(^didSelectRowHandleBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^didScrollHandleBlock)(UIScrollView *tableView, CGPoint contentOffset);

@interface ElegantTableViewGenerator : NSObject

/** 单例 */
+ (ElegantTableViewGenerator *)shareInstance;

/** 创建tableView */
- (UITableView *)createTableViewWithTitles:(NSArray *)titles
                                 subTitles:(NSArray *)subTitles
                                 rowHeight:(CGFloat)rowHeight
                                 superView:(UIView *)superView
                         didSelectRowBlock:(didSelectRowHandleBlock)didSelectRowBlock
                            didScrollBlock:(didScrollHandleBlock)didScrollBlock;

@end
