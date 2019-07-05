//
//  BaiduMobAdWebView.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 01/02/2018.
//  Copyright © 2018 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class BaiduMobAdWebView;

typedef NS_ENUM(NSInteger,BDWebViewNavigationType) {
    /**
     *  A link with an href attribute was activated by the user.
     */
    BDWebViewNavigationTypeLinkClicked,
    /**
     *  A form was submitted.
     */
    BDWebViewNavigationTypeFormSubmitted,
    /**
     *  An item from the back-forward list was requested.
     */
    BDWebViewNavigationTypeBackForward,
    /**
     *  The webpage was reloaded.
     */
    BDWebViewNavigationTypeReload,
    /**
     *  A form was resubmitted (for example by going back, going forward, or reloading).
     */
    BDWebViewNavigationTypeFormResubmitted,
    /**
     *  Navigation is taking place for some other reason.
     */
    BDWebViewNavigationTypeOther
};


@protocol BaiduMobAdWebViewDelegate <NSObject>
- (BOOL)bdWebView:(BaiduMobAdWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(BDWebViewNavigationType)navigationType;
- (void)bdWebViewDidStartLoad:(BaiduMobAdWebView *)webView;
- (void)bdWebViewDidFinishLoad:(BaiduMobAdWebView *)webView;
- (void)bdWebView:(BaiduMobAdWebView *)webView didFailLoadWithError:(NSError *)error;
@end

@interface BaiduMobAdWebView : UIView <WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIView *webview;
@property (nonatomic, weak) id<BaiduMobAdWebViewDelegate> delegate;
@property (nonatomic, assign) BOOL useUIWebView;//强制使用UIWebView

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (void)excuteJavaScript:(NSString *)javaScriptString completionHandler:(void(^)(id params, NSError * error))completionHandler;

- (instancetype)initWithFrame:(CGRect)frame UseUIWebView:(BOOL)useUIWebView;

@end
