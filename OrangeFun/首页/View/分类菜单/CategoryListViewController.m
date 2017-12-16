//
//  CategoryListViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/9.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "CategoryListViewController.h"
#import "RequestURLHeader.h"
#import "ProjectHeader.h"
#import "BMRequestHelper.h"
#import "DiscoverTableCell.h"
#import "JerryViewTools.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface CategoryListViewController ()

@property (strong,nonatomic) NSString *discoverTableCellId;

@property (strong,nonatomic) NSArray *categoryListArray;

@end

@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *categoryName = [self.passDataDic objectForKey:mainpage_column_category_name];
    self.title = categoryName;
    
    self.catagoryListTable.delegate = self;
    self.catagoryListTable.dataSource = self;
    
    [self registerTableCell];
    
    [self loadData];
}

- (void)registerTableCell{
    self.discoverTableCellId = @"discoverTableCell";
    
    UINib *discoverTableCellNib = [UINib nibWithNibName:@"DiscoverTableCell" bundle:nil];
    [self.catagoryListTable registerNib:discoverTableCellNib forCellReuseIdentifier:self.discoverTableCellId];
}

- (void)loadData{
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    NSString *url_story_index = [NSString stringWithFormat:@"%@%@?seriaCategory=%@",URL_REQUEST_STORY,URL_REQUEST_STORY_GET_CATEGORY,[self.passDataDic objectForKey:mainpage_column_category_name]];
    NSLog(@"url_story_index = %@",url_story_index);
    
    [requestHelper getRequestAsynchronousToUrl:url_story_index andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            if (error.code == -1009) {
                //无网络
                [self toastText:@"无网络哎，先联网吧~"];
            }
        }else{
            if (data) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if (httpResponse.statusCode == 200) {
                    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    self.categoryListArray = dataArray;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        if ([self.categoryListArray count] > 0) {
                            //有数据
                            self.noSearchResultView.hidden = YES;
                            [self.catagoryListTable reloadData];
                        }else{
                            //无数据
                            self.noSearchResultView.hidden = NO;
                        }
                    });
                }else{
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    if (jsonDic) {
                        NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
                        if (errorCode) {
                            [self toastText:[jsonDic objectForKey:@"errorMsg"]];
                        }
                    }else{
                        [self toastText:@"数据出错"];
                    }
                }
            }else{
                [self toastText:@"数据出错"];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverTableCell *storyItemCell = [self.catagoryListTable dequeueReusableCellWithIdentifier:self.discoverTableCellId];
    //设置选中样式，无
    storyItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataItemDic = [self.categoryListArray objectAtIndex:indexPath.row];
    NSString *logoURLString = [dataItemDic objectForKey:@"logoUrl"];
    NSLog(@"logoURLString : %@",logoURLString);
    NSString *itemName = [dataItemDic objectForKey:@"seriaName"];
    //name
    storyItemCell.labelStoryName.text = itemName;
    //cover
    NSURL *coverURL = [NSURL URLWithString:logoURLString];
    
    [storyItemCell.imageViewCover sd_setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    
    storyItemCell.labelPlayTimes.hidden = YES;
    storyItemCell.btnAddToPlayList.hidden = YES;
    storyItemCell.imageViewPlayCount.hidden = YES;
    
    return storyItemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoryListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.categoryListArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dataMuta = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    [JerryViewTools jumpFrom:self ToViewController:viewcontroller_storylist carryDataDic:dataMuta];
}

#pragma mark toast提示
- (void)toastText:(NSString *) text{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [JerryViewTools showCZToastInViewController:self andText:text];
    });
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
