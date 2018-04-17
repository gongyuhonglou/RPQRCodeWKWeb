//
//  UIImage+InsetEdge.h
//  WKWebView
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (InsetEdge)

- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;

@end
