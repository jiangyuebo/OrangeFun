//
//  DiscoverTableCell.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewCover;

@property (strong, nonatomic) IBOutlet UILabel *labelStoryName;

@property (strong, nonatomic) IBOutlet UILabel *labelPlayTimes;

@property (strong, nonatomic) IBOutlet UIButton *btnAddToPlayList;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewPlayCount;

@property (strong, nonatomic) IBOutlet UIWebView *webViewGif;



@end
