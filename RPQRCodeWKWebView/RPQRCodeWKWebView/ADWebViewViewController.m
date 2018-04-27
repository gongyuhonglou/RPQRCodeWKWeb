//
//  ADWebViewViewController.m
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ADWebViewViewController.h"
#import "WeakScriptMessageDelegate.h"
#import <Photos/Photos.h>
#import "UIView+Toast.h"

@interface ADWebViewViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,MBProgressHUDDelegate,RomAlertViewDelegate,UIGestureRecognizerDelegate>
{
    WKWebView *_detailWebView;
    
    WKWebViewConfiguration *wkConfig;
    
    UIImageView *backImageView;
    UILabel *backLabel;
    UIButton *closeButton;
    NSString *QRurlStr;
    RPLabel *QRCodeLabel;
    
    RomAlertView *alertview;
    UIImage *_saveImage;
    NSString *qrCodeUrl;
}

@property (nonatomic,strong)    UIView *topView;//顶部的view
@property (nonatomic,strong)    UILabel *topTitleLabel;

@property (strong, nonatomic) UIProgressView *progressView;

/**没有数据的时候背景图片*/
@property (nonatomic, strong) UIImageView *imageView_Bg;
@end

@implementation ADWebViewViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [_detailWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_detailWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_detailWebView removeObserver:self  forKeyPath:@"estimatedProgress" context:nil];
    [_detailWebView removeObserver:self  forKeyPath:@"title" context:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView=[[UIView alloc] init];
    self.topView.frame=CGRectMake(0, 64, __gScreenWidth, __gTopViewHeight);
    self.topView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    self.topView.clipsToBounds = YES;
    [self.view addSubview:self.topView];
    
    backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"common_back_gary"];//common_back.png
    backImageView.frame = CGRectMake(10, 33+(__MainStatusBarHeight-20), backImageView.image.size.width, backImageView.image.size.height);
    [self.topView addSubview:backImageView];
    
    backLabel = [[UILabel alloc] init];
    backLabel.text = @"返回";
    backLabel.frame = CGRectMake(10+backImageView.image.size.width+5,33+(__MainStatusBarHeight-20),35,backImageView.image.size.height);
    [self.topView addSubview:backLabel];
    
    closeButton = [[UIButton alloc] init];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(10+backImageView.image.size.width+backLabel.bounds.size.width+10,33+(__MainStatusBarHeight-20),40,backImageView.image.size.height);
    [closeButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 10+backImageView.image.size.width+backLabel.bounds.size.width, __MainTopHeight)];
    [backButton addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backButton];
    
    self.topTitleLabel=[[UILabel alloc] init];
    self.topTitleLabel.backgroundColor=[UIColor clearColor];
    self.topTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.topTitleLabel.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.topTitleLabel.font=[UIFont systemFontOfSize:18];
    self.topTitleLabel.text = self.m_title;
    [self.topView addSubview:self.topTitleLabel];
    
    
    
    if([self.m_url exceptNull] == nil){
        _imageView_Bg = [[UIImageView alloc] init];
        _imageView_Bg.image = [UIImage imageNamed:@"UC_NotingData"];
        _imageView_Bg.center = CGPointMake(__gScreenWidth/2.0, __gTopViewHeight/2.0);
        _imageView_Bg.bounds  = CGRectMake(0, 0, _imageView_Bg.image.size.width, _imageView_Bg.image.size.height);
        [self.view addSubview:_imageView_Bg];
        
        return;
    }
    
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, __MainTopHeight-2, self.view.frame.size.width,0)];
    _progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    _progressView.tintColor = [UIColor colorWithHexString:@"#007aff"];
    _progressView.trackTintColor = [UIColor whiteColor];
    [self.topView addSubview:_progressView];
    
    
    wkConfig = [[WKWebViewConfiguration alloc] init];
    // iPhone Safari defaults to NO. iPad Safari defaults to YES
    // 设置是否使用内联播放器播放视频
    wkConfig.allowsInlineMediaPlayback = YES;
    // iPhone and iPad Safari both default to YES
    // 设置视频是否自动播放
    if ([wkConfig respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
        [wkConfig setMediaPlaybackRequiresUserAction:YES];//API_DEPRECATED_WITH_REPLACEMENT("requiresUserActionForMediaPlayback", ios(8.0, 9.0));
    }
    if ([wkConfig respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
        [wkConfig setRequiresUserActionForMediaPlayback:YES];//API_DEPRECATED_WITH_REPLACEMENT("mediaTypesRequiringUserActionForPlayback", ios(9.0, 10.0));
    }
    if ([wkConfig respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
        [wkConfig setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeVideo];//API_AVAILABLE(macosx(10.12), ios(10.0));
    }
    
    
    _detailWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height - __MainTopHeight) configuration:wkConfig];
    if (@available(iOS 11.0, *)) {
        _detailWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _detailWebView.UIDelegate = self;
    _detailWebView.navigationDelegate = self;
    _detailWebView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_detailWebView];
    
    // 添加长按手势识别二维码
    [self WKWebViewHandleLongPress:_detailWebView];
    
    WKUserContentController *userCC = wkConfig.userContentController;
    
    WeakScriptMessageDelegate *delegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    //优惠券
    [userCC addScriptMessageHandler:delegate name:@"jsAppTelphone"];//领取优惠券
    
    // 识别二维码跳转;不是链接显示内容点击网址跳转
    if ([self.m_url hasPrefix:@"http"]) {
        //        NSString *urlStr = [self.m_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 解决url包含中文不能编码的问题
        NSString *urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.m_url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setHTTPShouldHandleCookies:YES];
        [_detailWebView loadRequest:request];
        
    } else {
        self.topTitleLabel.text = @"扫描结果";
        
        QRCodeLabel = [[RPLabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 50) fontSize:16 text:@"" textColor:[UIColor colorWithHexString:@"#000000"] textAlignment:NSTextAlignmentLeft numberOfLines:0];
        [_detailWebView addSubview:QRCodeLabel];
        
        if ([self urlValidation:[NSString stringWithFormat:@"%@",self.m_url]]==YES) {//网址
            [self textColour];
            QRurlStr = [NSString stringWithFormat:@"http://%@",[NSString stringWithFormat:@"%@",self.m_url]];
        } else {
            // 文字html可拷贝，查询
            // @"<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'><style>*{margin:5px;padding:0px;}</style><title></title></head<body><pre>%@</pre></body></html>"
            // 解决html适配屏幕的宽度和保留源文件的格式显示
            QRurlStr = [NSString stringWithFormat:
                        @"<html><head><meta charset='UTF-8'><meta name='viewport' content='initial-scale=1,maximum-scale=1, minimum-scale=1'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><title></title><style>*{margin: 0;padding: 0;box-sizing: border-box;}pre {/* width: 6.4rem; */padding: 10px;font-size: 15px;color: #333;text-align: justify;white-space: pre-wrap; /*css-3*/white-space: -moz-pre-wrap; /*Mozilla,since1999*/ white-space: -pre-wrap; /*Opera4-6*/white-space: -o-pre-wrap; /*Opera7*/word-wrap: break-word; /*InternetExplorer5.5+*/ }</style></head><body><pre>%@</pre></body><script>(function() { function getViewPort()  {if(document.compatMode == 'BackCompat') { return {width: document.body.clientWidth,height: document.body.clientHeight}; } else {return {width: document.documentElement.clientWidth,height: document.documentElement.clientHeight};} }function screenZoom() {var _obj = getViewPort(); var Width = _obj.width;var Height = _obj.height;if (Width>640) { Width = 640;}document.documentElement.style.fontSize = Width/6.4 + 'px';}screenZoom();window.onresize = function() {screenZoom();};})();</script></html>",[NSString stringWithFormat:@"%@",self.m_url]];
            [_detailWebView loadHTMLString:QRurlStr  baseURL:Nil];
        }
    }
    
    [self backgroundImageHide:YES];
}

