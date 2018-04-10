//
//  NSObject+UserDefined.h
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UserDefined)
- (id)exceptNull;
- (id)exceptNullString;
- (id)exceptNull0;

//当数据data没有数据的时候，返回来的数据是NSArray类型的
//要是有数据的话，一般返回的是NSDictionary类型
- (id)exceptNotArray;

- (id)exceptNullForArray;

- (id)exceptNotDictionary;

- (id)exceptNotFalse;


//净值(latestNetPresentValue) 涨跌幅(latestNetPresentValueChange)  万份收益(latest10kAccrual) 七日年化(latest7daysYearsYield)
//是不是null,如果净值是null 显示 --

//返回字符串 : -100000000,然后在页面进行处理
- (id)exceptNullForSpecialFund;

//如果服务返回null，，解析到为<null>，，，这种情况显示--
- (id)exceptNullHorizontalLine;
@end

