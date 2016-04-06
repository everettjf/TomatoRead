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

@interface MainViewController ()
@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSArray<__kindof UIViewController*> *subPageViews;
@property (strong,nonatomic) NSArray<__kindof UIViewController*> *subPageControllers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"iOS 博客精选";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self _setupSegmentedControl];
    [self _setupSubPages];
}

- (NSArray*)_getPageTitles{
    return @[
            @"订阅",
            @"博客",
            @"文章",
            @"教程",
            @"社区",
            @"源码",
            @"工具",
            @"大牛堂",
            ];
}

- (void)_setupSegmentedControl{
    NSArray *pageTitles = [self _getPageTitles];
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
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
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
