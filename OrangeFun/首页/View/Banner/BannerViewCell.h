//
//  BannerViewCell.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerViewCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *bannerScrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControlBanner;
//记录LINK以供点击事件调用
@property (strong,nonatomic) NSMutableArray *bannerLinkURLArray;

@property (strong,nonatomic) NSArray *bannerDataArray;

- (void)reloadBannerData;

@end
