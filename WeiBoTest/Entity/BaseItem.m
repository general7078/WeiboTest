//
//  BaseItem.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/3.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem
+(NSMutableArray *) parseBaseItemArrary:(NSArray *)itemData{
    NSMutableArray * array = [NSMutableArray new];
    for(NSDictionary* dict in itemData){
        BaseItem *baseItem = [BaseItem parseBaseItem:dict];
        
        [array addObject:baseItem];
    }
    return array;
}

+(BaseItem *) parseBaseItem:(NSDictionary *)dataDict{
    BaseItem *baseItem = [BaseItem new];
    baseItem.title = dataDict[@"title"];
    baseItem.subtitle = dataDict[@"subtitle"];
    baseItem.cotent = dataDict[@"content"];
    baseItem.icon = dataDict[@"icon"];
    baseItem.type = dataDict[@"type"];
    
    if ([baseItem.type  isEqual: @1]) {
        baseItem.participate = dataDict[@"participate"];
    }
    
    return baseItem;
}
@end
