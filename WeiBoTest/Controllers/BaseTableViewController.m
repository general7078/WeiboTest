//
//  BaseTableViewController.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Masonry.h"

@interface BaseTableViewController ()
@property (strong, nonatomic) UIView *header;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.tableView != nil){
        self.tableView.tableHeaderView = self.header;
        [self.tableView.panGestureRecognizer addTarget:self action:@selector(panned:)];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    if (self.collectionView != nil) {
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView.panGestureRecognizer addTarget:self action:@selector(panned:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView*) getScrollableView{
    if (self.tableView) {
        return self.tableView;
    }else{
        return self.collectionView;
    }
}

-(void) panned:(UIPanGestureRecognizer*) recognizer{
    [self.scrollSyncDelegate tableTouched];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark table delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SECTION_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.scrollSyncDelegate tableScrolledToOffset:scrollView.contentOffset.y view:scrollView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//make the cell to use autolayout
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

#pragma mark override methods
-(UIView *)header{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, HEADER_HEIGHT+SECTION_HEIGHT + 5)];
    }
    return _header;
}

- (UIView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, SECTION_HEIGHT)];
        _sectionHeader.backgroundColor = [UIColor greenColor];
    }
    return  _sectionHeader;
}

@end
