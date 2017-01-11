//
//  Weibo.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/5.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "Weibo.h"

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

@implementation ForwardItem
+ (ForwardItem *) parseForwardItem:(NSDictionary *) dict{
    ForwardItem * item = [ForwardItem new];
    item.author = dict[@"author"];
    item.content = dict[@"content"];
    item.photos = dict[@"photos"];
    return item;
}
@end

@implementation Weibo
+(NSMutableArray *)parseWeiboArray:(NSArray *) dictArry{
    NSMutableArray * retArray = [NSMutableArray new];
    for (NSDictionary * dict in dictArry) {
        [retArray addObject:[Weibo parseWeiboItem:dict]];
    }
    return retArray;
}

+(Weibo *)parseWeiboItem:(NSDictionary*) dict{
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    Weibo * item = [Weibo new];
    item.author = dict[@"author"];
    item.liked = dict[@"liked"];
    if (item.liked > 0) {
        item.likeDate = [formatter dateFromString:dict[@"likeDate"]];
        
    }
    item.sendDevice = dict[@"device"];
    item.sendDate = [formatter dateFromString:dict[@"time"]];
    item.comment = dict[@"comments"];
    item.like = dict[@"like"];
    item.forward = dict[@"forwards"];
    item.photos = dict[@"photos"];
    item.video = dict[@"video"];
    item.content = dict[@"content"];
    item.avatar = dict[@"avatar"];
    if ([dict.allKeys containsObject:@"forwardItem"]) {
        item.forwardItem = [ForwardItem parseForwardItem:dict[@"forwardItem"]];
    }
    return item;
}
@end
