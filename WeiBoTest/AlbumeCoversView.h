//
//  AlbumeCoversView.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/11.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumeCoverDelegate<NSObject>
-coverSelectedWithTag:(NSString*)tag;
@end

@interface CoverButton : UIButton

@end

@interface AlbumeCoversView : UIView
@property (strong,nonatomic) NSArray<NSDictionary<NSString*,id>*> *itemDesc;
@property (weak, nonatomic) id<AlbumeCoverDelegate> delegate;
-(void)setupUI;
@end
