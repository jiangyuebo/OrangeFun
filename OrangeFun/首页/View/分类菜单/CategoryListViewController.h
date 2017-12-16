//
//  CategoryListViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *catagoryListTable;

@property (strong, nonatomic) IBOutlet UIView *noSearchResultView;

@property (strong,nonatomic) NSMutableDictionary *passDataDic;

@end
