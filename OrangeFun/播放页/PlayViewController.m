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
#import "UIColor+NSString.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#define PlayListHeight SCREENHEIGHT * 2/3

@interface PlayViewController ()

@property (strong,nonatomic) UIImageView *backgroundImageView;

@property (strong,nonatomic) UIImageView *coverImageView;

@property (strong,nonatomic) NSNumber *totalTimeNumber;

@property (strong,nonatomic) UIImage *currentCoverImage;


@property (strong,nonatomic) CABasicAnimation *coverAnimation;

@property (assign,nonatomic) BOOL pauseStatusWhenIn;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [self initView];
    
    //广播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"player" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingFinish) name:notification_key_play_finished object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForegroundMode) name:notification_key_become_foreground object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 播放完成监听
- (void)playingFinish{
    [self nextAction:nil];
}

- (void)becomeForegroundMode{
    [self initPlayView];
}

#pragma mark 播放暂停按钮点击
- (IBAction)controlBtnAction:(UIButton *)sender {
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.jerryPlayer.currentItem) {
        BOOL isPlaying = appDelegate.jerryPlayer.isPlaying;
        
        if (isPlaying) {
            //正在播放，暂停
            [appDelegate.jerryPlayer pausePlay];
            [self setControlPlaying];
            
            //获取到当前view时间
            CFTimeInterval currTimeoffset = [self.coverDiskImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
            self.coverDiskImageView.layer.speed = 0.0;
            self.coverDiskImageView.layer.timeOffset = currTimeoffset;
        }else{
            //未播放，开始
            [appDelegate.jerryPlayer continuePlay];
            [self setControlStop];
            
            [self continueCoverAnimation];
        }
    }
}

- (void)startCoverAnimation{
    NSLog(@"创建动画.....(startCoverAnimation)");
    self.coverAnimation = [JerryViewTools startRotationAnimationWithView:self.coverDiskImageView];
}

#pragma mark 封面动画继续转动
- (void)continueCoverAnimation{
    
    if (self.pauseStatusWhenIn) {
        //
        NSLog(@"创建动画.....(continueCoverAnimation)");
        self.coverAnimation = [JerryViewTools startRotationAnimationWithView:self.coverDiskImageView];
        self.pauseStatusWhenIn = NO;
    }
    
    //继续动画
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = self.coverDiskImageView.layer.timeOffset;
    
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    
    [self.coverDiskImageView.layer setTimeOffset:0];
    [self.coverDiskImageView.layer setBeginTime:begin];
    
    self.coverDiskImageView.layer.speed = 1.0;
}

- (IBAction)previousAction:(UIButton *)sender {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.jerryPlayer.currentItem) {
        [appDelegate.jerryPlayer previous];
        
        [self.tablePlayList reloadData];
        [self setControllerBackgound];
        [self setControlStop];
    }
}

- (IBAction)nextAction:(UIButton *)sender {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.jerryPlayer.currentItem) {
        NSLog(@"next in PlayViewController ... ");
        [appDelegate.jerryPlayer next];
        
        [self.tablePlayList reloadData];
        [self setControllerBackgound];
        [self setControlStop];
    }
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setControlPlaying{
    [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"btnPlay"] forState:UIControlStateNormal];
}

- (void)setControlStop{
    [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"btnStop"] forState:UIControlStateNormal];
}


float fromValue = 0.0f;
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

    //旋转动画
//    [UIView animateWithDuration:2.0f animations:^{
//        CGAffineTransform currentTransform = self.coverDiskImageView.transform;
//        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/10); // 在现在的基础上旋转指定角度
//        self.coverDiskImageView.transform = newTransform;
//    }];
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
    
    [self initPlayView];
}

- (void)initPlayView{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.jerryPlayer.jerryDelegate = self;
    
    [self.tablePlayList reloadData];
    
    [self setControllerBackgound];
    
    //播放按钮
    if (appDelegate.jerryPlayer.isPlaying) {
        [self setControlStop];
    }else{
        [self setControlPlaying];
    }
    
    if ([JerryViewTools isTopViewContoller:self]) {
        //是第一层级
        self.backBtn.hidden = YES;
    }else{
        self.backBtn.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 设置背景模糊图片
- (void)setControllerBackgound{
    //当前故事
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *item = appDelegate.jerryPlayer.currentItem;
    
    //判断当前是否有故事在播放
    if (item) {
        //故事名
        NSString *storyName = [item objectForKey:mainpage_column_category_story_name];
        self.storyNameLabel.text = storyName;
        
        NSString *logoURLString = [item objectForKey:mainpage_column_category_logoURL];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:logoURLString] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.currentCoverImage = image;
            
            //背景
            [self.backgroundImageView removeFromSuperview];
            [self addBackgroundView:image];
            
            [self.coverImageView removeFromSuperview];
            [self setCoverInDisk:image];
            
            [self continueCoverAnimation];
        }];
        
        self.progressSlider.enabled = YES;
        self.playControlButton.enabled = YES;
        self.prevButton.enabled = YES;
        self.nextButton.enabled = YES;
    }else{
        //无故事播放
        //默认背景图片
        UIImage *defautBackgroundImage = [UIImage imageNamed:@"default-bg"];
        //默认封面图片
        UIImage *defautCoverImage = [UIImage imageNamed:@"default-logo"];
        
        if (self.backgroundImageView) {
            [self.backgroundImageView removeFromSuperview];
            [self addBackgroundView:defautBackgroundImage];
        }else{
            [self addBackgroundView:defautBackgroundImage];
        }
        
        if (self.coverImageView) {
            [self.coverImageView removeFromSuperview];
            [self setCoverInDisk:defautCoverImage];
        }else{
            [self setCoverInDisk:defautCoverImage];
        }
        
        self.progressSlider.enabled = NO;
        self.playControlButton.enabled = NO;
        self.prevButton.enabled = NO;
        self.nextButton.enabled = NO;
    }
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.jerryPlayer.isPlaying) {
        NSLog(@"创建动画/.....");
        [self startCoverAnimation];
    }else{
        self.pauseStatusWhenIn = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    
    //增加点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePlayList)];
    [self.maskView addGestureRecognizer:singleTap];
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
    
    [self setControllerBackgound];
    
    [self setControlStop];
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

//- (void)configNowPlayingCenter {
//    NSLog(@"锁屏设置");
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *currentItemDic = appDelegate.jerryPlayer.currentItem;
//    // BASE_INFO_FUN(@"配置NowPlayingCenter");
//    NSMutableDictionary * info = [NSMutableDictionary dictionary];
//    //音乐的标题
//    [info setObject:[currentItemDic objectForKey:mainpage_column_category_story_name] forKey:MPMediaItemPropertyTitle];
//    //音乐的艺术家
//    NSString *author= @"橙娃";
//    [info setObject:author forKey:MPMediaItemPropertyArtist];
//    //音乐的播放时间
//    [info setObject:@(appDelegate.jerryPlayer.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    //音乐的播放速度
//    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
//    //音乐的总时间
//    [info setObject:@(appDelegate.jerryPlayer.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];
//    //音乐的封面
//    if (self.currentCoverImage) {
//        MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:self.currentCoverImage];
//        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
//    }
//    
//    //完成设置
//    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
