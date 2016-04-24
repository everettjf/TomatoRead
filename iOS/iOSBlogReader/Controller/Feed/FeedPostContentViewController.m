//
//  FeedPostContentViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedPostContentViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"

@interface FeedPostContentViewController ()
@property (strong,nonatomic) WKWebView *webView;
@property (strong,nonatomic) FeedItemUIEntity *post;

@end

@implementation FeedPostContentViewController

- (instancetype)initWithFeedPost:(FeedItemUIEntity *)post{
    self = [super init];
    if (self) {
        _post = post;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _post.title;
    
    _webView = [WKWebView new];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIBarButtonItem *viewLinkButton = [[UIBarButtonItem alloc]initWithTitle:@"查看原文" style:UIBarButtonItemStylePlain target:self action:@selector(_viewLinkTapped:)];
    self.navigationItem.rightBarButtonItems = @[viewLinkButton];
    
    [self _loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadContent{
    NSString *cssFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"css.html"];
    NSString *cssString = [NSString stringWithContentsOfFile:cssFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *postFilePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"post.html"];
    NSString *postString = [NSString stringWithContentsOfFile:postFilePath encoding:NSUTF8StringEncoding error:nil];

    NSString *content = _post.content;
    if(!content) content = _post.summary;
    
    NSString *htmlContent = [NSString stringWithFormat:postString, cssString, _post.title, content];
    [_webView loadHTMLString:htmlContent baseURL:nil];
}

- (void)_viewLinkTapped:(id)sender{
    WebViewController *webViewController = [[WebViewController alloc]init];
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.title = _post.title;
    
    NSString *url = _post.link;
    if(!url) url = _post.identifier;
    NSLog(@"url = %@", url);
    [webViewController loadURLString:url];
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
