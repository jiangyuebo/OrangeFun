//
//  SearchDisplayViewController.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/12.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDisplayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableDictionary *passDataDic;

@property (strong, nonatomic) IBOutlet UITableView *searchResultTable;

@property (strong, nonatomic) IBOutlet UILabel *resulText;


@end
