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
    //进度条设置
    UIImage *minImage = [[UIImage imageNamed:@"progress_orange"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    UIImage *maxImage = [[UIImage imageNamed:@"progress"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    [self.progressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"drag"] forState:UIControlStateNormal];
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
