//
//  FeedViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedPostsViewController.h"
#import "FeedPostTableViewCell.h"
#import "FeedPostOneImageTableViewCell.h"
#import "FeedManager.h"
#import <MJRefresh.h>
#import "MainContext.h"
#import "FeedPostContentViewController.h"

static NSString * kFeedOneImageCell = @"FeedOneImageCell";
static NSString * kFeedCell = @"FeedCell";

static const NSUInteger kPageCount = 20;

@interface FeedPostsViewController ()<FeedManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *topPanel;
@property (strong,nonatomic) UILabel *topInfoLabel;
@property (strong,nonatomic) NSMutableArray<FeedItemUIEntity*> *dataset;
@property (strong,nonatomic) FeedManager *feedManager;

@property (strong,nonatomic) FeedSourceUIEntity *oneFeed;

@property (assign,nonatomic) NSUInteger totalItemCount;
@property (strong,nonatomic) NSString *loadingPercent;
@end

@implementation FeedPostsViewController

- (instancetype)init{
    self = [super init];
    if(self){
        _mode = FeedPostsViewControllerModeAll;
    }
    return self;
}

- (instancetype)initWithOne:(FeedSourceUIEntity *)feed{
    self = [super init];
    if(self){
        _mode = FeedPostsViewControllerModeOne;
        _oneFeed = feed;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"博客精选 iOS";
    
    _feedManager = [FeedManager new];
    _feedManager.delegate = self;
    
    if(_mode == FeedPostsViewControllerModeOne){
        [_feedManager bindOne:_oneFeed];
    }
    
    _dataset = [NSMutableArray new];
    
    _topPanel = [UIView new];
    [self.view addSubview:_topPanel];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    [_tableView registerClass:[FeedPostOneImageTableViewCell class] forCellReuseIdentifier:kFeedOneImageCell];
    [_tableView registerClass:[FeedPostTableViewCell class] forCellReuseIdentifier:kFeedCell];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
    
    [_topPanel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(@30);
    }];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_topPanel.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [self _setupTopPanel];
    
    [self _loadInitialFeeds:^{
        [self _enableHeader];
    }];
    
    [_feedManager loadFeeds];
}

- (void)_enableHeader{
    if(_tableView.mj_header)return;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_pullDown)];
}

- (void)_enableFooter{
    if(_tableView.mj_footer)return;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_pullUp)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
}


- (void)_setupTopPanel{
    _topInfoLabel = [UILabel new];
    _topInfoLabel.font = [UIFont systemFontOfSize:12];
    _topInfoLabel.textColor = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
    [_topPanel addSubview:_topInfoLabel];
    
    [_topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(_topPanel);
    }];
}

- (void)_pullDown{
    [self _loadInitialFeeds:^{
        [_tableView.mj_header endRefreshing];
    }];
}
- (void)_pullUp{
    [self _loadMoreFeeds];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataset.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemUIEntity *feedItem = [_dataset objectAtIndex:indexPath.row];
    if(feedItem.image && ![feedItem.image isEqualToString:@""]){
        FeedPostOneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedOneImageCell forIndexPath:indexPath];
        cell.title = feedItem.title;
        cell.date = feedItem.date;
        cell.author = feedItem.author;
        cell.imageURL = feedItem.image;
        return cell;
    }
    
    FeedPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCell forIndexPath:indexPath];
    cell.title = feedItem.title;
    cell.date = feedItem.date;
    cell.author = feedItem.author;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feedManagerLoadStart{
    _loadingPercent = @"";
}

- (void)feedManagerLoadProgress:(NSUInteger)loadCount totalCount:(NSUInteger)totalCount{
    _loadingPercent = [NSString stringWithFormat:@"(%@/%@)",@(loadCount),@(totalCount)];
    [self _refreshTopbarInfo];
}

- (void)feedManagerLoadFinish{
    _loadingPercent = @"";
    [self _refreshTopbarInfo];
}

- (void)_loadInitialFeeds:(void(^)(void))completion{
    [_feedManager fetchItems:0 limit:kPageCount completion:^(NSArray<FeedItemUIEntity *> *feedItems, NSUInteger totalItemCount) {
        self.totalItemCount = totalItemCount;
        
        if(feedItems){
            _dataset = [feedItems mutableCopy];
            [_tableView reloadData];
        }
        
        if(_dataset.count > 0){
            [self _enableFooter];
        }
        
        [self _refreshTopbarInfo];
        
        !completion?:completion();
    }];
}

- (void)_loadMoreFeeds{
    [_feedManager fetchItems:_dataset.count limit:kPageCount completion:^(NSArray<FeedItemUIEntity *> *feedItems, NSUInteger totalItemCount) {
        self.totalItemCount = totalItemCount;
        
        if(feedItems){
            [_dataset addObjectsFromArray:feedItems];
            [_tableView reloadData];
        }
        
        [_tableView.mj_footer endRefreshing];
        
        [self _refreshTopbarInfo];
    }];
}

- (void)_refreshTopbarInfo{
    _topInfoLabel.text = [NSString stringWithFormat:@"%@文章 %@",@(self.totalItemCount),_loadingPercent];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemUIEntity *feedItem = [_dataset objectAtIndex:indexPath.row];
    NSLog(@"image = %@", feedItem.image);
    
    FeedPostContentViewController *contentViewController = [[FeedPostContentViewController alloc]initWithFeedPost:feedItem];
    [self.navigationController pushViewController:contentViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

@end
