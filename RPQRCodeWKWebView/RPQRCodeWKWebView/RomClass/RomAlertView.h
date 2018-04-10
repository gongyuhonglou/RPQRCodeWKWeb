//
//  RomAlertView.h
//  RomAlertView
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RomAlertViewConst.h"

@protocol RomAlertViewDelegate;

/**警告框 的样式 **/
typedef NS_ENUM(NSInteger, RomAlertViewMode){
    RomAlertViewModeTopTableView,// 呈现在顶部的toast
    RomAlertViewModeCenterTableView,// 呈现在中间的toast
    RomAlertViewModeBottomTableView,// 距离底部的toast
    RomAlertViewModeNormal,
    RomAlertViewModeReport,
    RomAlertViewModeDatePicker,
    RomAlertViewModeTimePoint,// 选取时间点弹框
    RomAlertViewModeDateTime,
    RomAlertViewModeShare,
    RomAlertViewModeWarning,
    RomAlertViewModeInfo,
    RomAlertViewModeDefault,
    RomAlertViewModeCustom
};

/**警告框 进入的方向 **/
typedef NS_ENUM(NSInteger, RomAlertEnterMode){
    RomAlertEnterModeFadeIn,
    RomAlertEnterModeTop,
    RomAlertEnterModeBottom,
    RomAlertEnterModeLeft,
    RomAlertEnterModeRight,
};

/**警告框 离开的方法 **/
typedef NS_ENUM(NSInteger, RomAlertLeaveMode){
    RomAlertLeaveModeFadeOut,
    RomAlertLeaveModeTop,
    RomAlertLeaveModeBottom,
    RomAlertLeaveModeLeft,
    RomAlertLeaveModeRight,
    
};

/**
 网络请求结果状态码
 
 */

typedef NS_ENUM(NSInteger,RomShareResponseCode) {
    RomShareResponseCodeSuccess            = 200,        //成功
    RomShareREsponseCodeTokenInvalid       = 400,        //授权用户token错误
    RomShareResponseCodeBaned              = 505,        //用户被封禁
    RomShareResponseCodeFaild              = 510,        //发送失败（由于内容不符合要求或者其他原因）
    RomShareResponseCodeArgumentsError     = 522,        //参数错误,提供的参数不符合要求
    RomShareResponseCodeEmptyContent       = 5007,       //发送内容为空
    RomShareResponseCodeShareRepeated      = 5016,       //分享内容重复
    RomShareResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
    RomShareResponseCodeAccessTokenExpired = 5027,       //token过期
    RomShareResponseCodeNetworkError       = 5050,       //网络错误
    RomShareResponseCodeGetProfileFailed   = 5051,       //获取账户失败
    RomShareResponseCodeCancel             = 5052,        //用户取消授权
    RomShareResponseCodeNotLogin           = 5053,       //用户没有登录
    RomShareResponseCodeNoApiAuthority     = 100031      //QQ空间应用没有在QQ互联平台上申请上传图片到相册的权限
};


#if NS_BLOCKS_AVAILABLE

/**
 *  the block to tell user whitch button is clicked
 *
 *  @param button button
 */
typedef void (^selectButtonIndexComplete)(NSInteger index);

#endif

@interface RomAlertView : UIView



/**
 *  显示一个显示在中心的警告框 标题 子标题 取消 其他按钮 四个参数可选填
 *
 *  @param title              标题
 *  @param detailtext         子标题
 *  @param cancelButtonTitle  取消按钮
 *  @param otherButtonsTitles 其他按钮
 *
 *  @return 返回一个AlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
                  cancelTitle:(NSString *)cancelTitle
                  otherTitles:(NSMutableArray  *)othersTitles;


/**
 *  从底部显示的警告框可设置距底部的边距
 *
 *  @param inset        距离底部的边距
 *  @param title        标题
 *  @param detailtext   子标题
 *  @param cancelTitle  取消按钮
 *  @param othersTitles 其他按钮
 *
 *  @return 返回一个从底部显示的警告框
 */
- (instancetype)initWithMainAlertViewBottomInset:(CGFloat)inset Title:(NSString *)title detailText:(NSString *)detailtext cancelTitle:(NSString *)cancelTitle otherTitles:(NSMutableArray  *)othersTitles;

// 从顶部显示的警告框可设置距顶部的边距
- (instancetype)initWithMainAlertViewTopInset:(CGFloat)inset Title:(NSString *)title detailText:(NSString *)detailtext cancelTitle:(NSString *)cancelTitle otherTitles:(NSMutableArray  *)othersTitles;
/**
 *  举报成功或者失败
 *
 *  @param title       举报成功，我们会尽快处理 已经拉黑
 *  @param imageStatus
 *
 *  @return 提示框
 */
- (instancetype)initWithMainAlertViewReportTitle:(NSString *)title WithImageViewStatus:(UIImage *)imageStatus;

