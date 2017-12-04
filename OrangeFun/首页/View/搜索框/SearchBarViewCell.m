//
//  SearchBarViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SearchBarViewCell.h"
#import "ProjectHeader.h"
#import "JerryViewTools.h"

@implementation SearchBarViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *searchBgImage = [UIImage imageNamed:@"searchbg"];
    UIImage *resizeBgImage = [searchBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 18)];
    [self.searchImageView setImage:resizeBgImage];
    
    //对搜索框图片添加点击事件
    self.searchImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarClicked)];
    [self.searchImageView addGestureRecognizer:singleTap];
}

#pragma mark 点击搜索框
- (void)searchBarClicked{
    UIViewController *currentVC = [JerryViewTools topViewController];
    [JerryViewTools jumpFrom:currentVC ToViewController:viewcontroller_search];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
