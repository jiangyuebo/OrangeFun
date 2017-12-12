//
//  PlayViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "PlayViewController.h"
#import "globalHeader.h"
#import "ProjectHeader.h"
#import "JerryViewTools.h"
#import "PlayListViewCell.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define PlayListHeight SCREENHEIGHT * 2/3

@interface PlayViewController ()

@property (strong,nonatomic) UIImageView *backgroundImageView;

@property (strong,nonatomic) UIImageView *coverImageView;

@property (strong,nonatomic) NSNumber *totalTimeNumber;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    //广播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"player" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 播放暂停按钮点击
- (IBAction)controlBtnAction:(UIButton *)sender {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isPlaying = appDelegate.jerryPlayer.isPlaying;
    
    if (isPlaying) {
        //正在播放，暂停
        [appDelegate.jerryPlayer pausePlay];
        [self setControlPlaying];
    }else{
        //未播放，开始
        [appDelegate.jerryPlayer continuePlay];
        [self setControlStop];
    }
}

- (IBAction)previousAction:(UIButton *)sender {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer previous];
    
    [self.tablePlayList reloadData];
    [self setGaosiBackgound];
    [self setControlStop];
}

- (IBAction)nextAction:(UIButton *)sender {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer next];
    
    [self.tablePlayList reloadData];
    [self setGaosiBackgound];
    [self setControlStop];
}

- (void)setControlPlaying{
    [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"btnPlay"] forState:UIControlStateNormal];
}

- (void)setControlStop{
    [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"btnStop"] forState:UIControlStateNormal];
}

- (void)receiveNotification:(NSNotification *) notification{
    NSDictionary *playStatus = notification.userInfo;
    NSNumber *current = [playStatus objectForKey:@"current"];
    NSNumber *total = [playStatus objectForKey:@"total"];
    
    self.totalTimeNumber = total;
    
    //转换时间 得到描述
    int current_second = [current intValue];
    int total_second = [total intValue];
    
    int played_min = current_second / 60;
    int played_second = current_second % 60;
    
    int totaltime_min = total_second / 60;
    int totaltime_second = total_second % 60;
    
    NSString *played_min_str;
    if (played_min < 10) {
        played_min_str = [NSString stringWithFormat:@"0%d",played_min];
    }else{
        played_min_str = [NSString stringWithFormat:@"%d",played_min];
    }
    
    NSString *played_second_str;
    if (played_second < 10) {
        played_second_str = [NSString stringWithFormat:@"0%d",played_second];
    }else{
        played_second_str = [NSString stringWithFormat:@"%d",played_second];
    }
    
    NSString *total_min_str;
    if (totaltime_min < 10) {
        total_min_str = [NSString stringWithFormat:@"0%d",totaltime_min];
    }else{
        total_min_str = [NSString stringWithFormat:@"%d",totaltime_min];
    }
    
    NSString *totaltime_second_str;
    if (totaltime_second < 10) {
        totaltime_second_str = [NSString stringWithFormat:@"0%d",totaltime_second];
    }else{
        totaltime_second_str = [NSString stringWithFormat:@"%d",totaltime_second];
    }
    
    NSString *playedTimeString = [NSString stringWithFormat:@"%@:%@",played_min_str,played_second_str];
    NSString *totalTimeString = [NSString stringWithFormat:@"%@:%@",total_min_str,totaltime_second_str];
    self.progressTime.text = playedTimeString;
    self.totalTime.text = totalTimeString;
    
    CGFloat progressFloat = [current floatValue] / [total floatValue];
    self.progressSlider.continuous = YES;
    [self.progressSlider setValue:progressFloat];

}

- (IBAction)progressChanged:(UISlider *)sender {
    CGFloat sliderValue = sender.value;
    
    if (self.totalTimeNumber) {
        float totalTimeFloat = [self.totalTimeNumber floatValue];
        float time = sliderValue * totalTimeFloat;
        
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.jerryPlayer jumpTimePlay:time];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.jerryPlayer.jerryDelegate = self;
    
    [self.tablePlayList reloadData];
    
    [self setGaosiBackgound];
    
    //播放按钮
    if (appDelegate.jerryPlayer.isPlaying) {
        [self setControlStop];
    }else{
        [self setControlPlaying];
    }
}

#pragma mark 设置背景模糊图片
- (void)setGaosiBackgound{
    //当前故事
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *item = appDelegate.jerryPlayer.currentItem;
    //故事名
    NSString *storyName = [item objectForKey:mainpage_column_category_story_name];
    self.navigationController.title = storyName;
    
    NSString *logoURLString = [item objectForKey:mainpage_column_category_logoURL];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:logoURLString] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        //背景
        NSLog(@"图片下载完成");
        
        [self.backgroundImageView removeFromSuperview];
        [self addBackgroundView:image];
        
        [self.coverImageView removeFromSuperview];
        [self setCoverInDisk:image];
        
    }];
}

