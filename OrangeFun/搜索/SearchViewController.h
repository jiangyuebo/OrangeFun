//
//  SearchViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@property (strong, nonatomic) IBOutlet UIView *noResultView;

@property (strong, nonatomic) IBOutlet UIButton *historyClearBtn;

@end
