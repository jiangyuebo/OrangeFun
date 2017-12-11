//
//  JerryAVPlayerDelegate.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JerryAVPlayerDelegate

- (void)playEnd;
- (void)playingStatus:(NSMutableDictionary *) status;

@end
