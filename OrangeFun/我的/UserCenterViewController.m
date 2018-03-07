//
//  UserCenterViewController.m
//  OrangeFun
//
//  Created by yuebo.jiang on 2018/2/11.
//  Copyright © 2018年 Jerry. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoginViewController.h"
#import "JerryViewTools.h"
#import "ProjectHeader.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"我的";
    
    //判断用户登录态，如果未登录，弹出登录界面
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_login];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
