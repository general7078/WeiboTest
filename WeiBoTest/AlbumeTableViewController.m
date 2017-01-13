//
//  AlbumeTableViewController.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "AlbumeTableViewController.h"
#import "Masonry.h"
#import "AlbumeSectionHeaderView.h"
#import "AlbumeCoversView.h"

#define REMAIN_FOR_SPACING 14

@interface AlbumeTableViewController ()<UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSDictionary<NSString*, NSArray * > * albumeDataSource;
@property (strong, nonatomic) NSArray<NSString*>* sortedKey;
@end

@implementation AlbumeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).sectionHeadersPinToVisibleBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.albumeDataSource.allKeys.count+2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if(section == 1){
        return 1;
    }
    return self.albumeDataSource[self.sortedKey[section-2]].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCell" forIndexPath:indexPath];
        
        if (cell.contentView.subviews.count == 0) {
            AlbumeCoversView* covers = [AlbumeCoversView new];
            covers.backgroundColor = [UIColor whiteColor];
            UIImage* cover1 = [UIImage imageNamed:@"w3"];
            UIImage* cover2 = [UIImage imageNamed:@"w7"];
            UIImage* cover3 = [UIImage imageNamed:@"w10"];
            UIImage* cover4 = [UIImage imageNamed:@"w15"];
            [covers setItemDesc:@[@{@"title":@"全部视频",@"image":cover1,@"tag":@"1"},
                                  @{@"title":@"赞过的图",@"image":cover2,@"tag":@"2"},
                                  @{@"title":@"头像专辑",@"image":cover3,@"tag":@"3"},
                                  @{@"title":@"面孔专辑",@"image":cover4,@"tag":@"4"}]];
            [cell.contentView addSubview:covers];
            [covers mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left);
                make.right.equalTo(cell.contentView.mas_right);
                make.top.equalTo(cell.contentView.mas_top);
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            [covers setupUI];
        }
        return cell;
    }
    
    if (indexPath.section >1) {
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [cell.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([NSNumber numberWithFloat:(screenWidth - REMAIN_FOR_SPACING)/3]);
            make.height.equalTo([NSNumber numberWithFloat:(screenWidth - REMAIN_FOR_SPACING)/3]);
        }];
        if (cell.contentView.subviews.count == 0) {
            UIImageView* image = [UIImageView new];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [cell.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top);
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left);
                make.right.equalTo(cell.contentView.mas_right);
            }];
        }
        
        ((UIImageView*)cell.contentView.subviews[0]).image = [UIImage imageNamed:self.albumeDataSource[self.sortedKey[indexPath.section-2]][indexPath.row]];
        return cell;
    }
    return nil;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    AlbumeSectionHeaderView * sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    if (indexPath.section > 1) {
        sectionHeader.headTitle.text = self.sortedKey[indexPath.section - 2];
    }
    return sectionHeader;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, HEADER_HEIGHT+SECTION_HEIGHT);
    }
    if (section == 1) {
        return CGSizeZero;
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat tWidth = (screenWidth - 25) /4;
        return CGSizeMake(screenWidth, tWidth + 25);
    }
    if (indexPath.section > 1) {
        CGFloat size = ([UIScreen mainScreen].bounds.size.width - REMAIN_FOR_SPACING)/3;
        return CGSizeMake(size, size);
    }
    
    return CGSizeZero;
}

-(void)loadData{
    NSData* albumeData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"albume" ofType:@"js"]];
    NSDictionary* albumeDict = [NSJSONSerialization JSONObjectWithData:albumeData options:NSJSONReadingMutableLeaves error:nil];
    self.albumeDataSource = albumeDict[@"data"];
    self.sortedKey = [self.albumeDataSource.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
}

@end
