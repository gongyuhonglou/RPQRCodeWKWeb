//
//  NSObject+UserDefined.m
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "NSObject+UserDefined.h"

@implementation NSObject (UserDefined)

- (id)exceptNull
{
    if (self == [NSNull null]) {
        return nil;
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@""]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"false"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"<nil>"]) {
            return nil;
        }
    }
    //    if([self isKindOfClass:[NSNumber class]]){
    //        return nil;
    //    }
    //    if ([self isKindOfClass:[NSDecimalNumber class]]) {
    //        if ([(NSDecimalNumber*)self ]) {
    //            return nil;
    //        }
    //        if ([(NSDecimalNumber*)self isEqualToString:@"null"]) {
    //            return nil;
    //        }
    //        if ([(NSDecimalNumber*)self isEqualToString:@""]) {
    //            return nil;
    //        }
    //    }
    return self;
}
- (id)exceptNullForArray
{
    if (self == [NSNull null]) {
        return nil;
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@""]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"false"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"<nil>"]) {
            return nil;
        }
    }
    if(![self respondsToSelector:@selector(count)]){
        return nil;
    }
    return self;
}
- (id)exceptNullString
{
    if (self == [NSNull null]) {
        return @"";
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return @"";
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return @"";
        }
        if ([(NSString*)self isEqualToString:@"false"]) {
            return @"";
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return @"";
        }
        if ([(NSString*)self isEqualToString:@"<nil>"]) {
            return @"";
        }
    }
    return self;
}
- (id)exceptNull0
{
    if (self == [NSNull null]) {
        return @"0";
    }
    if(nil == self){
        return @"0";
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@"nil"]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@""]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@"<nil>"]) {
            return @"0";
        }
        //特殊处理 净值(latestNetPresentValue) 涨跌幅(latestNetPresentValueChange)  万份收益(latest10kAccrual) 七日年化(latest7daysYearsYield)
        if ([(NSString*)self isEqualToString:@"-100000000"]) {//
            return @"0";
        }
    }
    if([self isKindOfClass:[NSNumber class]]){
        if(nil == self){
            return [NSNumber numberWithInt:0];
        }
    }
    return self;
}
//当数据data没有数据的时候，返回来的数据是NSArray类型的
//Printing description of resultDic:
//{
//    data =     (
//    );
//    info = "\U6ca1\U6709\U6570\U636e";
//    status = 1;
//}


//Printing description of data:
//<__NSArrayM 0x9bd6520>(
//
//)

//要是有数据的话，一般返回的是NSDictionary类型



- (id)exceptNotArray
{
    if ([self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return self;
}

- (id)exceptNotDictionary
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if([self isKindOfClass:[NSNumber class]]){//判断false
        return nil;
    }
    return self;
}


- (id)exceptNotFalse
{
    if([self isKindOfClass:[NSNumber class]]){//判断false
        return nil;
    }
    return self;
}

//净值(latestNetPresentValue) 涨跌幅(latestNetPresentValueChange)  万份收益(latest10kAccrual) 七日年化(latest7daysYearsYield)
//是不是null,如果净值是null 显示 --

//返回字符串 : -100000000,然后在页面进行处理
- (id)exceptNullForSpecialFund
{
    if (self == [NSNull null]) {
        return @"-100000000";
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return @"-100000000";
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@""]) {
            return @"0";
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return @"0";
        }
    }
    if ([self isKindOfClass:[NSDecimalNumber class]]) {
        return [NSString stringWithFormat:@"%@",(NSDecimalNumber *)self];
    }
    return self;
}
//如果服务返回null，，解析到为<null>，，，这种情况显示--
- (id)exceptNullHorizontalLine
{
    if (self == [NSNull null]) {
        return @"--";
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return @"--";
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return @"--";
        }
        if ([(NSString*)self isEqualToString:@"false"]) {
            return @"--";
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return @"--";
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return @"--";
        }
    }
    return self;
}






@end

