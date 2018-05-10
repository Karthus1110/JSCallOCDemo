//
//  ViewController.m
//  JSCallOCDemo
//
//  Created by zY on 2018/5/9.
//  Copyright © 2018年 zY. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCallDelegate <JSExport>

- (NSString *)tipMessage;

@end

@interface ViewController () <UIWebViewDelegate, JSCallDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];//创建URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
}

#pragma mark - webview delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.jsContext =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 方法一
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"getMessage"] = ^(){
        return [weakSelf blockCallMessage];
    };
    
    // 方法二
    self.jsContext[@"JavaScriptInterface"] = self;
}

- (NSString *)blockCallMessage
{
    return @"call via block";
}

#pragma mark - JSCallDelegate
// 提供给JS调用的方法
- (NSString *)tipMessage
{
    return @"call via delegate";
}

@end
