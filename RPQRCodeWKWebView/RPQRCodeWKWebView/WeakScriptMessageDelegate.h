//
//  WeakScriptMessageDelegate.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

//WKWebView在通过WKUserContentController添加MessageHandler方法用于JS调用Native导致ViewController内存泄露，无法正常释放。
@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

