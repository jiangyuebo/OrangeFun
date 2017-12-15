//
//  DiscoverViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableCell.h"
#import "globalHeader.h"
#import "RequestURLHeader.h"
#import "ProjectHeader.h"

#import "BMRequestHelper.h"
#import "JerryViewTools.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImage+GIF.h>

#import "MJRefresh.h"

@interface DiscoverViewController ()

@property (strong,nonatomic) NSArray *discoverDataArray;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.discoverDataArray = [NSArray array];
    self.tableDiscover.delegate = self;
    self.tableDiscover.dataSource = self;
    
    self.tableDiscover.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    //注册cell
    [self registNibForTable];
    
    [self loadData];
}

#pragma mark 为首页table注册cell ui
- (void)registNibForTable{
    self.storyCellID = @"storyCellID";
    
    UINib *discoverTableCellNib = [UINib nibWithNibName:@"DiscoverTableCell" bundle:nil];
    [self.tableDiscover registerNib:discoverTableCellNib forCellReuseIdentifier:self.storyCellID];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"发现";
}

- (void)loadData{
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index = [NSString stringWithFormat:@"%@%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_DESCOVER];
    NSLog(@"url_story_index = %@",url_story_index);
    
    [requestHelper getRequestAsynchronousToUrl:url_story_index andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            if (error.code == -1009) {
                //无网络
                [self toastText:@"无网络哎，先联网吧~"];
            }
        }else{
            if (data) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if (httpResponse.statusCode == 200) {
                    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    self.discoverDataArray = dataArray;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.tableDiscover reloadData];
                        
                        [self.tableDiscover.mj_header endRefreshing];
                    });
                }else{
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    if (jsonDic) {
                        NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
                        if (errorCode) {
                            [self toastText:[jsonDic objectForKey:@"errorMsg"]];
                        }
                    }else{
                        [self toastText:@"数据出错"];
                    }
                }
            }else{
                [self toastText:@"数据出错"];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableCell *storyItemCell = [self.tableDiscover dequeueReusableCellWithIdentifier:self.storyCellID];
    //设置选中样式，无
    storyItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataItemDic = [self.discoverDataArray objectAtIndex:indexPath.row];
    NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
    NSLog(@"logoURLString : %@",logoURLString);
    NSString *itemName = [dataItemDic objectForKey:@"seriaName"];
    //name
    storyItemCell.labelStoryName.text = itemName;
    //cover
    NSURL *coverURL = [NSURL URLWithString:logoURLString];
    
    [storyItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
//    NSURL *url = [NSURL URLWithString:path];
//    [storyItemCell.webViewGif loadRequest:[NSURLRequest requestWithURL:url]];
//    storyItemCell.webViewGif.scalesPageToFit = YES;
    
    storyItemCell.labelPlayTimes.hidden = YES;
    storyItemCell.btnAddToPlayList.hidden = YES;
    storyItemCell.imageViewPlayCount.hidden = YES;
    
    return storyItemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.discoverDataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dataMuta = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_storylist carryDataDic:dataMuta];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.discoverDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

#pragma mark toast提示
- (void)toastText:(NSString *) text{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [JerryViewTools showCZToastInViewController:self andText:text];
    });
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
