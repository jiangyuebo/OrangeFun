//
//  DiscoverViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableDiscover;

@property (strong,nonatomic) NSString *storyCellID;

@end
