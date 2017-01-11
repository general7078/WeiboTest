//
//  BaseTableViewController.h
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEADER_HEIGHT 160.0
#define SECTION_HEIGHT 40.0

@protocol TableScrollSyncDelegate<NSObject>
-(void) tableScrolledToOffset:(CGFloat) offset view:(UIScrollView*) view;
-(void) tableTouched;
@end

@interface BaseTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString* uniqueName;
@property (strong, nonatomic) id<TableScrollSyncDelegate> scrollSyncDelegate;
@property (strong, nonatomic) UIView *sectionHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(UIScrollView*) getScrollableView;

@end
