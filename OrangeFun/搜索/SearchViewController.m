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
#import "JerryTools.h"
#import "globalHeader.h"
#import "LeftViewTextField.h"

@interface SearchViewController ()

@property (strong,nonatomic) LeftViewTextField *leftViewTextField;

@property (strong,nonatomic) NSMutableArray *searchHistoryArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"返回";
    
    [self initView];
}

- (void)btnSearch:(UIButton *)sender {
    
    [self hideKeyboard];
    
    //检查是否合法
    NSString *searchText = self.leftViewTextField.text;

    if (![searchText isEqualToString:@""]) {
        //跳转
        NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
        [passDic setObject:searchText forKey:search_keyword];
        [JerryViewTools jumpFrom:self ToViewController:viewcontroller_searchdiplay carryDataDic:passDic];
        
        //记录搜索内容
        
    }else{
        [self showToastText:@"要输入内容才能查询哟~"];
    }
}

#pragma mark 初始化UI
- (void)initView{
    //搜索框
    [self createNavigationBarSearchArea];
    
    
}

#pragma mark 创建导航栏上的搜索框
- (void)createNavigationBarSearchArea{
    UIView *headerSearchView = [[UIView alloc] init];
    headerSearchView.frame = CGRectMake(0, 0, SCREENWIDTH - 70, self.navigationController.navigationBar.frame.size.height);
    
    //输入框
    self.leftViewTextField = [[LeftViewTextField alloc] init];
    self.leftViewTextField.frame = CGRectMake(0, 5, headerSearchView.frame.size.width - 60, headerSearchView.frame.size.height - 10);
    self.leftViewTextField.placeholder = @"搜索故事";
    
    //清除按钮
    self.leftViewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.leftViewTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.leftViewTextField.font = [UIFont systemFontOfSize:14];
    //搜索框背景图片
    UIImage *searchBgImage = [UIImage imageNamed:@"searchbg"];
    UIImage *resizeBgImage = [searchBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 18)];
    [self.leftViewTextField setBackground:resizeBgImage];
    //搜索框 小图标
    UIImageView *littlePicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    self.leftViewTextField.leftView = littlePicView;
    self.leftViewTextField.leftViewMode = UITextFieldViewModeAlways;
    [headerSearchView addSubview:self.leftViewTextField];
    
    //搜索按钮
    UIButton *searchBtn = [[UIButton alloc] init];
    searchBtn.frame = CGRectMake(self.leftViewTextField.frame.size.width, 0, 60, headerSearchView.frame.size.height);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [headerSearchView addSubview:searchBtn];
    //添加点击事件
    [searchBtn addTarget:self action:@selector(btnSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = headerSearchView;
}

#pragma mark 准备搜索历史记录数据
- (NSMutableArray *)prepareHistoryArray{
    NSMutableArray *searchHistoryArray = [NSMutableArray array];
    
    NSString *searchHistoryString = (NSString *)[JerryTools readInfo:storage_key_search_history];
    if (searchHistoryString) {
        NSLog(@"有内容");
    }
    
    return searchHistoryArray;
}

- (void)hideKeyboard{
    [self.leftViewTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
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
