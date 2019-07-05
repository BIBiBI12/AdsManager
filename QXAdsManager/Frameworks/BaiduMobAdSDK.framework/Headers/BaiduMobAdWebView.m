//
//  BaiduMobAdWebView.m
//  BaiduMobAdSDK
//
//  Created by lishan04 on 01/02/2018.
//  Copyright © 2018 Baidu Inc. All rights reserved.
//

#import "BaiduMobAdWebView.h"
#import <WebKit/WebKit.h>
#import "BaiduMobAdConfig.h"
#import "BaiduMobAdUtils.h"

@implementation BaiduMobAdWebView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame UseUIWebView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame UseUIWebView:(BOOL)useUIWebView{
    
    if (self = [super initWithFrame:frame]) {
        
        self.useUIWebView = useUIWebView;
        
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        WKWebView在8.0~9.0适配不好，因此替换H5Render 中的WK为9.0以上版本使用WKWebView YDJ
        if ([BaiduMobAdUtils systemVersion]>9.0 && !useUIWebView) {
            
            _webview = [[WKWebView alloc] initWithFrame:bounds];
//            [self setWKWebViewJSConfigWithFrame:bounds];
            ((WKWebView *)_webview).UIDelegate = self;
            ((WKWebView *)_webview).navigationDelegate = self;
            if (@available(iOS 11.0, *)) {
                ((WKWebView *)_webview).scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        } else {
            _webview = [[UIWebView alloc] initWithFrame:bounds];
            ((UIWebView *)_webview).delegate = self;
        }
        [self addSubview:_webview];
    }
    return self;
}

///注入JS以缩放网页
- (void)setWKWebViewJSConfigWithFrame:(CGRect)frame{
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    _webview = [[WKWebView alloc] initWithFrame:frame configuration:wkWebConfig];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);

    if ([BaiduMobAdUtils systemVersion]>9.0 && !self.useUIWebView) {
        [(WKWebView *)_webview setFrame:bounds];
    } else {
        [(UIWebView *)_webview setFrame:bounds];
    }
}

- (void)dealloc {
    if ([BaiduMobAdUtils systemVersion]>9.0 && !self.useUIWebView) {
        ((WKWebView *)_webview).UIDelegate = nil;
        ((WKWebView *)_webview).navigationDelegate = nil;
    } else {
        ((UIWebView *)_webview).delegate = nil;
    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    string = STRING_NOT_NULL(string);
    if ([BaiduMobAdUtils systemVersion]>9.0 && !self.useUIWebView) {
        [(WKWebView *)_webview loadHTMLString:string baseURL:baseURL];
    } else {
        [(UIWebView *)_webview loadHTMLString:string baseURL:baseURL];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _webview.backgroundColor = backgroundColor;
}

- (void)excuteJavaScript:(NSString *)javaScriptString completionHandler:(void(^)(id params, NSError * error))completionHandler {
    if ([BaiduMobAdUtils systemVersion]>9.0 && !self.useUIWebView) {
        [((WKWebView *)_webview) evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    } else {
        NSString *value = [((UIWebView *)_webview) stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (value && completionHandler) {
            completionHandler(value,nil);
        }
    }
}

- (void)loadRequest:(NSURLRequest *)request
{
    if ([BaiduMobAdUtils systemVersion]>9.0 && !self.useUIWebView) {
        [(WKWebView *)_webview loadRequest:request];
    } else {
        [(UIWebView *)_webview loadRequest:request];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.delegate respondsToSelector:@selector(bdWebView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate bdWebView:self shouldStartLoadWithRequest:request navigationType:(BDWebViewNavigationType)navigationType];
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(bdWebView:didFailLoadWithError:)]) {
        [self.delegate bdWebView:self didFailLoadWithError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.delegate respondsToSelector:@selector(bdWebViewDidFinishLoad:)]) {
        [self.delegate bdWebViewDidFinishLoad:self];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL isNavigator = YES;
    if ([self.delegate respondsToSelector:@selector(bdWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        isNavigator = [self.delegate bdWebView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(BDWebViewNavigationType)(navigationAction.navigationType < 0? navigationAction.navigationType : 5)];
    }
    
    if (!isNavigator) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(bdWebViewDidStartLoad:)]) {
        [self.delegate bdWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(bdWebView:didFailLoadWithError:)]) {
        [self.delegate bdWebView:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(bdWebViewDidFinishLoad:)]){
        [self.delegate bdWebViewDidFinishLoad:self];
    }
}


@end
