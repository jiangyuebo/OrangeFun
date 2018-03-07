//
//  MainTabBarViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置自定义bar item 图标
    [self setCustomTabBarItem];
    
    //添加手势
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recognizerRight];
    
    //自定义navigation bar
    //颜色
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //返回按钮
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *) recognizer{
    NSUInteger selectedIndex = [self selectedIndex];
    
    NSArray *viewsInTabArray =  [self viewControllers];
    NSUInteger controllersCount = [viewsInTabArray count];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"左滑");
        if (selectedIndex < (controllersCount - 1)) {
            [self setSelectedViewController:viewsInTabArray[selectedIndex + 1]];
        }
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"右滑");
        if (selectedIndex > 0) {
            [self setSelectedViewController:viewsInTabArray[selectedIndex - 1]];
        }
    }
}

#pragma mark 设置自定义TAB BAR ITEM 图标
- (void)setCustomTabBarItem{
    UITabBar *tabBar = self.tabBar;
    
    //首页
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    item0.image = [[UIImage imageNamed:@"index"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"indexhover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //播放
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"playhover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //发现
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"findhover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item3.image = [[UIImage imageNamed:@"find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"findhover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置选中后标题颜色
    for (int i = 0; i < [tabBar.items count]; i++) {
        //迭代所有tab bar item统一设置选中后字颜色
        NSMutableDictionary *textArrays = [NSMutableDictionary dictionary];
        textArrays[NSForegroundColorAttributeName] = [UIColor orangeColor];
        [[tabBar.items objectAtIndex:i] setTitleTextAttributes:textArrays forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tab 切换代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    
    return YES;
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
