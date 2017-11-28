//
//  MainViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "MainViewController.h"
#import "globalHeader.h"
#import "ProjectHeader.h"

#import "BannerViewCell.h"
#import "SearchBarViewCell.h"
#import "CategoryStoryViewCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉TableView顶上空白
    self.navigationController.navigationBar.translucent = NO;
    
    self.mainPageTable.dataSource = self;
    self.mainPageTable.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"橙娃故事";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //注册banner cell
    static NSString *bannerCellId = @"bannerCellId";
    //flag
    static BOOL isBannerRegist = NO;
    if (!isBannerRegist) {
        //加载xib页面
        UINib *bannerNib = [UINib nibWithNibName:@"BannerViewCell" bundle:nil];
        //注册单元格
        [self.mainPageTable registerNib:bannerNib forCellReuseIdentifier:bannerCellId];
        isBannerRegist = YES;
    }
    
    //注册搜索框view
    static NSString *searchBarCellId = @"searchBarCellId";
    static BOOL isSearchBarRegist = NO;
    if (!isSearchBarRegist) {
        //加载xib
        UINib *searchBarNib = [UINib nibWithNibName:@"SearchBarViewCell" bundle:nil];
        //注册单元格
        [self.mainPageTable registerNib:searchBarNib forCellReuseIdentifier:searchBarCellId];
        isSearchBarRegist = YES;
    }
    
    //注册分类故事
    static NSString *categoryStoryCellId = @"categoryStoryCellId";
    static BOOL isCategoryStoryRegist = NO;
    if (!isCategoryStoryRegist) {
        //加载xib
        UINib *categoryStoryNib = [UINib nibWithNibName:@"CategoryStoryViewCell" bundle:nil];
        //注册单元格
        [self.mainPageTable registerNib:categoryStoryNib forCellReuseIdentifier:categoryStoryCellId];
        isCategoryStoryRegist = YES;
    }
    
    //**********************上面是cell的注册*********************
    
    //获取banner
    BannerViewCell *bannerCell = [self.mainPageTable dequeueReusableCellWithIdentifier:bannerCellId];
    //设置banner图片
    [bannerCell setBannerURLs:nil];
    
    //获取搜索bar
    SearchBarViewCell *searchBarCell = [self.mainPageTable dequeueReusableCellWithIdentifier:searchBarCellId];
    
    //获取分类故事
    CategoryStoryViewCell *categoryStoryCell = [self.mainPageTable dequeueReusableCellWithIdentifier:categoryStoryCellId];
    
    //*********************上面是获取CELL对象***********************
    
    if (indexPath.row == 0) {
        return bannerCell;
    }
    
    if (indexPath.row == 1) {
        return searchBarCell;
    }
    
    if (indexPath.row == 2) {
        return categoryStoryCell;
    }
    
    return bannerCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat cellHeight = SCREENWIDTH/banner_width * banner_height;
        return cellHeight;
    }
    
    if (indexPath.row == 1) {
        return 68;
    }
    
    if (indexPath.row == 2) {
        return 330;
    }
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
