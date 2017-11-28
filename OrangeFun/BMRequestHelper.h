//
//  BMRequestHelper.h
//  BMVehicleControl
//
//  Created by Jerry on 2017/1/4.
//  Copyright © 2017年 BanMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMRequestHelper : NSObject<NSURLSessionDelegate>

//post异步请求方法
- (void)postRequestAsynchronousToUrl:(NSString *) url byParamsStr:(NSString *)paramsStr andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback;

//post异步请求方法
- (void)postRequestAsynchronousToUrl:(NSString *) url byParamsDic:(id)paramsDic needAccessToken:(BOOL) isNeed andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback;

//get异步请求方法
- (void)getRequestAsynchronousToUrl:(NSString *) url andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback;

@end
