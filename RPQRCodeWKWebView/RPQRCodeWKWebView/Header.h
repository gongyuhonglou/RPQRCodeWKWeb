//
//  Header.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#ifndef Header_h
#define Header_h

//状态栏高度
#define __MainStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//顶部高度
#define __MainTopHeight (__MainStatusBarHeight+__MainNavHeight)//iphone:44+20  iphonex:44+44
//导航栏高度
#define __MainNavHeight 44
#define __gScreenWidth [UIScreen mainScreen].bounds.size.width
#define __gTopViewHeight [UIScreen mainScreen].bounds.size.height

#import "NSObject+UserDefined.h"
#import "UIColor+Extension.h"
#import "RomAlertView.h"
#import "RPLabel.h"
#import "MBProgressHUD.h"


/******************       ImageBrowser--begin             *************************/
#define WINDOW [UIApplication sharedApplication].delegate.window

#define AnimationDuration 0.75

typedef NS_ENUM(NSInteger,BrowseShowType)
{
    BrowseNoneType = 0,
    
    BrowsePushType,
    
    BrowseModalType,
    
    BrowseZoomType
};

typedef void(^scrollBlock)(NSInteger totalPage,NSInteger currentPage,UIView*pageView);

/******************        end            *************************/


#endif /* Header_h */
