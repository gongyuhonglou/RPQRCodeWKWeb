//
//  RomCustomMaskView.h
//  RomAlertView
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RomCustomMaskView;

@protocol RomCustomMaskViewDelegate <NSObject>

- (void)customMaskView:(RomCustomMaskView *)maskView;

@end
@interface RomCustomMaskView : UIView
@property (nonatomic, assign) id<RomCustomMaskViewDelegate>delegate;
@end
