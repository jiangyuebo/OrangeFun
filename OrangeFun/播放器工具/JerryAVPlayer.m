//
//  JerryAVPlayer.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JerryAVPlayer.h"
#import "ProjectHeader.h"
#import "JerryTools.h"

@interface JerryAVPlayer()

@property (strong,nonatomic) id timeObserver;

@end

@implementation JerryAVPlayer

#pragma mark 设置播放列表
- (void)setPlayerItemList:(NSMutableArray *) playItemList{
    _playItemList = playItemList;
}

#pragma mark 添加播放曲目
- (void)addPlayItemToList:(NSDictionary *) itemDic{
    //清除原播放内容
    [_playItemList removeAllObjects];
    [_playItemList addObject:itemDic];
}

#pragma mark 添加播放曲目列表
- (void)addSeriaPlayItemToList:(NSArray *) itemArray{
    [_playItemList removeAllObjects];
    [_playItemList addObjectsFromArray:itemArray];
}

- (void)prepareToPlayer{
    //判断播放列表是否已设置
    if (_playItemList) {
        if ([_playItemList count] < 1) {
            NSLog(@"请添加播放条目");
        }else{
            //获取第一个播放条目URL
            NSDictionary *dataDic = [_playItemList objectAtIndex:0];
            self.currentItem = dataDic;
            
            NSString *urlStr = [dataDic objectForKey:mainpage_column_category_story_playURL];
            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
            
            if (_player) {
                [self unregisterPlayItemObserver];
                [_player replaceCurrentItemWithPlayerItem:item];
            }else{
                _player = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayAndRecord
                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                           error:nil];
            
            if (@available(iOS 10.0, *)) {
                [_player setAutomaticallyWaitsToMinimizeStalling:NO];
            } else {
                // Fallback on earlier versions
            }
            
            //添加播放完成状体监听
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
            NSLog(@"player初始化完成");
        }
    }else{
        NSLog(@"请传入播放列表对象");
    }
}

- (void)prepareToPlayerAtCurrentItem:(NSDictionary *) currentDic{
    //判断播放列表是否已设置
    if (_playItemList) {
        if ([_playItemList count] < 1) {
            NSLog(@"请添加播放条目");
        }else{
            //获取第一个播放条目URL
            NSDictionary *dataDic = currentDic;
            self.currentItem = dataDic;
            
            NSString *urlStr = [dataDic objectForKey:mainpage_column_category_story_playURL];
            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
            
            if (_player) {
                [self unregisterPlayItemObserver];
                [_player replaceCurrentItemWithPlayerItem:item];
            }else{
                _player = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayAndRecord
                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                           error:nil];
            
            if (@available(iOS 10.0, *)) {
                [_player setAutomaticallyWaitsToMinimizeStalling:NO];
            } else {
                // Fallback on earlier versions
            }
            
            //添加播放完成状体监听
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
            NSLog(@"player初始化完成");
        }
    }else{
        NSLog(@"请传入播放列表对象");
    }
}

#pragma mark 播放
- (void)play{
    
    self.isPlaying = YES;
    
    [self registerPlayItemObserver];
    
    __weak typeof(self) weakSelf = self;
    
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (current) {
            NSMutableDictionary *playTimeDic = [NSMutableDictionary dictionary];
            NSNumber *currentN = [NSNumber numberWithFloat:current];
            NSNumber *totalN = [NSNumber numberWithFloat:total];
            
            weakSelf.currentTime = current;
            weakSelf.totalTime = total;
            
            [playTimeDic setObject:currentN forKey:@"current"];
            [playTimeDic setObject:totalN forKey:@"total"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"player" object:@"player" userInfo:playTimeDic];
        }
    }];
}

#pragma makr 上一首
- (void)previous{
    if (self.playItemList) {
        if ([self.playItemList count] > 1) {
            //获取当前index
            NSUInteger currentIndex = [self.playItemList indexOfObject:self.currentItem];
            if (currentIndex > 0) {
                [self prepareToPlayerAtCurrentItem:[self.playItemList objectAtIndex:currentIndex - 1]];
                [self play];
            }
        }
    }
}

#pragma mark 下一首
- (void)next{
    if (self.playItemList) {
        if ([self.playItemList count] > 1) {
            NSUInteger currentIndex = [self.playItemList indexOfObject:self.currentItem];
            NSUInteger max = [self.playItemList count] - 1;
            if (currentIndex < max) {
                [self prepareToPlayerAtCurrentItem:[self.playItemList objectAtIndex:currentIndex + 1]];
                [self play];
            }
        }
    }
}

- (void)continuePlay{
    [_player play];
    self.isPlaying = YES;
}

#pragma mark 暂停播放
- (void)pausePlay{
    [_player pause];
    
    self.isPlaying = NO;
}

#pragma mark 播放完成
- (void)playFinished:(AVPlayerItem *) playItem{
    [self.jerryDelegate playEnd];
    
    self.isPlaying = NO;
    NSLog(@"播放完成");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playstatus" object:nil userInfo:nil];
}

#pragma mark 切换当前播放条目到指定条目
- (void)switchPlayItemAtIndex:(NSUInteger) itemIndex{
    //创建需要播放的item
    if (self.playItemList && [self.playItemList count] > 0) {
        NSDictionary *itemDic = [_playItemList objectAtIndex:itemIndex];
        self.currentItem = itemDic;
        
        NSString *urlStr = [self.currentItem objectForKey:mainpage_column_category_story_playURL];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
        
        [self unregisterPlayItemObserver];
        
        [_player replaceCurrentItemWithPlayerItem:item];
        
        //
        self.currentItem = [self.playItemList objectAtIndex:itemIndex];
        
        
    }
}

#pragma mark 定位时间播放
- (void)jumpTimePlay:(float) time{
    //通过slider的sender计算时间
    //float time = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
    [_player seekToTime:CMTimeMake(time, 1)];
}

//*********************************播放器状态监听*****************************************
#pragma mark 注册KVO监听item的播放状态
- (void)registerPlayItemObserver{
    //监听播放区状态
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听音乐缓冲进度
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark 移除观察者。在播放完成或切换播放
- (void)unregisterPlayItemObserver{
    //移除播放器状态监听
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    //移除音乐缓冲进度监听
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //移除播放进度监听
    if (_timeObserver) {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

#pragma mark KVO监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //播放器状态
    if ([keyPath isEqualToString:@"status"]) {
        switch (_player.status) {
            case AVPlayerStatusReadyToPlay:
                NSLog(@"播放功能就绪");
                if (_player) {
                    [_player play];
                }
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败");
                break;
            default:
                break;
        }
    }
    //缓冲进度
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = _player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(_player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        NSLog(@"当前缓冲进度：%f",scale);
    }
}
//*****************************************************************************************



@end
