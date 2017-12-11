//
//  PlayViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JerryAVPlayerDelegate.h"

@interface PlayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,JerryAVPlayerDelegate>

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

//列表剩余空间遮罩
@property (strong,nonatomic) UIView *maskView;
//列表view
@property (strong,nonatomic) UIView *playListView;
//列表中table
@property (strong,nonatomic) UITableView *tablePlayList;
@property (strong,nonatomic) NSString *playListTableCellID;

@end
