//
//  CategoryStoryViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "CategoryStoryViewCell.h"
#import "CategoryStoryCollectionCell.h"
#import "ProjectHeader.h"
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
    
    //播放地址
//    NSString *storyPlayURLString = [storyDataDic objectForKey:mainpage_column_category_story_playURL];
    
    //设置封面图片
    NSURL *coverImageURL = [NSURL URLWithString:logoURLString];
    [collectionCell.coverImageView sd_setImageWithURL:coverImageURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
    //设置故事名
    collectionCell.storyName.text = storyName;
    
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
    
    return CGSizeMake(90, 130);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
