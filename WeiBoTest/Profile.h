//
//  Profile.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/3.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "name": "海贼王",
//    "follewer": 12345,
//    "followed": 345,
//    "qulified": 1,
//    "intro": "我是要成为海贼王的男人！",
//    "avatar": "avatar"
//}

@interface Profile : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSNumber *follower;
@property (strong,nonatomic) NSNumber *followed;
@property (strong,nonatomic) NSNumber *qualified;
@property (strong,nonatomic) NSString *intro;
@property (strong,nonatomic) NSString *avatar;

+(Profile*) parseProfileWithData:(NSDictionary*) data;
@end
