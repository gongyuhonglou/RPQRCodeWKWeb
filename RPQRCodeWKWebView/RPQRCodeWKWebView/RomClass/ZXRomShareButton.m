//
//  ZXRomShareButton.m
//  XingChangTong
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZXRomShareButton.h"

@implementation ZXRomShareButton



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)click:(ZXRomShareButton *)btn
{
    if (_block) {
        _block(btn);
    }
}

+ (instancetype)createRomButton
{
    return [ZXRomShareButton buttonWithType:UIButtonTypeCustom];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(self.bounds.size.width/2.0, 30);
    self.imageView.bounds = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+3, self.bounds.size.width, 20);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
