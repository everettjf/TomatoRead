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
#import "FeedItemManager.h"
#import <MJRefresh.h>
#import "MainContext.h"
#import "FeedPostContentViewController.h"
#import "DataManager.h"
#import "MagicCubeProgressBox.h"
#import "WebViewController.h"

static NSString * kFeedOneImageCell = @"FeedOneImageCell";
static NSString * kFeedCell = @"FeedCell";

static const NSUInteger kPageCount = 20;

@interface FeedPostsViewController ()<FeedManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray<FeedItemUIEntity*> *dataset;

// Feed fetcher
@property (strong,nonatomic) FeedItemManager *feedManager;

// For one feed mode
@property (strong,nonatomic) FeedSourceUIEntity *oneFeed;

// Status
@property (assign,nonatomic) NSUInteger totalItemCount;

@property (assign,nonatomic) BOOL loadFeedFinished;
@property (strong,nonatomic) MagicCubeProgressBox *progressBox;
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
        
        
        FeedModel *model = [[DataManager manager]findFeed:_oneFeed.link.oid];
        NSLog(@"model = %@",model);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"博文";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _feedManager = [FeedItemManager new];
    _feedManager.delegate = self;
    
    if(_mode == FeedPostsViewControllerModeOne){
        [_feedManager bindOne:_oneFeed];
    }
    
    _dataset = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    [_tableView registerClass:[FeedPostOneImageTableViewCell class] forCellReuseIdentifier:kFeedOneImageCell];
    [_tableView registerClass:[FeedPostTableViewCell class] forCellReuseIdentifier:kFeedCell];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    _progressBox = [MagicCubeProgressBox boxWithParentView:self.view];
    
    [self _loadInitialFeeds:^{
        [self _enableHeader];
        
        if(_dataset.count > 0){
            [_progressBox moveToBottomRight];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_notificationCubeTapped:) name:MagicCubeProgressBoxEventTapped object:nil];
    
    [_feedManager loadFeeds];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)_showRefreshBarButton:(BOOL)show{
    if(show)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(_forceReloadFeeds:)];
    else
        self.navigationItem.rightBarButtonItem = nil;
}

- (void)_notificationCubeTapped:(NSNotification*)o{
    if(_loadFeedFinished){
        [self _loadInitialFeeds:^{
        }];
        
        [_progressBox hide];
        _progressBox = nil;
    }
}

- (void)_enableHeader{
    if(_tableView.mj_header)return;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_pullDown)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
}

- (void)_enableFooter{
    if(_tableView.mj_footer)return;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_pullUp)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
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
        cell.author = feedItem.feed_name;
        cell.imageURL = feedItem.image;
        return cell;
    }
    
    FeedPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCell forIndexPath:indexPath];
    cell.title = feedItem.title;
    cell.date = feedItem.date;
    cell.author = feedItem.feed_name;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feedManagerLoadStart{
    [self _showRefreshBarButton:NO];
}

- (void)feedManagerLoadProgress:(NSUInteger)loadCount totalCount:(NSUInteger)totalCount{
    NSString *text = [NSString stringWithFormat:@"%@ / %@",@(loadCount),@(totalCount)];
    [_progressBox setText:text];
    
    if(loadCount > 5){
        [_progressBox moveToBottomRight];
        if(_dataset.count == 0){
            [self _loadInitialFeeds:^{}];
        }
    }
}

- (void)feedManagerLoadFinish{
    [_progressBox setText:@"更新完成"];
    [_progressBox stop];
    _loadFeedFinished = YES;
    [self _showRefreshBarButton:YES];
}

- (void)feedManagerLoadError{
    [_progressBox setText:@"网络出错"];
    [_progressBox stop];
    _loadFeedFinished = YES;
    [self _showRefreshBarButton:YES];
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
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemUIEntity *feedItem = [_dataset objectAtIndex:indexPath.row];
    NSLog(@"image = %@", feedItem.image);
    
    if(feedItem.type == ParseItemType_Feed){
        FeedPostContentViewController *contentViewController = [[FeedPostContentViewController alloc]initWithFeedPost:feedItem];
        contentViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentViewController animated:YES];
    }else{
        WebViewController *webViewController = [[WebViewController alloc]init];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        webViewController.title = feedItem.title;
        
        NSString *url = feedItem.link;
        [webViewController loadURLString:url];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (void)_forceReloadFeeds:(id)sender{
    if(_progressBox){
        [_progressBox hide];
        _progressBox = nil;
    }
    _progressBox = [MagicCubeProgressBox boxWithParentView:self.view];
    
    if(_dataset.count > 0){
        [_progressBox moveToBottomRight];
    }
    
    [_feedManager loadFeeds];
}

@end
