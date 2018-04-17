//
//  RPLabel.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLabel : UILabel

/**
 *  自定义lable
 *
 *  @param frame      fram
 *  @param fontsize   字体大小<使用的是系统默认的字体>
 *  @param text   标题
 *  @param textcolor  字体的颜色
 *  @param alignment  对齐方式
 *  @param lines      行数 <默认1行>
 *  @param breakModel 换行方式 <系统默认的方式>
 *
 *  @return HHLable
 */
- (id)initWithFrame:(CGRect)frame
           fontSize:(CGFloat)fontsize
               text:(NSString *)text
          textColor:(UIColor *)textcolor
      textAlignment:(NSTextAlignment )alignment
      numberOfLines:(NSInteger)lines
      lineBreakMode:(NSLineBreakMode)breakModel;
/**
 *  自定义lable
 *
 *  @param frame      fram
 *  @param fontsize   字体大小<使用的是系统默认的字体>
 *  @param textcolor  字体的颜色
 *  @param alignment  对齐方式
 *  @param lines      行数 <默认1行>
 *
 *  @return HHLable
 */
- (id)initWithFrame:(CGRect)frame
           fontSize:(CGFloat)fontsize
               text:(NSString *)text
          textColor:(UIColor *)textcolor
      textAlignment:(NSTextAlignment )alignment
      numberOfLines:(NSInteger)lines;

@end
