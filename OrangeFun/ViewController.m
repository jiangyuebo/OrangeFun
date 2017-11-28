//
//  ViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "JerryAVPlayer.h"
#import "BMRequestHelper.h"
#import "RequestURLHeader.h"

@interface ViewController ()

@property(strong,nonatomic) JerryAVPlayer *player;

@end

@implementation ViewController

- (IBAction)playTest:(UIButton *)sender {
    NSLog(@"start play");
    
//    NSString *itemURLStr = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
    
    NSString *itemURLStr = @"http://sc1.111ttt.com/2017/1/05/09/298092042172.mp3";
    
    //准备播放内容
    NSMutableArray *playItemArray = [NSMutableArray array];
    [playItemArray addObject:itemURLStr];

    _player = [[JerryAVPlayer alloc] init];
    [_player setPlayItemList:playItemArray];
    [_player prepareToPlayer];
    

//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:itemURLStr]];
//    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
//    [player play];
    
    //网络测试
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index = [NSString stringWithFormat:@"%@%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_INDEX];
    NSLog(@"url_story_index : %@",url_story_index);
    [requestHelper getRequestAsynchronousToUrl:url_story_index andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (jsonDic) {
                
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
