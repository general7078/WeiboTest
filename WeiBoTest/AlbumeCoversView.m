//
//  AlbumeCoversView.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2017/1/11.
//  Copyright © 2017年 焦鹏. All rights reserved.
//

#import "AlbumeCoversView.h"
#import "Masonry.h"

@implementation CoverButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0,contentRect.size.width, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}
@end

@interface AlbumeCoversView ()
@property (strong, nonatomic) NSMutableArray<UIButton*>* buttons;
@end

@implementation AlbumeCoversView
-(void)setupUI{
    if (!self.itemDesc) {
        return;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width = (width - 25) /4;
    for(int i = 0; i < self.itemDesc.count; i++){
        UIButton* button = [CoverButton new];
        
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(5+width*i+5*i);
            make.width.equalTo([NSNumber numberWithFloat:width]);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:self.itemDesc[i][@"title"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        [button setImage:self.itemDesc[i][@"image"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setAttributedTitle:attrTitle forState:UIControlStateNormal];
        [self.buttons addObject:button];
    }
}

@end
