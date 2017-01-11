//
//  TopicCell.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/4.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "TopicCell.h"
@interface TopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *participateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTopic:(BaseItem *)topic{
    _topic = topic;
    
    self.iconView.image = [UIImage imageNamed:topic.icon];
    self.titleLabel.text = topic.title;
    self.subTitle.text = topic.subtitle;
    self.participateLabel.text = [NSString stringWithFormat:@"共参与%@次", topic.participate];
    NSMutableParagraphStyle * para = [NSMutableParagraphStyle new];
    para.lineSpacing = 4;
    
    NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithString:topic.cotent attributes:@{NSParagraphStyleAttributeName:para}];
    [self.contentLabel setAttributedText:attributedContent];
}

@end
