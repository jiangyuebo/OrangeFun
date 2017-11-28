//
//  SearchBarViewCell.m
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SearchBarViewCell.h"

@implementation SearchBarViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *searchBgImage = [UIImage imageNamed:@"searchbg"];
    UIImage *resizeBgImage = [searchBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 18)];
    [self.searchImageView setImage:resizeBgImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
