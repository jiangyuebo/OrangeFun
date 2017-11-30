//
//  CategoryStoryViewCell.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryStoryViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *categoryStoryCollectionView;

@property (strong,nonatomic) NSString *collectionCellId;


@end
