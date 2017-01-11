//
//  PersonPageHeaderView.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Profile.h"

@interface PersonPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userQualification;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *followedCount;
@property (strong, nonatomic) Profile *profile;
@end
