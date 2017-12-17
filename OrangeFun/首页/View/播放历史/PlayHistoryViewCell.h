//
//  PlayHistoryViewCell.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/16.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayHistoryViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *storyCoverImageView;

@property (strong, nonatomic) IBOutlet UILabel *storyNameLabel;

@property (strong, nonatomic) IBOutlet UIButton *deleteItemBtn;

@end
