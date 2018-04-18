//
//  MainViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "DiscoverViewController.h"
#import <HMSegmentedControl.h>
#import "AppUtil.h"
#import "LinkViewController.h"
#import "PageDataset.h"
#import "MainContext.h"
#import "MagicCubeProgressBox.h"
#import "AboutViewController.h"

@interface DiscoverViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray<__kindof UIView*> *subPageViews;
@property (strong,nonatomic) NSMutableArray<__kindof UIViewController*> *subPageControllers;
@property (strong,nonatomic) NSArray<PageItemEntity *> *pageItems;
@property (strong,nonatomic) MagicCubeProgressBox *progressBox;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"发现";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"  " style:UIBarButtonItemStylePlain target:self action:@selector(_aboutTapped:)];
    
    [MainContext sharedContext].discoverNavigationController = self.navigationController;
    
    _progressBox = [MagicCubeProgressBox boxWithParentView:self.view];
    [_progressBox setText:@"加载中"];
    [[PageDataset dataset]prepareDiscover:^(NSArray<PageItemEntity *> *items, BOOL succeed) {
        if(!succeed){
            [_progressBox setText:@"无法连接至服务器"];
            return;
        }
        self.pageItems = items;
        
        [self _setupSegmentedControl];
        [self _setupSubPages];
        
        [self _loadPageByIndex:0];
        
        [_progressBox hide];
        _progressBox = nil;
    }];
    
}


- (void)_setupSegmentedControl{
    NSMutableArray *pageTitles = [NSMutableArray new];
    [self.pageItems enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pageTitles addObject:obj.title];
    }];
    
    _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:pageTitles];
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.verticalDividerEnabled = NO;
    _segmentedControl.selectionIndicatorHeight = 2;
    _segmentedControl.selectionIndicatorColor = UIColorFromRGBA(0x007fff,1.0);
    _segmentedControl.backgroundColor = UIColorFromRGBA(0xf9f9f9, 1.0);
    
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        if(selected){
            return [[NSAttributedString alloc] initWithString:title
                                                   attributes: @{
                                         NSForegroundColorAttributeName : UIColorFromRGBA(0x007fff, 1.0),
                                         NSFontAttributeName : [UIFont systemFontOfSize:16]
                                     }
                    ];
        }
        return [[NSAttributedString alloc] initWithString:title
                                               attributes: @{
                                     NSForegroundColorAttributeName : [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0],
                                     NSFontAttributeName : [UIFont systemFontOfSize:16]
                                 }
                ];
    }];
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(@40);
    }];
}

- (void)_setupSubPages{
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_segmentedControl.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    _subPageViews = [NSMutableArray new];
    [self.pageItems enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subView = [UIView new];
        [_scrollView addSubview:subView];
        [_subPageViews addObject:subView];
    }];
    
    _subPageControllers = [NSMutableArray new];
    [self.pageItems enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LinkViewController *viewController = [[LinkViewController alloc]init];
        viewController.item = obj;
        [_subPageControllers addObject:viewController];
    }];
    
    // adjust size
    [self _adjustScrollPageSize];
}

- (void)_adjustScrollPageSize{
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat pageTopY = 40 + [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    CGFloat pageHeight = [UIScreen mainScreen].bounds.size.height - pageTopY - self.tabBarController.tabBar.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(pageWidth * _subPageViews.count, pageHeight);
    
    [_subPageViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx * pageWidth, 0, pageWidth, pageHeight);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    [self _selectPageByIndex:index];
    
    [self _loadPageByIndex:index];
}

- (void)_selectPageByIndex:(NSInteger)index{
    if(index < 0 || index >= _subPageViews.count) return;
    
    CGFloat pageWidth = _subPageViews.firstObject.frame.size.width;
    CGFloat pageHeight = _subPageViews.firstObject.frame.size.height;
    [_scrollView scrollRectToVisible:CGRectMake(pageWidth * index, 0, pageWidth, pageHeight) animated:NO];
}

- (void)_loadPageByIndex:(NSInteger)index{
    if(index < 0 || index >= _subPageViews.count) return;
    
    UIView *subView = [_subPageViews objectAtIndex:index];
    if(subView.subviews.count == 0){
        UIViewController *viewController = [_subPageControllers objectAtIndex:index];
        [subView addSubview:viewController.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger index = scrollView.contentOffset.x / pageWidth;
    
    [_segmentedControl setSelectedSegmentIndex:index animated:YES];
    [self _loadPageByIndex:index];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self _adjustScrollPageSize];
    [self _selectPageByIndex:_segmentedControl.selectedSegmentIndex];
}

- (void)_aboutTapped:(id)sender{
    AboutViewController *vc = [[AboutViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
