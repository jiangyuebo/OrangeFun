//
//  PlayViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "PlayViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "PlayListViewCell.h"

#define PlayListHeight SCREENHEIGHT * 2/3

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *testImage = [UIImage imageNamed:@"xiaozhu"];
    //背景
    [self addBackgroundView:testImage];
    
    [self initView];
}

- (void)viewDidLayoutSubviews{
    UIImage *testImage = [UIImage imageNamed:@"xiaozhu"];
    //封面
    [self setCoverInDisk:testImage];
}

#pragma mark 初始化一些view
- (void)initView{
    //设置自定义进度条
    UIImage *minImage = [[UIImage imageNamed:@"progress_orange"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    UIImage *maxImage = [[UIImage imageNamed:@"progress"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    [self.progressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"drag"] forState:UIControlStateNormal];
    
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
    UIImageView *coverImageView = [[UIImageView alloc] initWithImage:cover];
    [coverImageView setFrame:CGRectMake(7, 7, self.coverDiskImageView.frame.size.width - 14, self.coverDiskImageView.frame.size.height - 14)];
    coverImageView.layer.cornerRadius = coverImageView.frame.size.width / 2;//裁成圆角
    coverImageView.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    
    [self.coverDiskImageView addSubview:coverImageView];
}

#pragma mark 设置背景图（封面高斯模糊 + 20%黑色遮罩）
- (void)addBackgroundView:(UIImage *) coverImage {
    //高斯模糊
    UIImage *gaussianImage = [JerryViewTools coreBlurImage:coverImage withBlurNumber:20];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- SCREENWIDTH/2, - SCREENHEIGHT/2, 2 * SCREENWIDTH, 2 * SCREENHEIGHT)];
    [backgroundImageView setImage:gaussianImage];
    
    //黑色遮罩
    UIView *blackMaskView = [[UIView alloc] initWithFrame:backgroundImageView.frame];
    [blackMaskView setBackgroundColor:[UIColor blackColor]];
    [blackMaskView setAlpha:0.2];

    [backgroundImageView addSubview:blackMaskView];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
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
    
    return playListCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
