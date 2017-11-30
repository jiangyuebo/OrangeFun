//
//  CategoryStoryViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "CategoryStoryViewCell.h"
#import "CategoryStoryCollectionCell.h"

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

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryStoryCollectionCell *collectionCell = [self.categoryStoryCollectionView dequeueReusableCellWithReuseIdentifier:self.collectionCellId forIndexPath:indexPath];
    
    UIImage *exampleCoverImage = [UIImage imageNamed:@"xiaozhu"];
    [collectionCell.coverImageView setImage:exampleCoverImage];
    
    return collectionCell;
}

//total count
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 130);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
