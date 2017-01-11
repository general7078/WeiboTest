//
//  HeadSegmentView.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/30.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadSegmentDelegate<NSObject>
- (void) selectAtIndex:(NSInteger) index;
@end

@interface HeadSegmentView : UIView
@property (strong, nonatomic) id<HeadSegmentDelegate> delegate;
@property (strong, nonatomic) NSArray *titles;

@property (assign, nonatomic) NSInteger currentSelectedIndex;

- (void) selectAtIndex:(NSInteger) index;
- (void) initSegments;
@end
