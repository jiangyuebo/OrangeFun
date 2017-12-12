//
//  StoryListViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/5.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "StoryListViewController.h"
#import "DiscoverTableCell.h"
#import "BMRequestHelper.h"
#import "RequestURLHeader.h"
#import "JerryViewTools.h"
#import "AppDelegate.h"
#import "ProjectHeader.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface StoryListViewController ()

@property (strong,nonatomic) NSArray *storyArray;

@end

@implementation StoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingFinish) name:@"playstatus" object:nil];
    
    self.storyListTable.dataSource = self;
    self.storyListTable.delegate = self;
    
    //注册cell
    [self registNibForTable];
    
    NSString *type = [self.passDataDic objectForKey:@"type"];
    
    if ([type isEqualToString:@"more"]) {
        self.title = [self.passDataDic objectForKey:@"categoryName"];
        //专辑ID seriaID
        NSString *seriaIDString = [NSString stringWithFormat:@"%@",[self.passDataDic objectForKey:@"seriaID"]];
        [self loadData:seriaIDString];
    }else{
        self.title = [self.passDataDic objectForKey:@"seriaName"];
    
        //其他信息
        if (self.passDataDic) {
            NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
            if (seriaName) {
                //是专辑
                NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                self.storyCountLabel.text = [NSString stringWithFormat:@"共 %lu 个故事",(unsigned long)[stories count]];
            }
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 播放完成监听 刷新列表更新显示
- (void)playingFinish{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer next];
    [self.storyListTable reloadData];
}

- (void)loadData:(NSString *) categoryId{
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index;
    
    if ([categoryId isEqualToString:@""]) {
        //热门
        url_story_index = [NSString stringWithFormat:@"%@%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_CATEGORY_HOT];
        NSLog(@"url_story_index = %@",url_story_index);
    }else{
        url_story_index = [NSString stringWithFormat:@"%@%@?seriaID=%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_CATEGORY_SERIA,categoryId];
        NSLog(@"url_story_index = %@",url_story_index);
    }
    
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
                    
                    if ([categoryId isEqualToString:@""]) {
                        //hot
                        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        self.storyArray = dataArray;
                    }else{
                        //专辑整体数据
                        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
                        self.passDataDic = tempDic;
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        if (self.storyArray) {
                            self.storyCountLabel.text = [NSString stringWithFormat:@"共 %lu 个故事",(unsigned long)[self.storyArray count]];
                        }else{
                            NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                            self.storyCountLabel.text = [NSString stringWithFormat:@"共 %lu 个故事",(unsigned long)[stories count]];
                        }
                        
                        [self.storyListTable reloadData];
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

- (void)registNibForTable{
    self.storyCellId = @"storyCellId";
    
    UINib *discoverTableCellNib = [UINib nibWithNibName:@"DiscoverTableCell" bundle:nil];
    [self.storyListTable registerNib:discoverTableCellNib forCellReuseIdentifier:self.storyCellId];
}

- (IBAction)addAllStoyAction:(UIButton *)sender {

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverTableCell *storyItemCell = [self.storyListTable dequeueReusableCellWithIdentifier:self.storyCellId];
    //设置选中样式，无
    storyItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.passDataDic) {
        
        NSString *type = [self.passDataDic objectForKey:@"type"];
        
        if ([type isEqualToString:@"more"]) {
            if (self.storyArray) {
                //故事
                NSDictionary *dataItemDic = [self.storyArray objectAtIndex:indexPath.row];
                //story name
                storyItemCell.labelStoryName.text = [dataItemDic objectForKey:@"storyName"];
                //cover image
                NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
                NSURL *coverURL = [NSURL URLWithString:logoURLString];
                [storyItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
                //play count
                NSString *playCount = [dataItemDic objectForKey:@"playNum"];
                storyItemCell.labelPlayTimes.text = [NSString stringWithFormat:@"%@次",playCount];
                
                //判断当前是否在播放
                if ([self currentDicIsPlaying:dataItemDic]) {
                    storyItemCell.webViewGif.hidden = NO;
                    
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
                    NSURL *url = [NSURL URLWithString:path];
                    [storyItemCell.webViewGif loadRequest:[NSURLRequest requestWithURL:url]];
                    storyItemCell.webViewGif.scalesPageToFit = YES;
                }else{
                    storyItemCell.webViewGif.hidden = YES;
                }
                
                return storyItemCell;
            }else{
                NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
                if (seriaName) {
                    //是专辑
                    NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                    NSDictionary *dataItemDic = [stories objectAtIndex:indexPath.row];
                    //story name
                    storyItemCell.labelStoryName.text = [dataItemDic objectForKey:@"storyName"];
                    //cover image
                    NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
                    NSURL *coverURL = [NSURL URLWithString:logoURLString];
                    [storyItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
                    //play count
                    NSString *playCount = [dataItemDic objectForKey:@"playNum"];
                    storyItemCell.labelPlayTimes.text = [NSString stringWithFormat:@"%@次",playCount];
                    
                    //判断当前是否在播放
                    if ([self currentDicIsPlaying:dataItemDic]) {
                        storyItemCell.webViewGif.hidden = NO;
                        NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
                        NSURL *url = [NSURL URLWithString:path];
                        [storyItemCell.webViewGif loadRequest:[NSURLRequest requestWithURL:url]];
                        storyItemCell.webViewGif.scalesPageToFit = YES;
                    }else{
                        storyItemCell.webViewGif.hidden = YES;
                    }
                    
                    return storyItemCell;
                }
            }
        }else{
            NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
            if (seriaName) {
                //是专辑
                NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                NSDictionary *dataItemDic = [stories objectAtIndex:indexPath.row];
                //story name
                storyItemCell.labelStoryName.text = [dataItemDic objectForKey:@"storyName"];
                //cover image
                NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
                NSURL *coverURL = [NSURL URLWithString:logoURLString];
                [storyItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
                //play count
                NSString *playCount = [dataItemDic objectForKey:@"playNum"];
                storyItemCell.labelPlayTimes.text = [NSString stringWithFormat:@"%@次",playCount];
                
                //判断当前是否在播放
                if ([self currentDicIsPlaying:dataItemDic]) {
                    storyItemCell.webViewGif.hidden = NO;
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
                    NSURL *url = [NSURL URLWithString:path];
                    [storyItemCell.webViewGif loadRequest:[NSURLRequest requestWithURL:url]];
                    storyItemCell.webViewGif.scalesPageToFit = YES;
                }else{
                    storyItemCell.webViewGif.hidden = YES;
                }
                
                return storyItemCell;
            }
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.passDataDic) {
        
        NSString *type = [self.passDataDic objectForKey:@"type"];
        
        if ([type isEqualToString:@"more"]) {
            //hot
            if (self.storyArray) {
                return [self.storyArray count];
            }else{
                NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
                if (seriaName) {
                    //是专辑
                    NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                    return [stories count];
                }
            }
        }else{
            NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
            if (seriaName) {
                //是专辑
                NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                return [stories count];
            }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *storyDic;
    if (self.storyArray) {
        storyDic = [self.storyArray objectAtIndex:indexPath.row];
    }else{
        NSArray *stories = [self.passDataDic objectForKey:@"stories"];
        storyDic = [stories objectAtIndex:indexPath.row];
    }
    
    [self storyClickedAction:storyDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击故事
- (void)storyClickedAction:(NSDictionary *) dataDic{
    
    if (self.passDataDic) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSString *type = [self.passDataDic objectForKey:@"type"];
        
        if ([type isEqualToString:@"more"]) {
            //hot
            if (self.storyArray) {
                [appDelegate.jerryPlayer addSeriaPlayItemToList:self.storyArray];
            }else{
                NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
                if (seriaName) {
                    //是专辑
                    NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                    [appDelegate.jerryPlayer addSeriaPlayItemToList:stories];
                }
            }
        }else{
            NSString *seriaName = [self.passDataDic objectForKey:@"seriaName"];
            if (seriaName) {
                //是专辑
                NSArray *stories = [self.passDataDic objectForKey:@"stories"];
                [appDelegate.jerryPlayer addSeriaPlayItemToList:stories];
            }
        }
        
        [appDelegate.jerryPlayer prepareToPlayerAtCurrentItem:dataDic];
        
        [appDelegate.jerryPlayer play];
        
        [self.storyListTable reloadData];
    }
}

#pragma mark toast提示
- (void)toastText:(NSString *) text{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [JerryViewTools showCZToastInViewController:self andText:text];
    });
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
