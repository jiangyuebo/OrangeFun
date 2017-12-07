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
#import "CategoryListViewCell.h"
#import "JerryViewTools.h"

#import "BMRequestHelper.h"
#import "RequestURLHeader.h"

@interface MainViewController ()

@property (strong,nonatomic) NSString *bannerCellId;

@property (strong,nonatomic) NSString *searchBarCellId;

@property (strong,nonatomic) NSString *categoryStoryCellId;

@property (strong,nonatomic) NSString *categoryListCellId;

//banner cell
@property (strong,nonatomic) BannerViewCell *bannerCell;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉TableView顶上空白
    self.navigationController.navigationBar.translucent = NO;
    
    self.mainPageTable.dataSource = self;
    self.mainPageTable.delegate = self;
    
    [self registNibForTable];

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"橙娃故事";
}

- (void)loadData{
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index = [NSString stringWithFormat:@"%@%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_INDEX];
    NSLog(@"url_story_index = %@",url_story_index);
    
    [requestHelper getRequestAsynchronousToUrl:url_story_index andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            if (error.code == -1009) {
                //无网络
                [self toastText:@"无网络哎，先联网吧~"];
            }
        }else{
            if (data) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                if (jsonDic) {
                    NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
                    if (errorCode) {
                        [self toastText:[jsonDic objectForKey:@"errorMsg"]];
                    }else{
                        //解析数据
                        [self parseData:jsonDic];
                    }
                }else{
                    [self toastText:@"数据出错"];
                }
            }else{
                [self toastText:@"数据出错"];
            }
        }
    }];
}

#pragma mark toast提示
- (void)toastText:(NSString *) text{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [JerryViewTools showCZToastInViewController:self andText:text];
    });
}

#pragma mark 解析网络数据
- (void)parseData:(NSDictionary *) dataInfo{
    //获取banner数据
    NSArray *bannersArray = [dataInfo objectForKey:@"banners"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
       [self.bannerCell setBannerDatas:bannersArray];
    });
    
    //获取热门故事数据
    NSArray *storiesArray = [dataInfo objectForKey:@"stories"];
    
    //获取系列故事
    NSArray *seriasArray = [dataInfo objectForKey:@"serias"];
}

#pragma mark 为首页table注册cell ui
- (void)registNibForTable{
    //注册banner cell
    self.bannerCellId = @"bannerCellId";
    //加载xib页面
    UINib *bannerNib = [UINib nibWithNibName:@"BannerViewCell" bundle:nil];
    //注册单元格
    [self.mainPageTable registerNib:bannerNib forCellReuseIdentifier:self.bannerCellId];
    
    self.searchBarCellId = @"searchBarCellId";
    //加载xib
    UINib *searchBarNib = [UINib nibWithNibName:@"SearchBarViewCell" bundle:nil];
    //注册单元格
    [self.mainPageTable registerNib:searchBarNib forCellReuseIdentifier:self.searchBarCellId];
    
    self.categoryStoryCellId = @"categoryStoryCellId";
    //加载xib
    UINib *categoryStoryNib = [UINib nibWithNibName:@"CategoryStoryViewCell" bundle:nil];
    //注册单元格
    [self.mainPageTable registerNib:categoryStoryNib forCellReuseIdentifier:self.categoryStoryCellId];
    
    self.categoryListCellId = @"categoryListCellId";
    //加载xib
    UINib *categoryListNib = [UINib nibWithNibName:@"CategoryListViewCell" bundle:nil];
    //注册单元格
    [self.mainPageTable registerNib:categoryListNib forCellReuseIdentifier:self.categoryListCellId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //*********************上面是获取CELL对象***********************
    
    if (indexPath.row == 0) {
        //获取banner
        self.bannerCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.bannerCellId];
        //设置banner图片
//        [self.bannerCell setBannerDatas:nil];
        
        return self.bannerCell;
    }
    
    if (indexPath.row == 1) {
        //类型列表
        CategoryListViewCell *categoryListCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.categoryListCellId];
        //设置category list
        return categoryListCell;
    }
    
    if (indexPath.row == 2) {
        //获取搜索bar
        SearchBarViewCell *searchBarCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.searchBarCellId];
        return searchBarCell;
    }
    
    if (indexPath.row == 3) {
        //获取分类故事
        CategoryStoryViewCell *categoryStoryCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.categoryStoryCellId];
        return categoryStoryCell;
    }
    
    if (indexPath.row == 4) {
        //获取分类故事
        CategoryStoryViewCell *categoryStoryCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.categoryStoryCellId];
        return categoryStoryCell;
    }
    
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat cellHeight = SCREENWIDTH/banner_width * banner_height;
        return cellHeight;
    }
    
    if (indexPath.row == 1) {
        return SCREENWIDTH * 0.55;
    }
    
    if (indexPath.row == 2) {
        return 68;
    }
    
    if (indexPath.row == 3) {
        return 330;
    }
    
    if (indexPath.row == 4) {
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
