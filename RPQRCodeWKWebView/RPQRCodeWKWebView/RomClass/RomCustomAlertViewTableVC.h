//
//  RomCustomAlertViewTableVC.h
//  RomAlertView
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RomCustomAlertViewTableVCDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RomCustomAlertViewTableVC : UITableViewController

@property (strong , nonatomic) NSArray* dataArray;
/**
 *  是否允许改变颜色
 */
@property (nonatomic, assign) BOOL isChangeColor;
/**
 *  字体颜色
 */
@property (nonatomic, strong) UIColor *color;

@property (assign , nonatomic) id<RomCustomAlertViewTableVCDelegate> delegate;

@property (nonatomic, assign) BOOL isChangeFont;


@end
