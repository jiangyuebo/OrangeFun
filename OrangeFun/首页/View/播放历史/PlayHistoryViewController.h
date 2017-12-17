//
//  PlayHistoryViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/16.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *clearAllHistoryBtn;

@property (strong, nonatomic) IBOutlet UIView *noResultView;

@property (strong, nonatomic) IBOutlet UITableView *playedHistoryTable;

@end
