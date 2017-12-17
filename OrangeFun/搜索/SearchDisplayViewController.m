//
//  SearchDisplayViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/12.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SearchDisplayViewController.h"
#import "JerryViewTools.h"
#import "BMRequestHelper.h"
#import "RequestURLHeader.h"
#import "ProjectHeader.h"
#import "AppDelegate.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "DiscoverTableCell.h"

@interface SearchDisplayViewController ()

@property (strong,nonatomic) NSMutableArray *searchResultArray;

@property (strong,nonatomic) NSString *resultCellId;

@end

@implementation SearchDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    self.searchResultArray = [NSMutableArray array];
    
    [self registNibForTable];
    
    self.searchResultTable.delegate = self;
    self.searchResultTable.dataSource = self;
    
    NSString *keyword = [self.passDataDic objectForKey:search_keyword];
    [self loadData:keyword];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)registNibForTable{
    self.resultCellId = @"resultCellId";
    
    UINib *discoverTableCellNib = [UINib nibWithNibName:@"DiscoverTableCell" bundle:nil];
    [self.searchResultTable registerNib:discoverTableCellNib forCellReuseIdentifier:self.resultCellId];
}

- (void)loadData:(NSString *) keyword{
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index = [NSString stringWithFormat:@"%@%@?keywords=%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_SEARCH,keyword];
    
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
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    NSString *resultTextString;
                    //专辑
                    if ([resultDic objectForKey:@"serias"]) {
                        //有专辑
                        NSArray *seriasArray = [resultDic objectForKey:@"serias"];
                        [self.searchResultArray addObjectsFromArray:seriasArray];
                        
                        resultTextString = [NSString stringWithFormat:@"有%lu个专辑结果",(unsigned long)[seriasArray count]];
                    }
                    
                    if ([resultDic objectForKey:@"stories"]) {
                        //有故事
                        NSArray *storyArray = [resultDic objectForKey:@"stories"];
                        [self.searchResultArray addObjectsFromArray:storyArray];
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if ([self.searchResultArray count] > 0) {
                            //有内容
                            self.noSearchResultView.hidden = YES;
                            [self.searchResultTable reloadData];
                        }else{
                            //无内容
                            self.noSearchResultView.hidden = NO;
                        }
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
    
    DiscoverTableCell *resultItemCell = [self.searchResultTable dequeueReusableCellWithIdentifier:self.resultCellId];
    //设置选中样式，无
    resultItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataItemDic = [self.searchResultArray objectAtIndex:indexPath.row];
    
    if ([dataItemDic objectForKey:@"stories"]) {
        //专辑
        NSString *seriaName = [dataItemDic objectForKey:@"seriaName"];
        resultItemCell.labelStoryName.text = seriaName;
    }else{
        //单曲
        NSString *storyName = [dataItemDic objectForKey:@"storyName"];
        resultItemCell.labelStoryName.text = storyName;
    }
    
    NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
    //cover
    NSURL *coverURL = [NSURL URLWithString:logoURLString];
    
    [resultItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    
    //判断当前是否在播放
    if ([self currentDicIsPlaying:dataItemDic]) {
        resultItemCell.webViewGif.hidden = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
        NSURL *url = [NSURL URLWithString:path];
        [resultItemCell.webViewGif loadRequest:[NSURLRequest requestWithURL:url]];
        resultItemCell.webViewGif.scalesPageToFit = YES;
    }else{
        resultItemCell.webViewGif.hidden = YES;
    }
    
    return resultItemCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResultArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDic = [self.searchResultArray objectAtIndex:indexPath.row];
    if ([itemDic objectForKey:@"stories"]) {
        //是专辑
        NSMutableDictionary *dataMuta = [NSMutableDictionary dictionaryWithDictionary:itemDic];
        [JerryViewTools jumpFrom:self ToViewController:viewcontroller_storylist carryDataDic:dataMuta];
    }else{
        //是单曲
        [self storyClickedAction:itemDic];
    }
}

- (void)storyClickedAction:(NSDictionary *) dataDic{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer addPlayItemToList:dataDic];
    
    [appDelegate.jerryPlayer prepareToPlayer];
    
    [appDelegate.jerryPlayer play];
    
    [self.searchResultTable reloadData];
    
    //跳转到播放页
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_playview];
}

#pragma mark 如果正在播放，则显示GIF
- (BOOL)currentDicIsPlaying:(NSDictionary *) currentDic{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *playingDic = appDelegate.jerryPlayer.currentItem;
    
    NSString *currentName = [currentDic objectForKey:@"storyName"];
    NSString *playingName = [playingDic objectForKey:@"storyName"];
    if ([currentName isEqualToString:playingName]) {
        return YES;
    }else{
        return NO;
    }
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
