//
//  ComTabViewController.m
//  INongBao
//
//  Created by lipeng on 16/6/15.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComTabViewController.h"

#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"

@implementation ComTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.tabBar.translucent = NO;
    // 创建页面
    [self initBarView];
}

#pragma mark -- ***********************  创建页面  ***********************
- (void)initBarView {
    if ([self.viewControllers count] > 0) {
        return;
    }
    
    // 标题
    NSArray *titleArray = @[@"首页",@"购物车",@"我"];
    // 图片
    NSArray *normalArray = @[@"tool_button_home_bor",@"tool_button_buy_bor",@"tool_button_user_bor"];
    NSArray *selectedArray = @[@"tool_button_home_sel",@"tool_button_buy_sel",@"tool_button_user_sel"];
    
    NSArray *vcArray = @[[[HomeViewController alloc] init], [[ShoppingCartViewController alloc] init], [[MineViewController alloc] init]];
    
    UITabBar *tabBar = self.tabBar;
    self.viewControllers = vcArray;
    
    for (int i = 0; i < vcArray.count; i++) {
        UITabBarItem *item = [tabBar.items objectAtIndex:i];
        item.image = [UIImage imageNamed:normalArray[i]];
        item.selectedImage = [[UIImage imageNamed:selectedArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = titleArray[i];
    }
    //改变颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
}

@end
