//
//  RPRPBrowseViewController.h
//  RPImageBrowser
//
//  Created by WRP on 2018/3/30.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RPBrowseViewController : UIViewController

/**
 初始化视图参数
 @param controller 当前的视图控制器对象，也可以是空对象
 @param index 默认显示的当前页数
 @return 视图对象
 */
+ (instancetype)showInController:(UIViewController*)controller imageDataSource:(NSArray*)imageUrls index:(NSInteger)index;

/**
 自定义指示器视图  可以不调用这个就不显示指示器
 @param pageView 指示器视图
 @param completion 滚动的时候的回调
 */
- (void)customPageView:(UIView*)pageView scrollPageCompletion:(scrollBlock)completion;

//默认图片
@property (nonatomic, strong)UIImage * placeholderImage;
/**
 显示视图 最后调用这个方法
 @param type 视图出现的动画类型
 */
- (void)showAnimationWithType:(BrowseShowType)type;

@end
