//
//  DataModel.h
//  新闻(抓取网易新闻首页数据)
//
//  Created by gyh on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

/**
"postid": "PHOT3DG1000100AO",
"hasCover": false,
"hasHead": 1,
"replyCount": 4851,
"hasImg": 1,
"digest": "",
"hasIcon": true,
"docid": "9IG74V5H00963VRO_BH7U88B7bjjikeupdateDoc",
"title": "伊朗移民缝嘴抗议清拆加来移民营地",
"order": 1,
"priority": 250,
"lmodify": "2016-03-03 11:55:42",
"boardid": "photoview_bbs",
"ads": [
        {
            "title": "《看客》：两会时间",
            "tag": "photoset",
            "imgsrc": "http://img3.cache.netease.com/3g/2016/3/3/20160303071743c9583.jpg",
            "subtitle": "",
            "url": "3R710001|112103"
        },
        {
            "title": "政协新闻发布会上美女记者争相提问",
            "tag": "photoset",
            "imgsrc": "http://img4.cache.netease.com/3g/2016/3/3/20160303131225a9608.jpg",
            "subtitle": "",
            "url": "00AN0001|112172"
        },
        {
            "title": "伊朗移民缝嘴抗议清拆加来移民营地",
            "tag": "photoset",
            "imgsrc": "http://img6.cache.netease.com/3g/2016/3/3/2016030311572335997.jpg",
            "subtitle": "",
            "url": "00AO0001|112129"
        },
        {
            "title": "北京铁警设治安检查站 特警全天值守",
            "tag": "photoset",
            "imgsrc": "http://img1.cache.netease.com/3g/2016/3/3/201603031054356419d.jpg",
            "subtitle": "",
            "url": "00AN0001|112151"
        },
        {
            "title": "联合国通过制裁朝鲜决议 中国赞成",
            "tag": "photoset",
            "imgsrc": "http://img6.cache.netease.com/3g/2016/3/3/2016030308341702b62.jpg",
            "subtitle": "",
            "url": "00AO0001|112135"
        }
        ],
"photosetID": "00AO0001|112129",
"template": "manual",
"votecount": 4489,
"skipID": "00AO0001|112129",
"alias": "Top News",
"skipType": "photoset",
"cid": "C1348646712614",
"hasAD": 1,
"imgextra": [
             {
                 "imgsrc": "http://img3.cache.netease.com/3g/2016/3/3/20160303115725c54d9.jpg"
             },
             {
                 "imgsrc": "http://img5.cache.netease.com/3g/2016/3/3/20160303115727a3621.jpg"
             }
             ],
"imgsrc": "http://img6.cache.netease.com/3g/2016/3/3/2016030311572335997.jpg",
"tname": "头条",
"ename": "iosnews",
"ptime": "2016-03-03 11:55:42"
},
{
    "postid": "BH82LDRE00963VRO",
    "url_3w": "http://help.3g.163.com/16/0303/13/BH82LDRE00963VRO.html",
    "votecount": 0,
    "replyCount": 16,
    "skipID": "S1451880983492",
    "ltitle": "习近平2016两会时间① 习近平的两会日程都是怎么安排的？",
    "digest": "一起回顾，过去三年习近平的“两会时间”都有哪些活动。",
    "skipType": "special",
    "url": "http://3g.163.com/ntes/16/0303/13/BH82LDRE00963VRO.html",
    "specialID": "S1451880983492",
    "docid": "BH82LDRE00963VRO",
    "title": "习近平两会日程是怎么安排的",
    "source": "新华网$",
    "priority": 222,
    "lmodify": "2016-03-03 13:23:27",
    "boardid": "3g_bbs",
    "subtitle": "",
    "imgsrc": "http://img5.cache.netease.com/3g/2016/3/3/20160303131448ebd11.jpg",
    "ptime": "2016-03-03 13:12:47"
},
*/


/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  多图数组
 */
@property (nonatomic,strong)NSArray *imgextra;
@property (nonatomic,copy) NSString *photosetID;
@property (nonatomic,copy)NSNumber *hasHead;
@property (nonatomic,copy)NSNumber *hasImg;
@property (nonatomic,copy) NSString *lmodify;
@property (nonatomic,copy) NSString *Template;
@property (nonatomic,copy) NSString *skipType;
/**
 *  跟帖人数
 */
@property (nonatomic,copy)NSNumber *replyCount;
@property (nonatomic,copy)NSNumber *votecount;
@property (nonatomic,copy) NSString *alias;
/**
 *  新闻ID
 */
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,assign)BOOL hasCover;
@property (nonatomic,copy)NSNumber *hasAD;
@property (nonatomic,copy)NSNumber *priority;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,strong)NSArray *videoID;
/**
 *  图片连接
 */
@property (nonatomic,copy) NSString *imgsrc;
@property (nonatomic,assign)BOOL hasIcon;
@property (nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,copy)NSNumber *order;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *digest;

@property (nonatomic,strong)NSArray *editor;


@property (nonatomic,copy) NSString *url_3w;
@property (nonatomic,copy) NSString *specialID;
@property (nonatomic,copy) NSString *timeConsuming;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *adTitle;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *source;

@property (nonatomic,copy) NSString *TAGS;
@property (nonatomic,copy) NSString *TAG;
/**
 *  大图样式
 */
@property (nonatomic,copy)NSNumber *imgType;
@property (nonatomic,strong)NSArray *specialextra;


@property (nonatomic,copy) NSString *boardid;
@property (nonatomic,copy) NSString *commentid;
@property (nonatomic,copy)NSNumber *speciallogo;
@property (nonatomic,copy) NSString *specialtip;
@property (nonatomic,copy) NSString *specialadlogo;

@property (nonatomic,copy) NSString *pixel;
@property (nonatomic,strong)NSArray *applist;

@property (nonatomic,copy) NSString *wap_portal;
@property (nonatomic,copy) NSString *live_info;
@property (nonatomic,copy) NSString *ads;
@property (nonatomic,copy) NSString *videosource;


@end
