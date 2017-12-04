//
//  DiscoverViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/24.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableCell.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableDiscover.delegate = self;
    self.tableDiscover.dataSource = self;
    
    //注册cell
    [self registNibForTable];
}

#pragma mark 为首页table注册cell ui
- (void)registNibForTable{
    self.storyCellID = @"storyCellID";
    
    UINib *discoverTableCellNib = [UINib nibWithNibName:@"DiscoverTableCell" bundle:nil];
    [self.tableDiscover registerNib:discoverTableCellNib forCellReuseIdentifier:self.storyCellID];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"发现";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableCell *storyItemCell = [self.tableDiscover dequeueReusableCellWithIdentifier:self.storyCellID];
    
    [storyItemCell.imageViewCover setImage:[UIImage imageNamed:@"xiaozhu"]];
    
    return storyItemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
