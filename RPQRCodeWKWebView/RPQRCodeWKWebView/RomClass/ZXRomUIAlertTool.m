//
//  ZXRomUIAlertTool.m
//  XingChangTong
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZXRomUIAlertTool.h"
#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
typedef void (^confirm)();
typedef void (^cancle)();
static confirm confirmParam;
static cancle  cancleParam;
static UIAlertController *_alertController = nil;
static UIAlertView *_TitleAlert = nil;
@interface ZXRomUIAlertTool (){
    //    confirm confirmParam;
    //    cancle  cancleParam;
}

@end
@implementation ZXRomUIAlertTool
+ (void)showAlertView:(UIViewController *)viewController WithTitle:(NSString *)title WithMessage:(NSString *)message WithCancelTitle:(NSString *)cancelButtonTitle WithOtherTitle:(NSString *)otherButtonTitle WithConfirmBlock:(void (^)())confirm WithCancleBlock:(void (^)())cancle{
    confirmParam=confirm;
    cancleParam=cancle;
    if (IAIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        _alertController = alertController;
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancle();
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:cancelButtonTitle,nil];
        _TitleAlert = TitleAlert;
        [TitleAlert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else{
        cancleParam();
    }
}

+ (void)removeAlertView:(UIViewController *)viewController
{
    if (IAIOS8) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [_TitleAlert dismissWithClickedButtonIndex:0 animated:NO];
        
    }
}


+(void)showAlertView:(UIViewController *)viewController WithTitle:(NSString *)title WithMessage:(NSString *)message WithOtherTitle:(NSString *)otherButtonTitle WithConfirmBlock:(void (^)())confirm
{
    confirmParam=confirm;
    if (IAIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        _alertController = alertController;
        
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        
        [alertController addAction:otherAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:nil,nil];
        _TitleAlert = TitleAlert;
        [TitleAlert show];
    }
    
}





@end

