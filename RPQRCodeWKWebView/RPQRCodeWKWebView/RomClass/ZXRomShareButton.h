//
//  ZXRomShareButton.h
//  XingChangTong
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXRomShareButton;
typedef void(^RomButtomClickBlock)(ZXRomShareButton *btn);

@interface ZXRomShareButton : UIButton
/**回调*/
@property (nonatomic, copy) RomButtomClickBlock block;

//- (instancetype)initWithFrame:(CGRect)frame;
//- (void)click:(RomButton *)btn;
+ (instancetype)createRomButton;
@end
