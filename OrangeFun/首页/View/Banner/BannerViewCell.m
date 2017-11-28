//
//  BannerViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BannerViewCell.h"
#import "globalHeader.h"
#import "ProjectHeader.h"

@implementation BannerViewCell

- (void)setBannerURLs:(NSMutableArray *) urlsArray{
    if (!urlsArray) {
        urlsArray = [NSMutableArray array];
    }
    
    if ([urlsArray count] < 1) {
        //添加占位图片
        UIImage *image = [UIImage imageNamed:@"banner"];
        for (int i = 0; i < 3; i++) {
            [urlsArray addObject:image];
        }
    }
    
    self.bannerScrollView.contentSize = CGSizeMake(SCREENWIDTH * urlsArray.count, 0);
    //开始插入图片
    for (int i = 0; i < [urlsArray count]; i++) {
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH/banner_width * banner_height)];
        [bannerImageView setImage:urlsArray[i]];
        [self.bannerScrollView addSubview:bannerImageView];
    }
    
    self.bannerScrollView.pagingEnabled = YES;
    self.bannerScrollView.delegate = self;
    //自动移动显示第一张图片
    [self.bannerScrollView setContentOffset:CGPointMake(SCREENWIDTH, 0) animated:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
