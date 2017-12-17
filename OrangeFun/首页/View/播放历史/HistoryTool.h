//
//  HistoryTool.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/16.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryTool : NSObject

#pragma mark 存储该节目到历史记录
+ (void)saveDataItem:(NSDictionary *) dataDic;

#pragma mark 读取播放历史记录
+ (NSArray *)readHistoryDataArray;

#pragma mark 覆盖历史记录
+ (void)refreshHistoryDataArray:(NSMutableArray *) dataArray;

@end
