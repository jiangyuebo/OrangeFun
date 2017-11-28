//
//  PlayListViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "PlayListViewController.h"

@interface PlayListViewController ()

@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"播单";
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
