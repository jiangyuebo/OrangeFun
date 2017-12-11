//
//  JerryAVPlayer.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JerryAVPlayerDelegate.h"

@interface JerryAVPlayer : NSObject


@property (nonatomic) id<JerryAVPlayerDelegate> jerryDelegate;
//播放器实例
@property (strong,nonatomic) AVPlayer *player;
//播放列表
@property (strong,nonatomic) NSMutableArray *playItemList;

//当前播放
@property (strong,nonatomic) NSDictionary *currentItem;

@property (nonatomic) BOOL isPlaying;

#pragma mark step1 : 设置播放列表,list中存储URL字符串
- (void)setPlayerItemList:(NSMutableArray *) playItemList;
#pragma mark 添加播放曲目 单曲
- (void)addPlayItemToList:(NSDictionary *) itemDic;

#pragma mark 添加播放曲目列表
- (void)addSeriaPlayItemToList:(NSArray *) itemArray;

#pragma mark step2 : 获得播放器对象
- (void)prepareToPlayer;

- (void)prepareToPlayerAtCurrentItem:(NSDictionary *) currentDic;

#pragma mark 播放
- (void)play;

#pragma mark 继续播放（不重新注册监听）
- (void)continuePlay;

#pragma mark 暂停播放
- (void)pausePlay;

#pragma makr 上一首
- (void)previous;

#pragma mark 下一首
- (void)next;

#pragma mark 切换当前播放条目到指定条目
- (void)switchPlayItemAtIndex:(NSUInteger) itemIndex;

#pragma mark 定位时间播放
- (void)jumpTimePlay:(float) time;

@end
