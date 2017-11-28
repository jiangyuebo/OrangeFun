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

- (void)setBannerURLs:(NSMutableArray *) urlsArray;

@end
