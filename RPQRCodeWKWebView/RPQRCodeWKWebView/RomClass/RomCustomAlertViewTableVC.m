//
//  RomCustomAlertViewTableVC.m
//  RomAlertView
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RomCustomAlertViewTableVC.h"
#import "RomCustomAlertViewCell.h"

@interface RomCustomAlertViewTableVC ()

@end

@implementation RomCustomAlertViewTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数组
    self.dataArray = [NSArray array];
    self.view.backgroundColor = [UIColor colorWithRed:206/255. green:207/255.0 blue:212/255.0 alpha:1];;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fitiOS11UitableViewUITableViewStyleGrouped];
}
- (void)fitiOS11UitableViewUITableViewStyleGrouped
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    RomCustomAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[RomCustomAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.isChangeColor == YES) {
        cell.textLabel.textColor = self.color;
    }else{
        cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
    
    //[cell setCellContentData:[self.m_ContentArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (self.isChangeFont == YES) {
       cell.textLabel.font = [UIFont systemFontOfSize:13];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}
@end
