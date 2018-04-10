//
//  ADWebViewViewController.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ViewController.h"

@interface ADWebViewViewController : ViewController

@property(strong,nonatomic) NSString *m_title;
@property(strong,nonatomic) NSString *m_url;


@property(assign,nonatomic) int m_flag;


//广告页面
//@"http://img.58cdn.com.cn/ds/other/gqcy/guoqingchuyou-m.html?from=m_home_huangye_banner_wuyichuyou&58hm=m_home_huangye_banner_wuyichuyou&58cid=2"


//天气url
//http://m.baidu.com/s?word=%E4%B8%8A%E6%B5%B7%E5%A4%A9%E6%B0%94

@property(retain,nonatomic)  MBProgressHUD *HUD;
@property(retain,nonatomic)  MBProgressHUD *HUD_window;

@end
