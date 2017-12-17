//
//  HistoryTool.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/16.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "HistoryTool.h"
#import "JerryTools.h"
#import "ProjectHeader.h"

@implementation HistoryTool

+ (void)saveDataItem:(NSDictionary *) dataDic{
    NSArray *historyDicArray = (NSArray *)[JerryTools readInfo:storage_key_played_history];
    if (!historyDicArray) {
        historyDicArray = [NSArray array];
    }
    
    NSMutableArray *operationArray = [NSMutableArray arrayWithArray:historyDicArray];
    //判断是否包含该节目
    NSString *storyName = [dataDic objectForKey:@"storyName"];
    
    //已包含该记录，将其位置移动到最前
    for (int i = 0; i < [operationArray count]; i++) {
        NSDictionary *dataDic = operationArray[i];
        NSString *storyNameInArray = [dataDic objectForKey:@"storyName"];
        if ([storyName isEqualToString:storyNameInArray]) {
            //重了
            [operationArray removeObject:dataDic];
        }
    }

    [operationArray insertObject:dataDic atIndex:0];
    
    [JerryTools saveInfo:operationArray name:storage_key_played_history];
}

#pragma mark 读取播放历史记录
+ (NSArray *)readHistoryDataArray{
    NSArray *historyDicArray = (NSArray *)[JerryTools readInfo:storage_key_played_history];
    if (!historyDicArray) {
        historyDicArray = [NSArray array];
    }
    return historyDicArray;
}

#pragma mark 覆盖历史记录
+ (void)refreshHistoryDataArray:(NSMutableArray *) dataArray{
    [JerryTools saveInfo:dataArray name:storage_key_played_history];
}

@end
