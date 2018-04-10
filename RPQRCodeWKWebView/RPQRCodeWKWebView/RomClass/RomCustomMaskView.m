//
//  RomCustomMaskView.m
//  RomAlertView
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RomCustomMaskView.h"

@implementation RomCustomMaskView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([_delegate respondsToSelector:@selector(customMaskView:)]) {
        
        [_delegate customMaskView:self];
    }
    
    NSLog(@"你点击了灰色蒙版---触发touchBegan事假");
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
