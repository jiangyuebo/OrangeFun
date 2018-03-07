//
//  ProjectHeader.h
//  OrangeFun
//
//  Created by Jerry on 2017/11/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#ifndef ProjectHeader_h
#define ProjectHeader_h

//首页广告banner尺寸
#define banner_width 1242
#define banner_height 464

//搜索页面
#define viewcontroller_search @"searchviewcontroller"

//故事列表页面
#define viewcontroller_storylist @"storylistviewcontroller"
//故事分类列表页面
#define viewcontroller_categorylist @"categorylistviewcontroller"
//查询结果页
#define viewcontroller_searchdiplay @"searchdisplayviewcontroller"
//故事播放页
#define viewcontroller_playview @"playviewcontroller"
//播放历史页
#define viewcontroller_playedhistory @"playhistoryviewcontroller"
//登录页
#define viewcontroller_login @"loginviewcontroller"

//webview
#define viewcontroller_webview @"webviewcontroller"
//linkURL
#define key_banner_link @"keybannerlink"

//*******************字段们************************
//banner data
#define mainpage_column_banners @"banners"
#define mainpage_column_banner_logoURL @"logoUrl"
#define mainpage_column_banner_bannerURL @"bannerUrl"
//category story data
#define mainpage_key_category_type @"type"
#define mainpage_value_category_type_hot @"hot"
#define mainpage_value_category_type_serias @"serias"

#define mainpage_column_category_seriaID @"seriaID"
#define mainpage_column_category_seriaName @"seriaName"
#define mainpage_column_category_seriaCategory @"seriaCategory"
#define mainpage_column_category_logoURL @"logoUrl"
#define mainpage_column_category_story_name @"storyName"
#define mainpage_column_category_story_playURL @"playUrl"

#define mainpage_column_category_serias @"serias"
#define mainpage_column_category_stories @"stories"

#define mainpage_column_category_name @"categoryname"

#define search_keyword @"keyword"

//*********************存储key
//搜索历史记录
#define storage_key_search_history @"searchhistory"
//播放历史记录
#define storage_key_played_history @"playhistory"

//**********************广播KEY
//播放完成
#define notification_key_play_finished @"playfinish"
//播放开始
#define notification_key_play_start @"playstart"
//恢复前台播放
#define notification_key_become_foreground @"foregroundplay"

#endif /* ProjectHeader_h */
