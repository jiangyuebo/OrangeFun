//
//  PlayViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController

//进度条
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

//左时间
@property (strong, nonatomic) IBOutlet UILabel *progressTime;

//右时间
@property (strong, nonatomic) IBOutlet UILabel *totalTime;

//封面背景
@property (strong, nonatomic) IBOutlet UIImageView *coverDiskImageView;

//播放、暂停按钮
@property (strong, nonatomic) IBOutlet UIButton *playControlButton;

//上一首
@property (strong, nonatomic) IBOutlet UIButton *prevButton;

//下一首
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
