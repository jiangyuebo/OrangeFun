//
//  BannerViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "BannerViewCell.h"
#import "JerryViewTools.h"
#import "globalHeader.h"
#import "ProjectHeader.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation BannerViewCell

- (void)reloadBannerData{
    
    self.bannerScrollView.contentSize = CGSizeMake(SCREENWIDTH * self.bannerDataArray.count, 0);
    
    //开始插入图片
    for (int i = 0; i < [self.bannerDataArray count]; i++) {
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH/banner_width * banner_height)];
        bannerImageView.tag = i;
        
        NSDictionary *bannerDataDic = [self.bannerDataArray objectAtIndex:i];
        NSString *logoURL = [bannerDataDic objectForKey:mainpage_column_banner_logoURL];
        if ([logoURL isEqualToString:@""]) {
            //初始化的
            UIImage *noBannerImage = [UIImage imageNamed:@"nobanner"];
            [bannerImageView setImage:noBannerImage];
        }else{
            //网络加载图片
            //获取banner对象
            NSDictionary *bannerDataItem = self.bannerDataArray[i];
            
            //图片地址
            NSString *logoURL = [bannerDataItem objectForKey:mainpage_column_banner_logoURL];
            NSURL *logoImageURL = [NSURL URLWithString:logoURL];
            //获取网络图片
            [bannerImageView sd_setImageWithURL:logoImageURL placeholderImage:[UIImage imageNamed:@"nobanner"]];
            
            //添加点击事件
            bannerImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClickedAction:)];
            [bannerImageView addGestureRecognizer:singleTap];
        }
        
        [self.bannerScrollView addSubview:bannerImageView];
    }
    
    self.bannerScrollView.pagingEnabled = YES;
    self.bannerScrollView.delegate = self;
    //自动移动显示第一张图片
    [self.bannerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    //设置page control
    self.pageControlBanner.currentPage = 0;
    self.pageControlBanner.numberOfPages = [self.bannerDataArray count];
    self.pageControlBanner.hidesForSinglePage = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark banner图片点击
- (void)bannerClickedAction:(UIGestureRecognizer *)sender{
    UIImageView *clickedImageView = (UIImageView *)sender.view;
    NSUInteger tag = clickedImageView.tag;
    //获取链接URL
    NSDictionary *bannerDataDic = [self.bannerDataArray objectAtIndex:tag];
    //活动链接
    NSString *bannerURLString = [bannerDataDic objectForKey:mainpage_column_banner_bannerURL];
    
    NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
    [passDic setObject:bannerURLString forKey:key_banner_link];
    //跳转到web view
    [JerryViewTools jumpFrom:[JerryViewTools topViewController] ToViewController:viewcontroller_webview carryDataDic:passDic];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat bannerWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - bannerWidth / 2) / bannerWidth) + 1;
    self.pageControlBanner.currentPage = currentPage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
