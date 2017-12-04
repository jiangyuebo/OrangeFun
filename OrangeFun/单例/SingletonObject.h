//
//  SingletonObject.h
//  OrangeFun
//
//  Created by Jerry on 2017/12/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SingletonObject : NSObject

@property (strong,nonatomic) UIViewController *currentViewController;

+ (instancetype)share;

@end
