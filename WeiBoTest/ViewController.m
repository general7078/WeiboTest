//
//  ViewController.m
//  WeiBoTest
//
//  Created by 焦鹏 on 2016/12/22.
//  Copyright © 2016年 焦鹏. All rights reserved.
//


#import "ViewController.h"
#import "PersonPageHeaderView.h"
#import "Masonry.h"
#import "BaseTableViewController.h"
#import "HeadSegmentView.h"
#import "Profile.h"

@interface ViewController ()<TableScrollSyncDelegate,UIScrollViewDelegate,HeadSegmentDelegate>{
    CGFloat barHeight;
    CGFloat headerHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray<BaseTableViewController*>* tableControllers;
@property (strong, nonatomic) PersonPageHeaderView * headerView;
@property (strong, nonatomic) MASConstraint* headerPosition;
@property (strong, nonatomic) MASConstraint* headerBgImageHeight;
@property (strong, nonatomic) MASConstraint* segmentTop;
@property (strong, nonatomic) UIScrollView *headerScrollView;
@property (strong, nonatomic) UIImageView *headerBgImageView;
@property (strong, nonatomic) UIView *barBgView;
@property (strong, nonatomic) BaseTableViewController *currentTableController;
@property (strong, nonatomic) HeadSegmentView *segmentView;
@property (strong, nonatomic) NSString *pageName;

@property (assign, nonatomic) BOOL ignore;
@property (assign, nonatomic) BOOL stopDecleratign;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageName = @"个人主页";
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    self->barHeight = rectNav.size.height + rectStatus.size.height;
    self->headerHeight = barHeight + HEADER_HEIGHT;
    
    [self setupUI];
    [self loadData];
}

-(void) loadData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* profileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile" ofType:@"js"]];
        NSDictionary* profileDict = [NSJSONSerialization JSONObjectWithData:profileData options:NSJSONReadingMutableLeaves error:nil];
        Profile * profile = [Profile parseProfileWithData:profileDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pageName = profile.name;
            self.headerView.profile = profile;
        });
    });
}

- (void)setupUI{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*4, 0);
    self.scrollView.delegate = self;
    
    [self.tableControllers removeAllObjects];
    
    [self.tableControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"HomePageTable"]];
    [self.tableControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"WeiboTable"]];
    [self.tableControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"HeadlineTable"]];
    [self.tableControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"AlbumeTable"]];
    
    // add head back ground
    [self.view addSubview:self.headerBgImageView];
    
    //add head scroll view
    [self.view addSubview:self.headerScrollView];
    [self.headerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo([NSNumber numberWithFloat:self->headerHeight]);
        self.headerPosition = make.top.equalTo(self.view.mas_top);
    }];
    
    
    [self.headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);

        make.bottom.equalTo(self.headerScrollView.mas_bottom);
        self.headerBgImageHeight = make.height.equalTo([NSNumber numberWithFloat:self->headerHeight]);
    }];
    
    //add header view
    [self.headerScrollView addSubview:self.headerView];
    self.headerView.frame = _headerScrollView.frame;
    
    [self.tableControllers enumerateObjectsUsingBlock:^(BaseTableViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height- self->barHeight);
        [self addChildViewController:obj];
        [self.scrollView addSubview:obj.view];
        [obj willMoveToParentViewController:self];
        obj.scrollSyncDelegate = self;
    }];
    
    [self setNavigationBarColor];
    
    //add navigation and status bar backgound view at the top level
    [self.view addSubview:self.barBgView];
    [self.barBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo([NSNumber numberWithFloat:self->barHeight]);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:SECTION_HEIGHT]);
        make.width.equalTo(self.view.mas_width);
        self.segmentTop = make.top.equalTo(self.headerScrollView.mas_bottom);
    }];
    self.segmentView.titles = @[@"主页",@"微博",@"视频",@"相册"];
    [self.segmentView initSegments];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerScrollView.contentSize = [self getHeaderViewContentSize];
}
- (void) selectAtIndex:(NSInteger) index{
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*index, 0) animated:YES];
    self.headerScrollView.contentSize = [self getHeaderViewContentSize];
    [self.view setNeedsLayout];
}

-(CGSize) getHeaderViewContentSize{
//    CGFloat height = [self.tableControllers[self.segmentView.currentSelectedIndex] getScrollableView].contentSize.height - self.scrollView.frame.size.height + self->headerHeight;
    UIScrollView* view = [self.tableControllers[self.segmentView.currentSelectedIndex] getScrollableView];
    CGFloat height = view.contentSize.height - view.bounds.size.height;
    if (height<self->headerHeight) {
        height = self->headerHeight+0.5;
    }
    else{
        height = self->headerHeight + height;
    }
    return CGSizeMake(0, height);
    
}

