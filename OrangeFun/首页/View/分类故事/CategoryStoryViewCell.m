//
//  CategoryStoryViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "CategoryStoryViewCell.h"
#import "CategoryStoryCollectionCell.h"
#import "AppDelegate.h"
#import "globalHeader.h"
#import "ProjectHeader.h"
#import "JerryViewTools.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CategoryStoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.categoryStoryCollectionView.delegate = self;
    self.categoryStoryCollectionView.dataSource = self;
    
    //注册collection cell
    self.collectionCellId = @"collectionCellId";
    //加载xib页面
    UINib *collectionCellNib = [UINib nibWithNibName:@"CategoryStoryCollectionCell" bundle:nil];
    //注册单元格
    [self.categoryStoryCollectionView registerNib:collectionCellNib forCellWithReuseIdentifier:self.collectionCellId];
}

- (void)setCollectionData:(NSArray *) datas{
    self.collectionDataArray = datas;
}

- (IBAction)btnMoreAction:(UIButton *)sender {
    
    NSLog(@"seriaID : %@",self.seriaID);
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:@"more" forKey:@"type"];
    if (self.seriaID) {
        [dataDic setObject:self.seriaID forKey:@"seriaID"];
    }else{
        [dataDic setObject:@"" forKey:@"seriaID"];
    }
    [dataDic setObject:self.categoryName.text forKey:@"categoryName"];

    [JerryViewTools jumpFrom:[JerryViewTools topViewController] ToViewController:viewcontroller_storylist carryDataDic:dataDic];
}

#pragma mark 点击故事
- (void)storyClickedAction:(UIGestureRecognizer *)sender{
    UIImageView *storyCoverImageView = (UIImageView *)sender.view;
    NSUInteger tag = storyCoverImageView.tag;
    
    NSLog(@"collectionDataArray : %@",self.collectionDataArray);
    
    //获取待播放对象
    NSDictionary *storyDataDic = [self.collectionDataArray objectAtIndex:tag];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.jerryPlayer addSeriaPlayItemToList:self.collectionDataArray];
    
    [appDelegate.jerryPlayer prepareToPlayerAtCurrentItem:storyDataDic];
    
    [appDelegate.jerryPlayer play];
    
    //跳转到播放页
    UIViewController *topViewController = [JerryViewTools topViewController];
    [topViewController.navigationController setNavigationBarHidden:YES animated:NO];
    
    [JerryViewTools jumpFrom:topViewController ToViewController: viewcontroller_playview];
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryStoryCollectionCell *collectionCell = [self.categoryStoryCollectionView dequeueReusableCellWithReuseIdentifier:self.collectionCellId forIndexPath:indexPath];
    
    //解析数据
    NSDictionary *storyDataDic = [self.collectionDataArray objectAtIndex:indexPath.row];
    
    //获取故事封面地址
    NSString *logoURLString = [storyDataDic objectForKey:mainpage_column_category_logoURL];
    
    //获取故事名称
    NSString *storyName = [storyDataDic objectForKey:mainpage_column_category_story_name];
    //设置故事名
    collectionCell.storyName.text = storyName;
    
    //设置封面图片
    NSURL *coverImageURL = [NSURL URLWithString:logoURLString];
    [collectionCell.coverImageView sd_setImageWithURL:coverImageURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    collectionCell.coverImageView.tag = indexPath.row;
    
    //设置点击事件
    collectionCell.coverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyClickedAction:)];
    [collectionCell.coverImageView addGestureRecognizer:singleTap];
    
    return collectionCell;
}

//total count
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([self.collectionDataArray  count] > 0) {
        //真实数据
        return [self.collectionDataArray count];
    }else{
        //占位
        return 6;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"screen width : %f",SCREENWIDTH);
    
    CGFloat width = SCREENWIDTH / 3 - 20;
    CGFloat height = 130 * width / 90;
    return CGSizeMake(width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
