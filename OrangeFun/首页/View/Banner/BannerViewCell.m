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

- (void)setBannerDatas:(NSArray *) urlsArray{
    
    if (!urlsArray) {
        self.initFlag = YES;
        //如果为空，添加占位图片
        UIImage *image = [UIImage imageNamed:@"banner"];
        urlsArray = [NSArray arrayWithObjects:image,image,image, nil];
    }else{
        self.initFlag = NO;
        self.bannerLinkURLArray = [NSMutableArray array];
    }

    self.bannerScrollView.contentSize = CGSizeMake(SCREENWIDTH * urlsArray.count, 0);

    //开始插入图片
    for (int i = 0; i < [urlsArray count]; i++) {
        
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH/banner_width * banner_height)];
        bannerImageView.tag = i;
        
        if (self.initFlag) {
            //初始化占位图片
            [bannerImageView setImage:urlsArray[i]];
        }else{
            //网络加载图片
            //获取banner对象
            NSDictionary *bannerDataItem = urlsArray[i];
            //活动链接
            NSString *bannerURL = [bannerDataItem objectForKey:@"bannerUrl"];
            [self.bannerLinkURLArray addObject:bannerURL];
            //图片地址
            NSString *logoURL = [bannerDataItem objectForKey:@"logoUrl"];
            NSURL *logoImageURL = [NSURL URLWithString:logoURL];
            //获取网络图片
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:logoImageURL]];
//
//                [bannerImageView setImage:bannerImage];
//            });
            [bannerImageView sd_setImageWithURL:logoImageURL];
            
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
    self.pageControlBanner.numberOfPages = [urlsArray count];
    self.pageControlBanner.hidesForSinglePage = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark banner图片点击
- (void)bannerClickedAction:(UIGestureRecognizer *)gestureRecognizer{
    UIImageView *clickedImageView = (UIImageView *)gestureRecognizer.view;
    //获取链接URL
    NSString *urlString = [self.bannerLinkURLArray objectAtIndex:clickedImageView.tag];
    NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
    [passDic setObject:urlString forKey:key_banner_link];
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
