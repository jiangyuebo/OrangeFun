//
//  AppDelegate.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化播放器
    self.jerryPlayer = [[JerryAVPlayer alloc] init];
    //初始化播放列表
    self.jerryPlayer.playItemList = [NSMutableArray array];
    
    return YES;
}

UIBackgroundTaskIdentifier _bgTaskId;
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive ...");
    //开启后台处理
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    _bgTaskId = [AppDelegate backgroundPlayerID:_bgTaskId];
    
}

//实现一下backgroundPlayerID:这个方法:
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive ...");
    if (self.jerryPlayer.isPlaying) {
        NSLog(@"end background task ...");
//        [[UIApplication sharedApplication] endBackgroundTask:self.jerryPlayer.newTaskId];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"播放...");
                [self.jerryPlayer continuePlay];
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"暂停...");
                [self.jerryPlayer pausePlay];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首");
                [self.jerryPlayer previous];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                [self.jerryPlayer next];
                break;
                
            default:
                break;
        }
        
    }
}


@end
