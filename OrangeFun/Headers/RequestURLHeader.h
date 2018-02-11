//
//  RequestURLHeader.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/20.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#ifndef RequestURLHeader_h
#define RequestURLHeader_h

//故事模块开头
#define URL_REQUEST_STORY @"http://118.89.101.113/cb/api/"

//获取首页数据
#define URL_REQUEST_STORY_GET_INDEX @"v1/story/getIndex"
//获取发现数据
#define URL_REQUEST_STORY_GET_DESCOVER @"v1/story/discovery"
//获取专辑数据（分页）
#define URL_REQUEST_STORY_GET_SERIA_BY_PAGE @"v1/story/findSeriaPage"
//获取分类中的系列
#define URL_REQUEST_STORY_GET_CATEGORY @"v1/story/getSerias"
//获取热门故事
#define URL_REQUEST_STORY_GET_CATEGORY_HOT @"v1/story/getStories"
//获取专辑故事
#define URL_REQUEST_STORY_GET_CATEGORY_SERIA @"v1/story/getSeria"
//查询
#define URL_REQUEST_STORY_GET_SEARCH @"v1/story/search"

#endif /* RequestURLHeader_h */
