//
//  ArticleCell.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/4.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "ArticleCell.h"
@interface ArticleCell()
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *cotentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setArticle:(BaseItem *)article{
    _article = article;
    self.iconView.image = [UIImage imageNamed:article.icon];
    NSMutableString *titleString = [NSMutableString new];
    [titleString appendString:article.title];
    [titleString appendString:@"\r"];
    [titleString appendString:article.subtitle];
    
    NSMutableParagraphStyle * para = [NSMutableParagraphStyle new];
    para.lineSpacing = 5;
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSParagraphStyleAttributeName:para}];
    
    if (article.subtitle != nil && article.subtitle.length > 0) {
        NSRange range = NSMakeRange(article.title.length+1, article.subtitle.length);
        [attributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:range];
    }

    [self.tableLabel setAttributedText:attributed];
    
    NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithString:article.cotent attributes:@{NSParagraphStyleAttributeName:para}];
    [self.cotentLabel setAttributedText:attributedContent];
}

@end
