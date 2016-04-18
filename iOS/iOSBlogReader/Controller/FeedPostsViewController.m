//
//  FeedViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedPostsViewController.h"
#import "FeedTableViewCell.h"
#import "FeedManager.h"
#import <MJRefresh.h>
#import "WebViewController.h"
#import "MainContext.h"

static NSString * kFeedCell = @"FeedCell";

@interface FeedPostsViewController ()<FeedManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *topPanel;
@property (strong,nonatomic) UILabel *topInfoLabel;
@property (strong,nonatomic) NSMutableArray<FeedItemUIEntity*> *dataset;

@end

@implementation FeedPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataset = [NSMutableArray new];
    
    _topPanel = [UIView new];
    [self.view addSubview:_topPanel];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:kFeedCell];
    [self.view addSubview:_tableView];
    
    [_topPanel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@30);
    }];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_topPanel.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_pullDown)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_pullUp)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
    
    [self _setupTopPanel];
    
    [self _pullDown];
    
    [FeedManager manager].delegate = self;
    [[FeedManager manager] loadFeeds];
}

- (void)_setupTopPanel{
    _topInfoLabel = [UILabel new];
    _topInfoLabel.text = @"加载中...";
    _topInfoLabel.font = [UIFont systemFontOfSize:12];
    _topInfoLabel.textColor = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
    [_topPanel addSubview:_topInfoLabel];
    
    [_topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(_topPanel);
    }];
}

- (void)_pullDown{
    _dataset = [NSMutableArray new];
    [self _loadMoreFeeds];
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
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCell forIndexPath:indexPath];
    FeedItemUIEntity *feedItem = [_dataset objectAtIndex:indexPath.row];
    
    cell.title = feedItem.title;
    
    NSMutableString *subTitle = [NSMutableString new];
    if(feedItem.author) [subTitle appendString:feedItem.author];
    if(feedItem.date) [subTitle appendString:[NSString stringWithFormat:@"%@",feedItem.date]];
    cell.subTitle = subTitle;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feedManagerLoadStart{
    _topInfoLabel.text = @"加载中...";
}
- (void)feedManagerLoadProgress:(NSUInteger)loadCount totalCount:(NSUInteger)totalCount{
    float progress = 0;
    if(totalCount>0)progress=loadCount*1.0/totalCount;
    
    _topInfoLabel.text = [NSString stringWithFormat:@"正在更新 %@ / %@",@(loadCount),@(totalCount)];
}

- (void)feedManagerLoadFinish{
    [self _loadMoreFeeds];
}
- (void)_loadMoreFeeds{
    [[FeedManager manager]fetchLocalFeeds:_dataset.count limit:20 completion:^(NSArray<FeedItemUIEntity *> *feedItems, NSUInteger totalItemCount, NSUInteger totalFeedCount) {
        if(feedItems){
            [_dataset addObjectsFromArray:feedItems];
            [_tableView reloadData];
        }
        
        _topInfoLabel.text = [NSString stringWithFormat:@"%@ 订阅, %@ 文章",@(totalFeedCount),@(totalItemCount)];
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemUIEntity *feedItem = [_dataset objectAtIndex:indexPath.row];
    
    WebViewController *webViewController = [[WebViewController alloc]init];
    [[MainContext sharedContext].mainNavigationController pushViewController:webViewController animated:YES];
    webViewController.title = feedItem.title;
    
    NSString *url = feedItem.link;
    if(!url) url = feedItem.identifier;
    [webViewController loadURLString:feedItem.link];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
