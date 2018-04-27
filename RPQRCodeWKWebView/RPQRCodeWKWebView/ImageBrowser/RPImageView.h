//
//  RPImageView.h
//  RPImageBrowser
//
//  Created by WRP on 2018/3/29.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoDelegate <NSObject>

- (void)tapHiddenView;

@end

@interface RPImageView : UIView

- (void)setImageUrl:(NSString*)url placeHolderImage:(UIImage*)placeHolder;

@property (nonatomic, assign)id<PhotoDelegate> delegate;

@end
