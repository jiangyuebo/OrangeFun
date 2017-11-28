//
//  JerryAVPlayer.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

//http://media.youban.com/gsmp3/mqualityt300/1294393922533972933.mp3

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JerryAVPlayer : NSObject

//播放器实例
@property (strong,nonatomic) AVPlayer *player;
//播放列表
@property (strong,nonatomic) NSMutableArray *playItemList;

#pragma mark step1 : 设置播放列表,list中存储URL字符串
- (void)setPlayerItemList:(NSMutableArray *) playItemList;
#pragma mark step2 : 获得播放器对象
- (void)prepareToPlayer;

#pragma mark 播放
- (void)play;

#pragma mark 暂停播放
- (void)pausePlay;

#pragma mark 切换当前播放条目到指定条目
- (void)switchPlayItemAtIndex:(NSUInteger) itemIndex;

#pragma mark 定位时间播放
- (void)jumpTimePlay:(float) time;

@end
