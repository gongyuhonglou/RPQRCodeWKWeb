//
//  ADWebViewViewController.m
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ADWebViewViewController.h"
#import "WeakScriptMessageDelegate.h"


@interface ADWebViewViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,MBProgressHUDDelegate>
{
    WKWebView *_detailWebView;
    
    WKWebViewConfiguration *wkConfig;
    
    UIImageView *backImageView;
    UILabel *backLabel;
    UIButton *closeButton;
    NSString *QRurlStr;
    RPLabel *QRCodeLabel;
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
    
    
    WKUserContentController *userCC = wkConfig.userContentController;
    
    WeakScriptMessageDelegate *delegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    //优惠券
    [userCC addScriptMessageHandler:delegate name:@"jsAppTelphone"];//领取优惠券
    
    // 识别二维码跳转;不是链接显示内容点击网址跳转
    if ([self.m_url hasPrefix:@"http"]) {
        NSString *urlStr = [self.m_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setHTTPShouldHandleCookies:YES];
        [_detailWebView loadRequest:request];
        
    } else {
        self.topTitleLabel.text = @"扫描结果";
        QRCodeLabel = [[RPLabel alloc]initWithFrame:CGRectMake(10, 10, __gScreenWidth-20, 50) fontSize:16 text:[NSString stringWithFormat:@"%@",self.m_url] textColor:[UIColor colorWithHexString:@"#000000"] textAlignment:NSTextAlignmentLeft numberOfLines:0];
        [_detailWebView addSubview:QRCodeLabel];
        
        if ([self urlValidation:QRCodeLabel.text]==YES) {
            [self textColour];
            QRurlStr = [NSString stringWithFormat:@"http://%@",QRCodeLabel.text];
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
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:QRCodeLabel.text];
    [abs beginEditing];
    //字体大小
    //        [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, 2)];
    //字体颜色
    [abs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]  range:NSMakeRange(0, QRCodeLabel.text.length)];
    //下划线
    [abs addAttribute:NSUnderlineStyleAttributeName  value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, QRCodeLabel.text.length)];
    QRCodeLabel.attributedText = abs;
    UITapGestureRecognizer *LabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(capchaBtn:)];
    QRCodeLabel.userInteractionEnabled = YES;
    [QRCodeLabel addGestureRecognizer:LabelTap];
}

// 链接跳转
- (void)capchaBtn:(UITapGestureRecognizer *)sendr{
    NSLog(@"跳转网页~~");
    [QRCodeLabel removeFromSuperview];
    NSString *urlStr = [QRurlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

@end

