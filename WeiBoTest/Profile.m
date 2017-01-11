//
//  Profile.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/3.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "Profile.h"

//{
//    "name": "海贼王",
//    "follewer": 12345,
//    "followed": 345,
//    "qulified": 1,
//    "intro": "我是要成为海贼王的男人！",
//    "avatar": "avatar"
//}

@implementation Profile



+(Profile *)parseProfileWithData:(NSDictionary *)data{
    Profile* profile = [Profile new];
    profile.name = data[@"name"];
    profile.follower = data[@"follower"];
    profile.followed = data[@"followed"];
    profile.qualified = data[@"qualified"];
    profile.intro = data[@"intro"];
    profile.avatar = data[@"avatar"];
    return profile;
}
@end
