//
//  HomeTableViewController.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "HomeTableViewController.h"
#import "Masonry.h"
#import "BaseItem.h"
#import "TopicCell.h"
#import "HomePageSectionView.h"
#import "ArticleCell.h"
#import "Weibo.h"
#import "WeiboCell.h"

@interface HomeTableViewController ()
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footerButton;
@property (strong, nonatomic) NSMutableDictionary *dataSource;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void) loadData{
    NSData* homePageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homepage" ofType:@"js"]];
    NSDictionary* homePageDict = [NSJSONSerialization JSONObjectWithData:homePageData options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray* weibo = [Weibo parseWeiboArray:homePageDict[@"hot"]];
    [self.dataSource setObject:weibo forKey:@"hot"];
    NSMutableArray* topics = [BaseItem parseBaseItemArrary:homePageDict[@"topics"]];
    [self.dataSource setObject:topics forKey:@"topic"];
    NSMutableArray* articles = [BaseItem parseBaseItemArrary:homePageDict[@"articles"]];
    [self.dataSource setObject:articles forKey:@"article"];
}

-(void) setupUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:@"WeiboCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeiboWithForwardCell" bundle:nil] forCellReuseIdentifier:@"WeiboWithForwardCell"];
     self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.footerButton];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView.mas_top);
        make.right.equalTo(self.footerView.mas_right);
        make.left.equalTo(self.footerView.mas_left);
        make.height.equalTo(@38);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.allKeys.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomePageSectionView* sectionView = [[NSBundle mainBundle] loadNibNamed:@"HomePageSectionView" owner:nil options:nil].lastObject;
    NSString* key =(self.dataSource.allKeys)[section] ;
    if ([key isEqual:@"hot"]) {
        sectionView.sectionTitle.text = @"他的热门内容";
    }
    if ([key  isEqual: @"topic"]) {
        sectionView.sectionTitle.text = @"他参与的话题";
    }else if ([key isEqual: @"article"]){
        sectionView.sectionTitle.text = @"他的文章";
    }
    return sectionView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)self.dataSource[self.dataSource.allKeys[section]]).count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* key =(self.dataSource.allKeys)[indexPath.section] ;
    if ([key isEqual:@"hot"]) {
        WeiboCell* weiboCell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
        [weiboCell setWeiboItem:self.dataSource[key][indexPath.row]];
        return weiboCell;
    }
    if ([key  isEqual: @"topic"]) {
        TopicCell* topicCell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
        [topicCell setTopic:self.dataSource[key][indexPath.row]];
        return topicCell;
    }else if ([key isEqual: @"article"]){
        ArticleCell* articleCell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
        [articleCell setArticle:self.dataSource[key][indexPath.row]];
        return articleCell;
    }
    return nil;
}


-(UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    
    return _footerView;
}

- (UIButton *)footerButton{
    if (!_footerButton) {
        _footerButton = [UIButton new];
        _footerButton.backgroundColor = [UIColor whiteColor];
        UIFont *font = [UIFont fontWithName:_footerButton.titleLabel.font.fontName size:14];
        [_footerButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"查看他的全部微博" attributes:@{NSFontAttributeName:font}] forState:UIControlStateNormal];
        _footerButton.titleLabel.textColor = [UIColor lightGrayColor];
        _footerButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _footerButton;
}

-(NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary new];
    }
    return  _dataSource;
}

@end
