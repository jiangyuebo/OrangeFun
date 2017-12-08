//
//  CategoryStoryViewCell.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryStoryViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//专辑故事信息
@property (strong,nonatomic) NSString *seriaID;
@property (strong,nonatomic) NSString *seriaLogoURLString;

//分类块名称
@property (strong, nonatomic) IBOutlet UILabel *categoryName;

@property (strong, nonatomic) IBOutlet UICollectionView *categoryStoryCollectionView;

@property (strong,nonatomic) NSString *collectionCellId;

@property (strong,nonatomic) NSArray *collectionDataArray;

- (void)setCollectionData:(NSArray *) datas;

@end
