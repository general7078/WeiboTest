//
//  Weibo.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/5.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "author": "红发香克斯",
//    "avatar":"xks",
//    "liked": 1,
//    "likeDate" :"2016-12-22 10:12:00",
//    "time": "2016-12-21 10:10:10",
//    "device": "iPhone 7",
//    "isHot": 0,
//    "comments": 5329,
//    "forwards": 1038,
//    "like": 2000,
//    "photos": ["w8","w9","w10","w11","w12","w13","w14","w15","w16"],
//    "video": "",
//    "content": "你就是珍兽！卡蒙和奇妙的伙伴三刀流的过去！索隆和古伊娜的誓言著名的厨师！海上餐厅的山治"
//},

//"forwardItem": {
//    "author": "山治",
//    "content": "炽热的料理比赛？山治VS美女厨师巴基的阴谋！在处刑台微笑的男人",
//    "photos": ["w4","w5","w6","w7"]
//}

@interface ForwardItem : NSObject
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *photos;

+ (ForwardItem *) parseForwardItem:(NSDictionary *) dict;
@end

@interface Weibo : NSObject
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSNumber* liked;
@property (strong, nonatomic) NSDate *likeDate;
@property (strong, nonatomic) NSDate *sendDate;
@property (strong, nonatomic) NSString* sendDevice;
@property (strong, nonatomic) NSNumber* isHot;
@property (strong, nonatomic) NSNumber *forward;
@property (strong, nonatomic) NSNumber *comment;
@property (strong, nonatomic) NSNumber *like;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSString *video;
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) ForwardItem *forwardItem;

+(NSMutableArray *)parseWeiboArray:(NSDictionary *) dict;
+(Weibo *)parseWeiboItem:(NSDictionary*) dict;
@end
