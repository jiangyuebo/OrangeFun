//
//  SingletonObject.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "SingletonObject.h"

static SingletonObject *_singleton;
@implementation SingletonObject

@synthesize currentViewController;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleton == nil) {
            _singleton = [super allocWithZone:zone];
        }
    });
    
    return _singleton;
}

+ (instancetype)share{
    return [[self alloc] init];
}


@end
