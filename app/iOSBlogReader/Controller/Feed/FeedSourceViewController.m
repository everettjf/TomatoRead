//
//  FeedSourceViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedSourceViewController.h"
#import "RestApi.h"
#import "FeedSourceTableViewCell.h"
#import "MainContext.h"
#import <MJRefresh.h>
#import "FeedModel.h"
#import "FeedItemManager.h"
#import "FeedPostsViewController.h"
#import "AppUtil.h"

static NSString * const kLinkCell = @"FeedSourceCell";

@interface FeedSourceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray<FeedSourceUIEntity*> *dataset;
@property (strong,nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation FeedSourceViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataset = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订阅";
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[FeedSourceTableViewCell class] forCellReuseIdentifier:kLinkCell];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [_indicator startAnimating];
    
    [self _loadFromDB:YES];
}

- (void)_addHeaderFooter{
    if(_tableView.mj_header)return;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_pullDown)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_pullUp)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
}

- (void)_loadFromDB:(BOOL)loadFromWebWhenEmpty{
    [[FeedSourceManager manager] queryFeedSources:0 limit:20 completion:^(NSArray<FeedSourceUIEntity *> *feedItems, NSUInteger totalCount) {
        if(_indicator){
            [_indicator stopAnimating];
            [_indicator removeFromSuperview];
            _indicator = nil;
        }
        [self _addHeaderFooter];
        
        if(feedItems.count == 0){
            if(loadFromWebWhenEmpty){
                [self _loadFromWeb:YES];
            }
            return;
        }
        
        _dataset = [feedItems mutableCopy];
        [_tableView reloadData];
        
        [self _loadFromWeb:NO];
        return;
    }];
}

- (void)_loadFromWeb:(BOOL)reloadDBWhenSucceed{
    // from web
    [[FeedSourceManager manager]requestFeedSources:^(BOOL succeed) {
        if(!succeed)
            return;
        
        // Has update
        if(reloadDBWhenSucceed){
            [self _loadFromDB:NO];
        }
    }];
}

- (void)_pullDown{
    // from web
    [[FeedSourceManager manager]requestFeedSources:^(BOOL succeed) {
        if(succeed){
            [self _loadFromDB:NO];
        }
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
    }];
}

- (void)_pullUp{
    [[FeedSourceManager manager]queryFeedSources:_dataset.count limit:20 completion:^(NSArray<FeedSourceUIEntity *> *feedItems, NSUInteger totalCount) {
        if(!feedItems)return;
        
        [_dataset addObjectsFromArray:feedItems];
        [_tableView reloadData];
        
        if(_dataset.count >= totalCount){
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataset.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLinkCell forIndexPath:indexPath];
    FeedSourceUIEntity *entity = [_dataset objectAtIndex:indexPath.row];
    cell.favicon = entity.link.favicon;
    cell.title = entity.link.name;
    if(entity.latest_post_date){
        cell.subTitle = [NSString stringWithFormat:@"%@篇 最后更新于%@",
                         @(entity.post_count),
                         [[AppUtil util]formatDate:entity.latest_post_date]];
    }else{
        cell.subTitle = [NSString stringWithFormat:@"%@篇",
                         @(entity.post_count)];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedSourceUIEntity *entity = [_dataset objectAtIndex:indexPath.row];
    
    FeedPostsViewController *postsViewController = [[FeedPostsViewController alloc]initWithOne:entity];
    postsViewController.hidesBottomBarWhenPushed = YES;
    postsViewController.title = entity.link.name;
    [self.navigationController pushViewController:postsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