#pragma mark scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        if (self.ignore) {
            if (!self.stopDecleratign) {
                self.ignore = NO;
            }else{
                [self.headerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self->headerHeight);
            }
            
            return;
        }else{
            self.headerView.frame = CGRectMake(self.headerScrollView.contentOffset.x, self.headerScrollView.contentOffset.y, self.view.frame.size.width, self->headerHeight);
        }
        if (!self.stopDecleratign) {
            [[self.tableControllers[self.segmentView.currentSelectedIndex] getScrollableView] setContentOffset:self.headerScrollView.contentOffset animated:NO];
        }
    }
    
    if(scrollView == self.scrollView){
        [self.segmentView selectAtIndex:round(self.scrollView.contentOffset.x / self.view.frame.size.width)];
        self.headerScrollView.contentSize = [self getHeaderViewContentSize];
        [self.view setNeedsLayout];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        if (scrollView.contentOffset.y>self->headerHeight) {
            self.ignore = YES;
            
            self.headerScrollView.contentOffset = CGPointZero;
            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self->headerHeight);
        }
        self.stopDecleratign = NO;
    }
}

-(void)tableTouched{
    if (self.headerScrollView.decelerating) {
        self.stopDecleratign = YES;
        self.ignore = YES;
    }
}

-(void)tableScrolledToOffset:(CGFloat)offset view:(UIScrollView *)view{
    
    if(offset < 0){
        self.headerBgImageHeight.equalTo([NSNumber numberWithFloat:(self->headerHeight - offset)]);
    }else{
        self.headerBgImageHeight.equalTo([NSNumber numberWithFloat:(self->headerHeight)]);
    }
    
    if (offset < HEADER_HEIGHT) {
        [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerScrollView.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo([NSNumber numberWithFloat:SECTION_HEIGHT]);
        }];
    }else{
        [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo([NSNumber numberWithFloat:SECTION_HEIGHT]);
        }];
    }
    
    if (offset <= self->headerHeight) {
        [self.headerPosition setOffset:-offset];
    }
    
    if(offset<HEADER_HEIGHT - self->barHeight){
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        self.barBgView.backgroundColor = [UIColor clearColor];
        self.title = nil;
    }else if(offset< HEADER_HEIGHT&& offset>=HEADER_HEIGHT - self->barHeight){
        CGFloat alpha =(offset - HEADER_HEIGHT + self->barHeight) / self->barHeight;
        self.barBgView.backgroundColor = [[UIColor alloc] initWithRed:249/256.0 green:249/256.0 blue:249/256.0 alpha: alpha];
        self.navigationItem.titleView.alpha = alpha;
        if (alpha < 0.5) {
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            self.title = nil;
        }else{
            [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
            self.title = self.pageName;
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[[UIColor alloc] initWithWhite:0 alpha:alpha-0.2]};
        }
    }else{
        self.barBgView.backgroundColor = [[UIColor alloc] initWithRed:249/256.0 green:249/256.0 blue:249/256.0 alpha:1];
        self.title = self.pageName;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[[UIColor alloc] initWithWhite:0 alpha:1]};
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }
       
    //sync the content offset of all tables
    [self.tableControllers enumerateObjectsUsingBlock:^(BaseTableViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj getScrollableView] == view) {
            return ;
        }
        
        if(view.contentOffset.y <= self->headerHeight){
            [obj getScrollableView].contentOffset = view.contentOffset;
        }
        else{
            if ([obj getScrollableView ].contentOffset.y < self->headerHeight) {
                [obj getScrollableView].contentOffset = CGPointMake(0, self->headerHeight);
            }
        }
    }];
}

-(void) setNavigationBarColor{
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self->barHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (NSMutableArray *)tableControllers{
    if (!_tableControllers) {
        _tableControllers = [[NSMutableArray alloc] init];
    }
    return _tableControllers;
}

- (PersonPageHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"PersonPageHeaderView" owner:nil options:nil].lastObject;
    }
    return  _headerView;
}

-(UIScrollView *)headerScrollView{
    if (!_headerScrollView) {
        _headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self->headerHeight)];
        _headerScrollView.delegate = self;
    }
    return  _headerScrollView;
}

-(UIView *)barBgView{
    if (!_barBgView) {
        _barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self->barHeight)];
        _barBgView.backgroundColor = [UIColor clearColor];
        _barBgView.opaque = NO;
    }
    return _barBgView;
}

-(UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [UIImageView new];
        _headerBgImageView.image = [UIImage imageNamed:@"timg"];
        _headerBgImageView.contentScaleFactor = 1.2;
        _headerBgImageView.clipsToBounds = YES;
        _headerBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return  _headerBgImageView;
}

-(HeadSegmentView *)segmentView{
    if(!_segmentView){
        _segmentView = [HeadSegmentView new];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.delegate = self;
    }
    return _segmentView;
}
@end
