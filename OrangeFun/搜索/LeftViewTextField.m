//
//  LeftViewTextField.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "LeftViewTextField.h"

@implementation LeftViewTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
