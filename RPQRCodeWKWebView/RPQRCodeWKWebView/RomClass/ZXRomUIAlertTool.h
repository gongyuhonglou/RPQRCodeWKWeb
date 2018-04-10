//
//  ZXRomUIAlertTool.h
//  XingChangTong
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZXRomUIAlertTool : NSObject
//-(void)showAlertView:(UIViewController *)viewController WithTitle:(NSString *)title WithMessage:(NSString *)message WithCancelTitle:(NSString *)cancelButtonTitle WithOtherTitle:(NSString *)otherButtonTitle WithConfirmBlock:(void (^)())confirm WithCancleBlock:(void (^)())cancle;
+ (void)showAlertView:(UIViewController *)viewController WithTitle:(NSString *)title WithMessage:(NSString *)message WithCancelTitle:(NSString *)cancelButtonTitle WithOtherTitle:(NSString *)otherButtonTitle WithConfirmBlock:(void (^)())confirm WithCancleBlock:(void (^)())cancle;

// 一个确定按钮
+(void)showAlertView:(UIViewController *)viewController WithTitle:(NSString *)title WithMessage:(NSString *)message WithOtherTitle:(NSString *)otherButtonTitle WithConfirmBlock:(void (^)())confirm;

+ (void)removeAlertView:(UIViewController *)viewController;

@end
