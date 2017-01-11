//
//  PersonPageHeaderView.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "PersonPageHeaderView.h"

#define INTRO_TEMPLATE @"简介：%@"
#define QUALIFIED_INTRO_TEMPLATE @"微博认证：%@"

@interface PersonPageHeaderView()<UIGestureRecognizerDelegate>

@end

@implementation PersonPageHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius = 38;
    self.avatarView.clipsToBounds = YES;
    self.avatarView.layer.borderColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.7].CGColor;
    self.avatarView.layer.borderWidth = 2;
}

-(void) setProfile:(Profile *)profile{
    self.userName.text = profile.name;
    self.followedCount.text = [NSString stringWithFormat:@"%@",profile.followed];
    self.followerCount.text = [NSString stringWithFormat:@"%@", profile.follower];
    if (profile.qualified) {
        self.userQualification.text = [NSString stringWithFormat:QUALIFIED_INTRO_TEMPLATE,profile.intro];
    }else{
        self.userQualification.text = [NSString stringWithFormat:INTRO_TEMPLATE,profile.intro];
    }
    
    _profile = profile;
}

@end
