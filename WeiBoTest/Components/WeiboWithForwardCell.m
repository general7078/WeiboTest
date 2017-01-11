//
//  WeiboWithForwardCell.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/6.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "WeiboWithForwardCell.h"
#import "Masonry.h"

@interface WeiboWithForwardCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *authorView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndDevice;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *forwardView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *forwardContent;
@property (strong, nonatomic) NSDateFormatter* formatter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardContentHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation WeiboWithForwardCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.formatter = [NSDateFormatter new];
    self.formatter.dateFormat = @"yyyy-MM-dd";
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionViewLayout.minimumLineSpacing = 1;
    self.collectionViewLayout.minimumInteritemSpacing = 1;
    self.collectionView.scrollEnabled = NO;
    
    self.avatarImage.layer.cornerRadius =21;
    self.avatarImage.clipsToBounds = YES;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.weiboItem.forwardItem.photos.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.weiboItem.forwardItem.photos[indexPath.row]]];
    if (cell.contentView.subviews.count > 0) {
        [cell.contentView.subviews.firstObject removeFromSuperview];
    }
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.clipsToBounds = YES;
    
    [cell.contentView addSubview:img];
    cell.contentView.backgroundColor = [UIColor blackColor];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
    }];
    return cell;;
}

-(void)setWeiboItem:(Weibo *)weiboItem{
    _weiboItem = weiboItem;
    
    self.avatarImage.image = [UIImage imageNamed:weiboItem.avatar];
    self.authorNameLabel.text = weiboItem.author;
    self.dateAndDevice.text = [NSString stringWithFormat:@"%@ 来自 %@",[self.formatter stringFromDate:weiboItem.sendDate], weiboItem.sendDevice];
    self.contentLabel.text = weiboItem.content;
    self.forwardContent.text = [NSString stringWithFormat:@"%@: %@",weiboItem.forwardItem.author,weiboItem.forwardItem.content];
    
    CGSize fitSize = [self.forwardContent.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self.forwardContentHeight.constant = fitSize.height+ 10;
    if (weiboItem.liked.integerValue == 0) {
        self.likeViewHeight.constant = 0;
    }else{
        self.likeViewHeight.constant = 30;
    }
    
    if (weiboItem.forwardItem.photos.count == 0) {
        self.collectionViewHeight.constant = 0;
    }else{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (weiboItem.forwardItem.photos.count == 1) {
            self.collectionViewHeight.constant = screenWidth / 3;
            self.collectionViewLayout.itemSize = CGSizeMake(screenWidth * 2 /3, screenWidth /3);
        }else{
            NSInteger line = weiboItem.forwardItem.photos.count % 3 == 0 ? (weiboItem.forwardItem.photos.count / 3 ) :(weiboItem.forwardItem.photos.count / 3 + 1);
            self.collectionViewHeight.constant = screenWidth/3 * line - line * 12;
            self.collectionViewLayout.itemSize = CGSizeMake(screenWidth /3 - 12, screenWidth / 3 -12);
        }
    }
    self.forwardViewHeight.constant = fitSize.height + self.collectionViewHeight.constant+10;
}
@end