#pragma mark -- 背景图片
- (UIImageView *)imageView_Bg
{
    if (_imageView_Bg == nil) {
        _imageView_Bg = [[UIImageView alloc] init];
        _imageView_Bg.image = [UIImage imageNamed:@"v3.4_loading_fail"];
        _imageView_Bg.center = CGPointMake(__gScreenWidth/2.0, __gTopViewHeight/2.0-32);
        _imageView_Bg.bounds  = CGRectMake(0, 0, _imageView_Bg.image.size.width, _imageView_Bg.image.size.height);
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewTap)];
        _imageView_Bg.userInteractionEnabled=YES;
        [_imageView_Bg addGestureRecognizer:tap];
        [self.view addSubview:_imageView_Bg];
    }
    return _imageView_Bg;
}
-(void)userImageViewTap{
    _detailWebView.hidden = NO;
    [self backgroundImageHide:YES];
    
    NSString *urlStr = [self.m_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [_detailWebView loadRequest:request];
}
#pragma mark -- 背景图设置
- (void)backgroundImageHide:(BOOL)hideState
{
    if (hideState == YES) {// 隐藏
        self.imageView_Bg.hidden = YES;
    }else{// 显示
        self.imageView_Bg.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"jsAppTelphone"]){
        id body = message.body;
        if([body isKindOfClass:[NSString class]]){
            NSString *m_msg = (NSString *)body;
            if (nil != m_msg) {
                if ([[UIApplication sharedApplication ] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",m_msg]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",m_msg]]];
                }else{
                    [self HUDShow:@"设备不支持拨号功能" delay:2];
                }
            }else{
                [self HUDShow:@"该商家没有联系电话" delay:2];
            }
        }else if([body isKindOfClass:[NSArray class]]){
            NSArray *array = (NSArray *)body;
            if(array.count>0){
                NSString *m_msg = (NSString *)body[0];
                if (nil != m_msg) {
                    if ([[UIApplication sharedApplication ] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",m_msg]]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",m_msg]]];
                    }else{
                        [self HUDShow:@"设备不支持拨号功能" delay:2];
                    }
                }else{
                    [self HUDShow:@"该商家没有联系电话" delay:2];
                }
            }
            
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _detailWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if (object == _detailWebView && [keyPath isEqualToString:@"title"]) {
        self.title = _detailWebView.title;
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 其他
//- (void)_webViewWebProcessDidCrash:(WKWebView *)webView {
//    NSLog(@"WebContent process crashed; reloading");
//}
//- (void)webView:(WKWebView *)webView didFinishLoadingNavigation:(WKNavigation *)navigation {
//    NSLog(@"didFinishLoadingNavigation: %@", navigation);
//}
#pragma mark - WKNavigationDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (webView.canGoBack == YES) {
        NSLog(@"关闭");
        
        [self.topView addSubview:closeButton];
        self.topTitleLabel.frame=CGRectMake(10+backImageView.image.size.width+backLabel.bounds.size.width+closeButton.bounds.size.width+10, 33+(__MainStatusBarHeight-20), __gScreenWidth-2*(10+backImageView.image.size.width+backLabel.bounds.size.width+closeButton.bounds.size.width+10), backImageView.bounds.size.height);
    } else {
        NSLog(@"隐藏");
        
        [closeButton removeFromSuperview];
        self.topTitleLabel.frame=CGRectMake(10+backImageView.image.size.width+backLabel.bounds.size.width+10, 33+(__MainStatusBarHeight-20), __gScreenWidth-2*(10+backImageView.image.size.width+backLabel.bounds.size.width+10), backImageView.bounds.size.height);
    }
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [url resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        //        });
        if ([[UIApplication sharedApplication ] canOpenURL:[NSURL URLWithString:callPhone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }else{
            [self HUDShow:@"设备不支持拨号功能" delay:2];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else if([url.absoluteString isEqualToString:@"about:blank"]) {//主页面加载内容
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else if ([url.absoluteString rangeOfString:@"//itunes.apple.com/"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if (![url.absoluteString hasPrefix:@"http://"] && ![url.absoluteString hasPrefix:@"https://"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"即将离开APP\n打开其他应用" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        } else {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation: %@", navigation);
}
// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation: %@", navigation);
}
// 页面加载失败时调用(暂时)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailProvisionalNavigation: %@navigation, error: %@", navigation, error);
    
    _detailWebView.hidden = YES;
    [self backgroundImageHide:NO];
    
}
// 当内容开始返回(获取到网页内容) 时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation: %@", navigation);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didFinish: %@; stillLoading:%@", [webView URL], (webView.loading?@"NO":@"YES"));
    
    // 禁止系统的弹框，不执行前段界面弹出列表的JS代码
    [self webkitTouchCallout:webView];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation: %@, error %@", navigation, error);
}
// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//}
// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    [webView reload];
}
#pragma mark - WKNavigationDelegate  UI界面相关，原生控件支持，三种提示框：输入、确认、警告。首先将web提示框拦截然后再做处理。
//WKWebView does not open any links which have target="_blank" aka. 'Open in new Window' attribute in their HTML -Tag.
// 创建一个新的WebView
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    
}
// web界面中有弹出 警告框 时调用
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
//{
//
//}
//// web界面中有弹出 确认框 时调用
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
//{
//
//}
//// web界面中有弹出 输入框 时调用
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
//{
//
//}

#if TARGET_OS_IPHONE

//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0))
//{
//
//}
//- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0))
//{
//
//}
//- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0))
//{
//
//}
#endif

#pragma mark - MBProgressHUD   self.view
-(void) initHUD
{
    if (_HUD == nil ) {
        /*
         UIWindow *defaultWindow = [HKGlobal defaultWindow];
         HUD = [[MBProgressHUD alloc]initWithView:defaultWindow];
         [defaultWindow addSubview:HUD];
         HUD.delegate = self;
         */
        _HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.delegate = self;
    }
}
-(void)HUDShow:(NSString*)text
{
    [self initHUD];
    _HUD.labelText = text;
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
}
-(void)HUDShow:(NSString*)text delay:(float)second
{
    [self initHUD];
    _HUD.labelText = text;
    _HUD.mode = MBProgressHUDModeText;
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:second];
}

#pragma mark -MBProgressHUD    UIWindow
-(void) initHUD_window
{
    if (nil == _HUD_window) {
        UIWindow *defaultWindow = [[UIApplication sharedApplication].delegate window];
        _HUD_window = [[MBProgressHUD alloc]initWithView:defaultWindow];
        [defaultWindow addSubview:_HUD_window];
        _HUD_window.delegate = self;
    }
}
-(void)HUDShow_window:(NSString*)text
{
    [self initHUD_window];
    _HUD_window.labelText = text;
    _HUD_window.mode = MBProgressHUDModeIndeterminate;
    [_HUD_window show:YES];
}
-(void)HUDShow_window:(NSString*)text delay:(float)second
{
    [self initHUD_window];
    _HUD_window.labelText = text;
    _HUD_window.mode = MBProgressHUDModeText;
    [_HUD_window show:YES];
    [_HUD_window hide:YES afterDelay:second];
}
#pragma mark -MBProgressHUD  delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if(hud == _HUD_window){
        [_HUD_window removeFromSuperview];
        _HUD_window = nil;
    }
    if(hud == _HUD){
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    
}



#pragma mark -- 识别图中二维码

// app内部识别二维码
/**
 *  网址正则验证
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)urlValidation:(NSString *)string {
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:match.range];
        NSLog(@"匹配--%@",substringForMatch);
        return YES;
    }
    return NO;
}

- (void)textColour {
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.m_url]];
    [abs beginEditing];
    //字体大小
    //        [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, 2)];
    //字体颜色
    [abs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]  range:NSMakeRange(0, [NSString stringWithFormat:@"%@",self.m_url].length)];
    //下划线
    [abs addAttribute:NSUnderlineStyleAttributeName  value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, [NSString stringWithFormat:@"%@",self.m_url].length)];
    QRCodeLabel.attributedText = abs;
    UITapGestureRecognizer *LabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(capchaBtn:)];
    QRCodeLabel.userInteractionEnabled = YES;
    [QRCodeLabel addGestureRecognizer:LabelTap];
}

// 链接跳转
- (void)capchaBtn:(UITapGestureRecognizer *)sendr{
    NSLog(@"跳转网页~~");
    [QRCodeLabel removeFromSuperview];
    NSString *urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)QRurlStr,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [_detailWebView loadRequest:request];
}


#pragma mark -- 返回上一级
- (void)backPress:(id)sender {
    //判断是否能返回到H5上级页面
    if (_detailWebView.canGoBack==YES) {
        //返回上级页面
        [_detailWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- common WKWebView长按网页内部图片识别二维码
-(void)WKWebViewHandleLongPress:(WKWebView *)webView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(webViewHandleLongPress:)];
    longPress.minimumPressDuration = 0.2;
    longPress.delegate = self;
    [webView addGestureRecognizer:longPress];
}

- (void)webkitTouchCallout:(WKWebView *)webView
{
    // 不执行前段界面弹出列表的JS代码
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
}

// 是否允许支持多个手势,默认是不支持:NO
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// 网页内长按识别二维码
- (void)webViewHandleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [sender locationInView:_detailWebView];
        // 获取长按位置对应的图片url的JS代码
        NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        // 执行对应的JS代码 获取url
        [_detailWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
            if (imgUrl) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                UIImage *image = [UIImage imageWithData:data];
                if (!image) {
                    NSLog(@"读取图片失败");
                    return;
                }
                _saveImage = image;
                
                // 禁用选中效果
                [self webkitTouchCallout:_detailWebView];
                
                if ([self isAvailableQRcodeIn:image]) {
                    [self filterPopViewWithTag:100002 WithTitleArray:[NSMutableArray arrayWithObjects:@"保存图片",@"识别图中二维码",nil]];
                } else {
                    [self filterPopViewWithTag:100001 WithTitleArray:[NSMutableArray arrayWithObjects:@"保存图片",nil]];
                }
                
            } else {
                // 选中效果
                [_detailWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='text'" completionHandler:nil];
                [_detailWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='text'" completionHandler:nil];
            }
        }];
    }
}

-(void)filterPopViewWithTag:(int)tag WithTitleArray:(NSMutableArray *)titleArray
{
    // 初始化弹框 第一个参数是设置距离底部的边距
    RomAlertView *alertview = [[RomAlertView alloc] initWithMainAlertViewBottomInset:0 Title:nil detailText:nil cancelTitle:nil otherTitles:titleArray];
    alertview.tag = tag;
    // 设置弹框的样式
    alertview.RomMode = RomAlertViewModeBottomTableView;
    // 设置弹框从什么位置进入 当然也可以设置什么位置退出
    [alertview setEnterMode:RomAlertEnterModeBottom];
    // 设置代理
    [alertview setDelegate:self];
    // 显示 必须调用 和系统一样
    [alertview show];
}

#pragma mark -- RomAlertViewDelegate 弹框识别图中二维码
// 判断是web网页图片否存在二维码
- (BOOL)isAvailableQRcodeIn:(UIImage *)img {
    
    //方法：一
    //    UIGraphicsBeginImageContextWithOptions(img.size, NO, 3);//0，获取当前屏幕分辨率[UIScreen mainScreen].scale
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    [self.view.layer renderInContext:context];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //方法：二
    UIImage *image = [self snapshot:self.view];
    
    //方法：三
    //    UIImage *image = [self imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor] withImage:img];
    
    
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count > 0) {
        //        for (CIQRCodeFeature *feature in features) {
        //        NSLog(@"qrCodeUrl = %@",feature.messageString); // 打印二维码中的信息
        //        qrCodeUrl = feature.messageString;
        //    }
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        qrCodeUrl = [feature.messageString copy];
        NSLog(@"二维码信息:%@", qrCodeUrl);
        return YES;
    } else {
        NSLog(@"图片中没有二维码");
        return NO;
    }
}

// you can also implement by UIView category
- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 3);//view.bounds.size, YES, view.window.screen.scale
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
// you can also implement by UIImage category
- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color withImage:(UIImage *)image
{
    CGSize size = image.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(-insets.left, -insets.top, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [image drawInRect:rect];
    UIImage *insetEdgedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return insetEdgedImage;
}


// 网页内部识别二维码
- (void)alertview:(RomAlertView *)alertview didSelectWebRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (alertview.tag == 100001) {
        if ([alertview.otherTitles[indexPath.row]  isEqualToString:@"保存图片"]) {
            NSLog(@"保存图片");
            //            UIImageWriteToSavedPhotosAlbum(_saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [self saveWebLongPressed];
            
        }
    } else if (alertview.tag == 100002) {
        if ([alertview.otherTitles[indexPath.row]  isEqualToString:@"保存图片"]) {
            NSLog(@"保存图片");
            //            UIImageWriteToSavedPhotosAlbum(_saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [self saveWebLongPressed];
            
        }else if ([alertview.otherTitles[indexPath.row] isEqualToString:@"识别图中二维码"]){
            NSLog(@"识别图中二维码");
            
            ADWebViewViewController *controller = [[ADWebViewViewController alloc] init];
            controller.m_url = qrCodeUrl;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
// 系统保存图片的方法
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    NSString *message = @"Succeed";
//    if (error) {
//        message = @"Fail";
//    }
//    NSLog(@"save result :%@", message);
//}

#pragma mark --web保存图片
//保存
- (void)saveWebLongPressed {
    //    if (webPhotoSave == YES) { // 图片已经保存到相册 提示
    //        [self.view makeToast:@"该图片已经保存到相册" duration:2 position:CSToastPositionCenter];
    //        return;
    //    }
    [self saveWebPhoto];
}

- (void)saveWebPhoto {
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    //  保存图片到相册
                    [self saveWebImageIntoAlbum];
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    NSLog(@"提醒用户打开相册的访问开关");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存"        message:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的照片。" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存"        message:@"因系统原因，无法访问相册！" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        });
    }];
}


// 获得刚才添加到【相机胶卷】中的图片
- (PHFetchResult<PHAsset *> *)createdAssets {
    
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:_saveImage].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

//获得【自定义相册】
-(PHAssetCollection *)createdCollection {
    // 获取软件的名字作为相册的标题(如果需求不是要软件名称作为相册名字就可以自己把这里改成想要的名称)
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (createdCollectionId == nil) return nil;
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

//保存图片到相册
- (void)saveWebImageIntoAlbum {
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdAssets == nil || createdCollection == nil) {
        
        [self.view makeToast:@"图片保存失败！" duration:2 position:CSToastPositionCenter];
        return;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 保存结果
    NSString *msg = nil ;
    if(error){
        msg = @"图片保存失败！";
        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
    }else{
        msg = @"已成功保存到系统相册";
        //        webPhotoSave = YES;
        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
    }
}

@end
