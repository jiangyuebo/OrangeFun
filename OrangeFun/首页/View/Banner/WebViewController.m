//
//  WebViewController.m
//  OrangeFun
//
//  Created by Jerry on 2017/12/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WebViewController.h"
#import "ProjectHeader.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *bannerLinkURLString = [self.passDataDic objectForKey:key_banner_link];
    NSLog(@"banner link url : %@",bannerLinkURLString);
    
    self.webviewBanner.scalesPageToFit = YES;
    
    NSURL *linkURL = [NSURL URLWithString:bannerLinkURLString];
    NSURLRequest *linkRequest = [NSURLRequest requestWithURL:linkURL];
    [self.webviewBanner loadRequest:linkRequest];
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
