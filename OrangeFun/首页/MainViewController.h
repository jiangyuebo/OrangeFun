//
//  MainViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//首页布局列表
@property (strong, nonatomic) IBOutlet UITableView *mainPageTable;

@end
