//
//  StoryListViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/5.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableDictionary *passDataDic;

@property (strong, nonatomic) IBOutlet UITableView *storyListTable;

@property (strong, nonatomic) IBOutlet UILabel *storyCountLabel;

@property (strong,nonatomic) NSString *storyCellId;

@end
