//
//  WeiboTableViewController.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//

#import "WeiboTableViewController.h"
#import "Weibo.h"
#import "WeiboCell.h"
#import "WeiboWithForwardCell.h"
#import "Masonry.h"

@interface WeiboTableViewController ()
@property (strong, nonatomic) NSNumber* totalCount;
@property (strong, nonatomic) NSArray<Weibo *>* weiboArray;
@property (strong, nonatomic) UIView *totalCountView;
@property (strong, nonatomic) UILabel *totalCountLabel;
@end

@implementation WeiboTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:@"WeiboCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeiboWithForwardCell" bundle:nil] forCellReuseIdentifier:@"WeiboWithForwardCell"];
    self.tableView.allowsSelection = NO;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData{
    NSData* weiboData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"js"]];
    NSDictionary* weiboDict = [NSJSONSerialization JSONObjectWithData:weiboData options:NSJSONReadingMutableLeaves error:nil];
    self.totalCount = weiboDict[@"total"];
    self.weiboArray = [Weibo parseWeiboArray:weiboDict[@"weibo"]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.weiboArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if (self.weiboArray[indexPath.row].forwardItem) {
        WeiboWithForwardCell* weiboCell = [tableView dequeueReusableCellWithIdentifier:@"WeiboWithForwardCell" forIndexPath:indexPath];
        weiboCell.weiboItem = self.weiboArray[indexPath.row];
        cell = weiboCell;
    }else {
        WeiboCell* forwardCell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
        forwardCell.weiboItem = self.weiboArray[indexPath.row];
        cell = forwardCell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* totalView = self.totalCountView;
        self.totalCountLabel.text = [NSString stringWithFormat: @"全部微博(%@)", self.totalCount];
        return totalView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}

-(UIView *)totalCountView{
    if (!_totalCountView) {
        _totalCountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _totalCountLabel = [UILabel new];
        _totalCountLabel.font = [UIFont systemFontOfSize:12];
        _totalCountLabel.textColor = [UIColor lightGrayColor];
        [_totalCountView addSubview:_totalCountLabel];
        [_totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_totalCountView.mas_centerY);
            make.left.equalTo(_totalCountView.mas_left).offset(10);
        }];
    }
    return _totalCountView;
}

@end
