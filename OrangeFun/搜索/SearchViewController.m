//
//  SearchViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SearchViewController.h"
#import "ProjectHeader.h"
#import "JerryViewTools.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    //搜索框背景图片
    UIImage *searchBgImage = [UIImage imageNamed:@"searchbg"];
    UIImage *resizeBgImage = [searchBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 18)];
    [self.searchTextField setBackground:resizeBgImage];
    //搜索框 小图标
    UIImageView *littlePicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    self.searchTextField.leftView = littlePicView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
//    UIView *headerView = [self.view viewWithTag:1];
//    headerView.frame = CGRectMake(20, 0, 50, 44);
//    self.navigationItem.titleView = headerView;
}

- (IBAction)btnSearch:(UIButton *)sender {
    //检查是否合法
    NSString *searchText = self.searchTextField.text;
    
    if (![searchText isEqualToString:@""]) {
        //跳转
        NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
        [passDic setObject:searchText forKey:search_keyword];
        [JerryViewTools jumpFrom:self ToViewController:viewcontroller_searchdiplay carryDataDic:passDic];
    }else{
        [self showToastText:@"要输入内容才能查询哟~"];
    }
}

- (void)showToastText:(NSString *) text{
    [JerryViewTools showCZToastInViewController:self andText:text];
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
