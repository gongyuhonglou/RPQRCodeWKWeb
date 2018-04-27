//
//  RPScrollContentView.h
//  RPImageBrowser
//
//  Created by WRP on 2018/4/4.
//  Copyright © 2018年 WRP. All rights reserved.
//

typedef void(^selectBlock)(int index);

typedef void(^tapBlock)(void);

#import <UIKit/UIKit.h>

@interface RPScrollContentView : UIView

- (void)loadImageUrls:(NSArray*)images defaultIndex:(NSInteger)index currentSelectIndex:(selectBlock)indexBlock;

- (void)tapViewBlock:(tapBlock)handleBlock;

@property (nonatomic,strong)UIImage * placeholderImage;

@end


