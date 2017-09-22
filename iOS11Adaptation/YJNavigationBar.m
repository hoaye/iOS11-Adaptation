//
//  YJNavigationBar.m
//  iOS11Adaptation
//
//  Created by YJHou on 2017/9/22.
//  Copyright © 2017年 https://github.com/stackhou. All rights reserved.
//

#import "YJNavigationBar.h"

@implementation YJNavigationBar



#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

- (BOOL)isIPhoneX{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        return CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size);
    }else{
        return NO;
    }
}

@end