#pragma mark 初始化一些view
- (void)initView{
    
    //设置自定义进度条
    UIImage *minImage = [[UIImage imageNamed:@"progress_orange"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    UIImage *maxImage = [[UIImage imageNamed:@"progress"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    [self.progressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"drag"] forState:UIControlStateNormal];
    [self.progressSlider setValue:0];
    
    //初始化播放列表界面
    self.playListView = [JerryViewTools getViewByXibName:@"PlayListView"];
    self.playListView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, PlayListHeight);
    [self.view addSubview:self.playListView];
    //设置播放列表view操作
    //清除列表按钮
    UIButton *btnClearPlayList = [self.playListView viewWithTag:1];
    [btnClearPlayList addTarget:self action:@selector(clearPlayList) forControlEvents:UIControlEventTouchUpInside];
    //playListView中列表
    self.tablePlayList = [self.playListView viewWithTag:2];
    //注册列表table的cell
    self.playListTableCellID = @"playListTableCellID";
    UINib *playListCellNib = [UINib nibWithNibName:@"PlayListViewCell" bundle:nil];
    [self.tablePlayList registerNib:playListCellNib forCellReuseIdentifier:self.playListTableCellID];
    
    self.tablePlayList.delegate = self;
    self.tablePlayList.dataSource = self;
    
    //playListView关闭按钮
    UIButton *btnCloseView = [self.playListView viewWithTag:3];
    [btnCloseView addTarget:self action:@selector(closePlayList) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)actionShowPlayList:(UIButton *)sender {
    if (!self.maskView) {
        //显示遮罩
        [self showPlayListMask];
        //显示播放列表view
        [self playListShowAnimation];
    }
}

- (void)playListShowAnimation{
    [self.view bringSubviewToFront:self.playListView];
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat tabbarHeight = self.tabBarController.tabBar.frame.size.height;
        self.playListView.frame = CGRectMake(
                                             self.playListView.frame.origin.x,
                                             SCREENHEIGHT * 1/3 - tabbarHeight,
                                             self.playListView.frame.size.width,
                                             self.playListView.frame.size.height
                                             );
    } completion:^(BOOL finished) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSUInteger index = [appDelegate.jerryPlayer.playItemList indexOfObject:appDelegate.jerryPlayer.currentItem];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tablePlayList scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)playListHideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.playListView.frame = CGRectMake(
                                             self.playListView.frame.origin.x,
                                             SCREENHEIGHT,
                                             self.playListView.frame.size.width,
                                             self.playListView.frame.size.height
                                             );
    }];
}

#pragma mark 设置圆形封面图片
- (void)setCoverInDisk:(UIImage *) cover{
    self.coverImageView = [[UIImageView alloc] initWithImage:cover];
    [self.coverImageView setFrame:CGRectMake(7, 7, self.coverDiskImageView.frame.size.width - 14, self.coverDiskImageView.frame.size.height - 14)];
    self.coverImageView.layer.cornerRadius = self.coverImageView.frame.size.width / 2;//裁成圆角
    self.coverImageView.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    
    [self.coverDiskImageView addSubview:self.coverImageView];
}

#pragma mark 设置背景图（封面高斯模糊 + 20%黑色遮罩）
- (void)addBackgroundView:(UIImage *) coverImage {
    //高斯模糊
    UIImage *gaussianImage = [JerryViewTools coreBlurImage:coverImage withBlurNumber:20];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- (SCREENWIDTH/2 + 50), - (SCREENHEIGHT/2 + 50), 2 * (SCREENWIDTH + 50), 2 * (SCREENHEIGHT + 50))];
    [self.backgroundImageView setImage:gaussianImage];
    
    //黑色遮罩
    UIView *blackMaskView = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [blackMaskView setBackgroundColor:[UIColor blackColor]];
    [blackMaskView setAlpha:0.2];

    [self.backgroundImageView addSubview:blackMaskView];
    [self.view addSubview:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"播放";
}

#pragma mark 列表剩余空间遮罩
- (void)showPlayListMask{
    //添加遮罩层
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH,SCREENHEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.0f;
    [self.view addSubview:self.maskView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0.5f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 隐藏遮罩
- (void)hidePlayListMask{
    //隐藏遮罩
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayListViewCell *playListCell = [self.tablePlayList dequeueReusableCellWithIdentifier:self.playListTableCellID];
    
    playListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *playListArray = appDelegate.jerryPlayer.playItemList;
    NSDictionary *dataDic = [playListArray objectAtIndex:indexPath.row];
    
    playListCell.labelStoryName.text = [dataDic objectForKey:mainpage_column_category_story_name];
    
    if (appDelegate.jerryPlayer.currentItem == [appDelegate.jerryPlayer.playItemList objectAtIndex:indexPath.row]) {
        playListCell.labelStoryName.textColor = [UIColor orangeColor];
    }else{
        playListCell.labelStoryName.textColor = [UIColor blackColor];
    }
    
    return playListCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *playListArray = appDelegate.jerryPlayer.playItemList;
    NSUInteger count = [playListArray count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *selectedDic = [appDelegate.jerryPlayer.playItemList objectAtIndex:indexPath.row];
    
    
    [appDelegate.jerryPlayer prepareToPlayerAtCurrentItem:selectedDic];
    [appDelegate.jerryPlayer play];
    
    [self.tablePlayList reloadData];
    
    [self setGaosiBackgound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//******************** Play List View Operation **********************
#pragma mark - 播放列表view操作
#pragma mark 清除列表
- (void)clearPlayList{
    NSLog(@"clear play list ...");
}

#pragma mark 关闭
- (void)closePlayList{
    //缩回playListView
    [self playListHideAnimation];
    //去除遮罩
    [self hidePlayListMask];
}

- (void)playEnd{
    NSLog(@"in player controller");
}

- (void)playingStatus:(NSMutableDictionary *) status{
    NSLog(@"in player controller");
}
//********************************************************************

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
