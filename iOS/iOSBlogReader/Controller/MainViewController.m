//
//  MainViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "MainViewController.h"
#import <HMSegmentedControl.h>
#import <Masonry.h>
#import "AppUtil.h"
#import "FeedViewController.h"
#import "LinkViewController.h"
#import "PageDataset.h"

@interface MainViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray<__kindof UIView*> *subPageViews;
@property (strong,nonatomic) NSMutableArray<__kindof UIViewController*> *subPageControllers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"iOS 博客精选";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [SVProgressHUD showWithStatus:@"Loading"];
    [[PageDataset sharedDataset]prepare:^(BOOL succeed) {
        if(!succeed){
            [SVProgressHUD showWithStatus:@"Failed load."];
            return;
        }
        
        [self _setupSegmentedControl];
        [self _setupSubPages];
        
        [self _loadPageByIndex:0];
        
        [SVProgressHUD dismiss];
    }];
    
}


- (void)_setupSegmentedControl{
    NSMutableArray *pageTitles = [NSMutableArray new];
    [[PageDataset sharedDataset].items enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pageTitles addObject:obj.title];
    }];
    
    _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:pageTitles];
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.verticalDividerEnabled = NO;
    _segmentedControl.selectionIndicatorHeight = 2;
    _segmentedControl.selectionIndicatorColor = UIColorFromRGBA(0x09bb07,1.0);
    _segmentedControl.verticalDividerColor = UIColorFromRGBA(0xc7c7c7, 1.0);
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName : UIColorFromRGBA(0x555555, 1.0),
                                     NSFontAttributeName : [UIFont systemFontOfSize:15]
                                     };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        return attributedString;
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
        make.bottom.equalTo(self.view);
    }];
    
    NSArray<PageItemEntity*> *pageItems = [PageDataset sharedDataset].items;
    
    _subPageViews = [NSMutableArray new];
    [pageItems enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subView = [UIView new];
        subView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f];
        [_scrollView addSubview:subView];
        [_subPageViews addObject:subView];
    }];

    _subPageControllers = [NSMutableArray new];
    [pageItems enumerateObjectsUsingBlock:^(PageItemEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.type == PageItemType_Feed){
            FeedViewController *viewController = [[FeedViewController alloc]init];
            [_subPageControllers addObject:viewController];
        }else{
            LinkViewController *viewController = [[LinkViewController alloc]init];
            viewController.item = obj;
            [_subPageControllers addObject:viewController];
        }
    }];
    
    // adjust size
    [self _adjustScrollPageSize];
}

- (void)_adjustScrollPageSize{
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat pageTopY = 40 + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat pageHeight = [UIScreen mainScreen].bounds.size.height - pageTopY;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
