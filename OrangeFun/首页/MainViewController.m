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
#import "AppDelegate.h"

#import "BMRequestHelper.h"
#import "RequestURLHeader.h"

#import "MJRefresh.h"

@interface MainViewController ()

@property (strong,nonatomic) NSString *bannerCellId;

@property (strong,nonatomic) NSString *searchBarCellId;

@property (strong,nonatomic) NSString *categoryStoryCellId;

@property (strong,nonatomic) NSString *categoryListCellId;

//main data array
@property (strong,nonatomic) NSMutableArray *mainPageDataArray;
//main category list icon name
@property (strong,nonatomic) NSArray *categoryNameArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉TableView顶上空白
    self.navigationController.navigationBar.translucent = NO;
    self.mainPageDataArray = [NSMutableArray array];
    self.categoryNameArray = [NSArray arrayWithObjects:@"童话",@"寓言",@"睡前",@"国学",@"神话",@"英语",@"百科",@"绘本",@"名著",@"其他", nil];
    
    //初始化主界面数据数组
    [self initMainPageDataArray];
    
    self.mainPageTable.dataSource = self;
    self.mainPageTable.delegate = self;
    
    self.mainPageTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self registNibForTable];

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"橙娃故事";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //根据是否正在播放，显示右上角GIF图标
    if (appDelegate.jerryPlayer.isPlaying) {
        [self createPlayingGifView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.playingGifWebView) {
        [self.playingGifWebView removeFromSuperview];
    }
}

- (void)createPlayingGifView{
    self.playingGifWebView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREENWIDTH - (30 + 8), 25, 30, 30)];
    //设置不可拖动
    self.playingGifWebView.scrollView.bounces = NO;
    self.playingGifWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.playingGifWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.playingGifWebView.scrollView.scrollEnabled = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
    NSURL *url = [NSURL URLWithString:path];
    [self.playingGifWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.playingGifWebView.scalesPageToFit = YES;
    
    [self.navigationController.view addSubview:self.playingGifWebView];
}

#pragma mark 初始化主界面列表数据
- (void)initMainPageDataArray{
    //banner init data
    NSDictionary *bannerDic = [NSDictionary dictionaryWithObject:@"" forKey:mainpage_column_banner_logoURL];
    
    NSArray *bannerDataArray = [NSArray arrayWithObject:bannerDic];
    [self.mainPageDataArray addObject:bannerDataArray];
    
    //category list data
    NSArray *categoryListDataArray = [NSArray array];
    [self.mainPageDataArray addObject:categoryListDataArray];
    
    //search bar data
    NSArray *searchBarData = [NSArray array];
    [self.mainPageDataArray addObject:searchBarData];
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
                        
                        [self.mainPageTable.mj_header endRefreshing];
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
    //设置主界面列表值
    [self.mainPageDataArray removeAllObjects];
    
    //获取banner数据
    NSArray *bannerDataArray = [dataInfo objectForKey:mainpage_column_banners];
    [self.mainPageDataArray addObject:bannerDataArray];
    
    //category list cell
    NSArray *categoryListDataArray = [NSArray array];
    [self.mainPageDataArray addObject:categoryListDataArray];
    
    //search bar data
    NSArray *searchBarData = [NSArray array];
    [self.mainPageDataArray addObject:searchBarData];

    //获取热门故事数据
    NSArray *storiesArray = [dataInfo objectForKey:mainpage_column_category_stories];
    NSMutableDictionary *categoryStoriesDic = [NSMutableDictionary dictionary];
    [categoryStoriesDic setObject:mainpage_value_category_type_hot forKey:mainpage_key_category_type];
    [categoryStoriesDic setObject:storiesArray forKey:mainpage_column_category_stories];
    [self.mainPageDataArray addObject:categoryStoriesDic];
    
    //获取系列故事
    NSArray *seriasArray = [dataInfo objectForKey:mainpage_column_category_serias];
    for (int i = 0; i < [seriasArray count]; i++) {
        NSDictionary *categoryStoryDic = seriasArray[i];
        
        [self.mainPageDataArray addObject:categoryStoryDic];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.mainPageTable reloadData];
    });
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
        BannerViewCell *bannerCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.bannerCellId];
        bannerCell.bannerDataArray = [self.mainPageDataArray objectAtIndex:0];
        [bannerCell reloadBannerData];
        
        return bannerCell;
    }
    
    if (indexPath.row == 1) {
        //类型列表
        CategoryListViewCell *categoryListCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.categoryListCellId];
        
        //绑定点击事件
        for (int i = 0; i < 10; i++) {
            UIImageView *categoryImageView = [categoryListCell viewWithTag:i];
            
            categoryImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategoryAction:)];
            [categoryImageView addGestureRecognizer:singleTap];
        }
        
        //设置category list
        return categoryListCell;
    }
    
    if (indexPath.row == 2) {
        //获取搜索bar
        SearchBarViewCell *searchBarCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.searchBarCellId];
        return searchBarCell;
    }
    
    if (indexPath.row >= 3) {
        //获取分类故事
        CategoryStoryViewCell *categoryStoryCell = [self.mainPageTable dequeueReusableCellWithIdentifier:self.categoryStoryCellId];
        NSMutableDictionary *dataDic = [self.mainPageDataArray objectAtIndex:indexPath.row];
        
        NSString *categoryType = [dataDic objectForKey:mainpage_key_category_type];
        if ([categoryType isEqualToString:mainpage_value_category_type_hot]) {
            //热门故事
            NSArray *storyArray = [dataDic objectForKey:mainpage_column_category_stories];
            categoryStoryCell.seriaID = @"";
            categoryStoryCell.categoryName.text = @"热门故事";
            categoryStoryCell.collectionDataArray = storyArray;
        }else{
            //专辑故事
            categoryStoryCell.seriaID =  [dataDic objectForKey:mainpage_column_category_seriaID];
            categoryStoryCell.categoryName.text = [dataDic objectForKey:mainpage_column_category_seriaName];
            
            NSArray *storyArray = [dataDic objectForKey:mainpage_column_category_stories];
            categoryStoryCell.collectionDataArray = storyArray;
            
        }
        [categoryStoryCell.categoryStoryCollectionView reloadData];
        
        return categoryStoryCell;
    }
    
    return nil;
}

#pragma mark 点击类型分类
- (void)clickCategoryAction:(UIGestureRecognizer *)sender{
    UIImageView *categoryImageView = (UIImageView *)sender.view;
    NSUInteger tag = categoryImageView.tag;
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    NSString *cateName = [self.categoryNameArray objectAtIndex:tag];
    [dataDic setObject:cateName forKey:mainpage_column_category_name];
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_categorylist carryDataDic:dataDic];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainPageDataArray count];
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
    
    if (indexPath.row >= 3) {
        if (SCREENWIDTH > 330) {
            //plus
            return 400;
        }else{
            return 330;
        }
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
