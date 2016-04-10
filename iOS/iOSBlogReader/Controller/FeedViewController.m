//
//  FeedViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedManager.h"

static NSString * kFeedCell = @"FeedCell";

@interface FeedViewController ()<FeedManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray<FeedItemModel*> *dataset;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataset = @[];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:kFeedCell];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    
    [FeedManager manager].delegate = self;
    [[FeedManager manager] loadFeeds];
}

- (void)feedManagerDidLoadFeeds:(NSArray<FeedItemModel *> *)feeds{
    _dataset = feeds;
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataset.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCell forIndexPath:indexPath];
    FeedItemModel *feedItem = [_dataset objectAtIndex:indexPath.row];
    
    cell.textLabel.text = feedItem.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
