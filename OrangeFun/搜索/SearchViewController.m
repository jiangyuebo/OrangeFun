//
//  SearchViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //搜索框背景图片
    UIImage *searchBgImage = [UIImage imageNamed:@"searchbg"];
    UIImage *resizeBgImage = [searchBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 18)];
    [self.searchTextField setBackground:resizeBgImage];
    //搜索框 小图标
    UIImageView *littlePicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    self.searchTextField.leftView = littlePicView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)btnSearch:(UIButton *)sender {
    
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
