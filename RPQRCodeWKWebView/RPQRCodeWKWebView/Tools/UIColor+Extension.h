//
//  UIColor+Extension.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KPRGBColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#define KPRGBAColor(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

#define UIRandomColor [UIColor randomColor]

#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

@interface UIColor (Extension)

/// 随机颜色
+(UIColor *)randomColor;

/// 用HexString创建一个color
///
/// @param hexStr HexString
///
/// @return color
+ (UIColor *)colorWithHexString:(NSString *)hexStr;





/**
 *  根据RGB返回UIColor。
 *  @param  red、green、blue:范围0—255。
 *  @param  alpha:透明度。
 *  return  UIColor。
 */
+(UIColor *)red:(CGFloat)red green:(CGFloat )green blue:(CGFloat)blue alpha:(CGFloat)alpha;





@end
