//
//  HeadSegmentView.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/30.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "HeadSegmentView.h"
#import "Masonry.h"

@interface HeadSegmentView()
@property (strong, nonatomic) NSMutableArray<UIButton*> *buttons;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) MASConstraint *lineCenterX;
@end

@implementation HeadSegmentView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.currentSelectedIndex = 0;
}

-(void)initSegments{
    for (int i = 0; i < self.titles.count; i++) {
        UIButton * btn = [UIButton new];
        [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:self.titles[i] attributes:@{UIFontDescriptorSizeAttribute: @14.0}]  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = i;
        [self.buttons addObject:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.equalTo(self.mas_left);
            }else if(i == self.titles.count -1){
                make.left.equalTo(self.buttons[i-1].mas_right);
                make.right.equalTo(self.mas_right);
                make.width.equalTo(self.buttons[i-1].mas_width);
            }else{
                make.left.equalTo(self.buttons[i-1].mas_right);
                make.width.equalTo(self.buttons[i-1].mas_width);
            }
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(((UIButton *)self.buttons[0]).mas_width);
    }];
    self.lineView.center = CGPointMake(self.buttons[1].center.x, self.lineView.center.y);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.center = CGPointMake(self.buttons[self.currentSelectedIndex].center.x, self.lineView.center.y);
}

-(void)selectAtIndex:(NSInteger)index{
    self.currentSelectedIndex = index;
    CGPoint newPoint = CGPointMake(self.buttons[index].center.x, self.lineView.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.center = newPoint;
    }];
}

-(IBAction)buttonTapped:(id)sender{
    [self.delegate selectAtIndex:((UIButton *)sender).tag];
    self.currentSelectedIndex =((UIButton *)sender).tag;
    CGPoint newPoint = CGPointMake(((UIButton *)sender).center.x, self.lineView.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.center = newPoint;
    }];
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor orangeColor];
    }
    return  _lineView;
}
@end