/**
 *  分享
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithRomShare;





#if NS_BLOCKS_AVAILABLE
/**
 *  当触发点击事件后可通过block回调，替代代理方法 后期优化
 *
 *  @param completeBlock
 */
- (void)showWithBlock:(selectButtonIndexComplete)completeBlock;

#endif

@property (nonatomic, weak)   id<RomAlertViewDelegate> delegate;

#if NS_BLOCKS_AVAILABLE

@property (nonatomic, copy)   selectButtonIndexComplete completeBlock;

#endif

// 判断是否完成动画
@property (nonatomic, assign) BOOL animationComplit;
/**
 *  RomAlertView style mode 警告框的样式
 */
@property (nonatomic, assign) RomAlertViewMode RomMode;
/**  RomAlertView 进入的方向*/
@property (nonatomic, assign) RomAlertEnterMode enterMode;
/**  RomAlertView 离开的方向*/
@property (nonatomic, assign) RomAlertLeaveMode leaveMode;


/** 点击蒙版回掉消失的block */
@property (nonatomic, copy) void (^completHidBlock)();


/**
 *  dismiss the alertview
 */
- (void)hide;


/**
 *  show the alertview
 */
- (void)show;



/**
 *  主标题
 */
@property (nonatomic, copy)   NSString *titleText;

/**
 *  子标题
 */
@property (nonatomic, copy)   NSString *detailText;


/**
 *  自定义View
 */
//@property (nonatomic, strong) UIView *customView;

/**
 *该alertview相对父视图的中心x轴偏移
 */
@property (nonatomic, assign) CGFloat xOffset;

/**
 *该alertview相对父视图的中心y轴偏移
 */
@property (nonatomic, assign) CGFloat yOffset;

/**
 *  半径默认值是 5.0
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *  取消按钮标题
 */
@property (nonatomic, copy)   NSString  *cancelTitle;


/**
 *  其他按钮标题
 */
@property (nonatomic, strong) NSMutableArray   *otherTitles;



/**
 * 当从父视图离开后是否隐藏
 */
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

/**
 *  字体的颜色
 */
@property (nonatomic, strong) UIColor  *color;

/**
 *  是否允许改变字体颜色
 */
@property (nonatomic, assign) BOOL  isChangeColor;

/** 点击其他区域是否退出 默认退出*/
@property (nonatomic, assign) BOOL otherClickExit;

/** 顶部弹框样式 是否开启顶部标题栏 */
@property (nonatomic, assign) BOOL startTitleColumn;

/** 中间弹框样式 是否开启顶部标题栏 */
@property (nonatomic, assign) BOOL startMiddleTitleColumn;


@property (nonatomic, strong) NSArray *array_OpenAndEndTime;

/*eg.2017-05-09   默认是开启了有最大时间限制*/
@property (nonatomic, assign) BOOL isOpenMaxDate;


/**
 *  选择器
 */
@property (nonatomic, strong) UIDatePicker *pickerV;
@property (nonatomic, assign) BOOL kent_add_pickerFlag;

@property (nonatomic, copy) void (^shareCodeBlock)();

// 是否显示推荐码布局
@property (nonatomic, assign) BOOL isShowShareCode;

// 选择日期滚动
- (void)setSelectDateWithDate:(NSString *)dateStr;
// 时间点设置
- (void)setSelectLeftTime:(NSString *)leftTime WithRightTime:(NSString *)rightTime;

/**
 * 设置标题栏的颜色
 */
- (void)setTitleLabelBackgroundColor:(UIColor*)color;
@end




@protocol RomAlertViewDelegate <NSObject>

@optional
/**
 *  按钮被点击的方法 -- 目前该警告框没完善
 *
 *  @param
 */
- (void)RomAlertView:(RomAlertView *)alertview didClickButtonAnIndex:(NSInteger )buttonIndex;


/**
 *  弹框是tableView的样式 代理方法
 *
 *  @param alertview
 *  @param indexPath 被点击的cell
 */
- (void)alertview:(RomAlertView *)alertview didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  日期代理事件
 *
 *  @param str 传递参数
 */
- (void)PickerSelectorIndixString:(NSString *)str;


/**
 *  时间段选择 代理方法
 *
 *  @param leftStr   选择起始时间
 *  @param ringhtStr 选着结束时间
 */
- (void)PickerTimeSelectorIndixStartTimeString:(NSString *)startTime WithEndTimeString:(NSString *)endTime;



/**
 *  时间点选择 代理方法
 *
 *  @param leftStr   选择起始时间点
 *  @param ringhtStr 选着结束时间点
 */
- (void)selectTimeStartTimePointString:(NSString *)startTime WithEndTimePointString:(NSString *)endTime;


/***
 *  弹出动画的完成之后的代理
 *
 *
 */
- (void)romAlertViewAnimationComplite;


/**
 *  消失代理
 */

- (void)romAlertViewAnimationHideAlertview:(RomAlertView *)alertview;




@end









