//
//  AboutViewController.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"main"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_topLayoutGuide).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:17];
    title.text = [NSString stringWithFormat:@"番茄阅读%@",appVersion];
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *subtitle = [UILabel new];
    subtitle.text = @"专注于精选 iOS/macOS 开发者博客";
    subtitle.font = [UIFont systemFontOfSize:14];
    subtitle.textColor = [UIColor grayColor];
    [self.view addSubview:subtitle];
    [subtitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    UIButton *bottom = [UIButton new];
    [bottom setTitle:@"everettjf" forState:UIControlStateNormal];
    bottom.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottom setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(_emailTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-10);
    }];

}

- (void)_emailTapped:(id)sender{
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.title = @"everettjf";
    [webViewController loadURLString:@"https://everettjf.github.io"];
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
