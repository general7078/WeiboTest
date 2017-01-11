//
//  BaseItem.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/3.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseItem : NSObject
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *cotent;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *participate;

+(NSMutableArray *) parseBaseItemArrary:(NSArray *)itemData;
+(BaseItem *) parseBaseItem:(NSDictionary *)dataDict;
@end
