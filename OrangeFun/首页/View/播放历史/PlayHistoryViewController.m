//
//  PlayHistoryViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/16.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "PlayHistoryViewController.h"
#import "HistoryTool.h"
#import "PlayHistoryViewCell.h"
#import "JerryViewTools.h"
#import "ProjectHeader.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayHistoryViewController ()

@property (strong,nonatomic) NSArray *playedHistoryDataArray;

@property (strong,nonatomic) NSString *playedHistoryTableCellId;

@end

@implementation PlayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //准备数据
    [self preparePlayedHistoryData];
    
    self.playedHistoryTableCellId = @"playedhistorytablecellid";
    UINib *playedHistoryCellNib = [UINib nibWithNibName:@"PlayHistoryViewCell" bundle:nil];
    [self.playedHistoryTable registerNib:playedHistoryCellNib forCellReuseIdentifier:self.playedHistoryTableCellId];
    
    self.playedHistoryTable.delegate = self;
    self.playedHistoryTable.dataSource = self;
    
    [self.clearAllHistoryBtn addTarget:self action:@selector(deleteAllHistory) forControlEvents:UIControlEventTouchUpInside];
}

- (void)preparePlayedHistoryData{
    self.playedHistoryDataArray = [HistoryTool readHistoryDataArray];
    if ([self.playedHistoryDataArray count] > 0) {
        //有数据
        self.noResultView.hidden = YES;
        self.clearAllHistoryBtn.hidden = NO;
    }else{
        //无数据
        self.noResultView.hidden = NO;
        self.clearAllHistoryBtn.hidden = YES;
    }
}

#pragma mark 删除所有记录
- (void)deleteAllHistory{
    NSMutableArray *operationArray = [NSMutableArray array];
    //重新写入记录
    [HistoryTool refreshHistoryDataArray:operationArray];
    [self preparePlayedHistoryData];
    
    [self.playedHistoryTable reloadData];
}

#pragma mark 删除历史记录项
- (void)deleteHistoryItem:(id)sender{
    UIButton *deleteBtn = (UIButton *)sender;
    NSUInteger index = deleteBtn.tag;
    
    NSMutableArray *operationArray = [NSMutableArray arrayWithArray:self.playedHistoryDataArray];
    [operationArray removeObjectAtIndex:index];
    
    //重新写入记录
    [HistoryTool refreshHistoryDataArray:operationArray];
    [self preparePlayedHistoryData];
    
    [self.playedHistoryTable reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayHistoryViewCell *playHistoryCell = [self.playedHistoryTable dequeueReusableCellWithIdentifier:self.playedHistoryTableCellId];
    
    playHistoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataDic = [self.playedHistoryDataArray objectAtIndex:indexPath.row];
    
    playHistoryCell.deleteItemBtn.tag = indexPath.row;
    [playHistoryCell.deleteItemBtn addTarget:self action:@selector(deleteHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *logoURLString = [dataDic objectForKey:@"logoUrl"];
    NSURL *coverURL = [NSURL URLWithString:logoURLString];
    [playHistoryCell.storyCoverImageView sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    
    NSString *storyName = [dataDic objectForKey:@"storyName"];
    playHistoryCell.storyNameLabel.text = storyName;
    
    return playHistoryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.playedHistoryDataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取待播放对象
    NSDictionary *storyDataDic = [self.playedHistoryDataArray objectAtIndex:indexPath.row];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer addSeriaPlayItemToList:self.playedHistoryDataArray];
    
    [appDelegate.jerryPlayer prepareToPlayerAtCurrentItem:storyDataDic];
    
    [appDelegate.jerryPlayer play];
    
    //跳转到播放页
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_playview];
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
