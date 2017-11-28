//
//  globalHeader.h
//  OrangeGrowup
//
//  Created by Jerry on 2016/12/19.
//  Copyright © 2016年 Jerry. All rights reserved.
//

#ifndef globalHeader_h
#define globalHeader_h

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

//******颜色
//navigation bar color
#define color_navigation_bar @"#F86400"

#endif /* globalHeader_h */
