//
//  RomAlertView.m
//  RomAlertView
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RomAlertView.h"
#import "RomCustomAlertViewTableVC.h"
#import "RomCustomMaskView.h"

@interface RomAlertView ()<RomCustomAlertViewTableVCDelegate,RomCustomMaskViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    BOOL isWeiChatInstall;
}


@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray  *otherButtons;

@property (nonatomic, strong) RomCustomAlertViewTableVC  *tableViewVC;

@property (nonatomic, strong) RomCustomMaskView   *maskView;
@property (nonatomic, strong) UIView   *mainAlertView; //主要的View

// 当展示的内容过多时可以滚动
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat inset;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *btnCancel;
/**
 *  标题view
 */
@property (nonatomic, strong) UIView  *titleBottomView;

/**
 *  标题view
 */
@property (nonatomic, strong) UILabel *titleBottomLabel;

/**
 图片
 */
@property (nonatomic, strong) UIImageView *imageViewStatus;
/**
 *  拉黑label
 */
@property (nonatomic, strong) UILabel *label_Title;

/**
 *  横线线条
 */
@property (nonatomic, strong) UIView *view_Line;
/**
 *  竖线
 */
@property (nonatomic, strong) UIView *view_LineTwo;


@property (nonatomic, strong) UIImage *image;


/**
 *  时间段选着器
 */
@property (nonatomic, strong) UIPickerView *pickerTimeV;
/**
 *  时间段数据源
 */
@property (nonatomic, strong) NSMutableArray *arrayTime;
/**
 *  时间段线条
 */
@property (nonatomic, strong) UIView *view_TimeLine;
/**
 *  时间段确定按钮
 */
@property (nonatomic, strong) UIButton *timeSureData;

/**
 *  时间段起始时间
 */
@property (nonatomic, strong) NSString *stratTime;

/**
 *  时间段结束时间
 */
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, assign) int selectPickTimeIndex;

/**
 * 时间选择 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelDate;
/**
 *  时间选择确定按钮
 */
@property (nonatomic, strong) UIButton *sureDate;

//@property (nonatomic, strong) NSMutableArray *array;

// 保存被选中的日期
@property (nonatomic, strong) NSString *dateString;

/**
 *  时间线条
 */
@property (nonatomic, strong) UIView *view_DateLine;
/** 弹框距离底部的线条 */
@property (nonatomic, strong) UIView *view_BottomInsetLine;


/**  左右时间点选取 */
@property (nonatomic, strong) UIDatePicker *datePickertimePoint_Left;
@property (nonatomic, strong) UIDatePicker *datePickertimePoint_Right;

/**  左边的冒号 : */
@property (nonatomic, strong) UILabel *label_LeftColon;

/**  右边的冒号 : */
@property (nonatomic, strong) UILabel *label_RightColon;


// 左边的时间点
@property (nonatomic, copy) NSString *timePoint_Left;
// 右边的时间点
@property (nonatomic, copy) NSString *timePoint_Right;

// 控制器
@property (nonatomic, strong) UIViewController *VC;




@end


@implementation RomAlertView


#pragma mark Lifecycle


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationComplit = NO;
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.radius  = KDefaultRadius;
        self.RomMode = RomAlertViewModeDefault;
        self.alpha   = 0.0;
        self.removeFromSuperViewOnHide = YES;
        self.otherClickExit = YES;
        [self registerKVC];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveExitLoginNoti) name:@"IMLogout_hidAlertView" object:nil];
        
        
    }
    return self;
}

/** 初始化方法 中间弹出 */
- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
                  cancelTitle:(NSString *)cancelTitle
                  otherTitles:(NSMutableArray  *)othersTitles{
    
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        self.isOpenMaxDate = YES; // 默认是开启的最大时间段 2017-05-09
        self.startMiddleTitleColumn = YES;// 默认是开启的
         self.animationComplit = NO;
        self.titleText = title;
        self.detailText = detailtext;
        self.cancelTitle = cancelTitle;
        self.otherTitles = othersTitles;
        self.otherClickExit = YES;
        [self layout];
        
    }
    return self;
}

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
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {

        if (self.startTitleColumn == YES) {
            
        }
        
         self.animationComplit = NO;
        self.titleText = title;
        self.detailText = detailtext;
        self.cancelTitle = cancelTitle;
        self.otherTitles = othersTitles;
        self.otherClickExit = YES;
        [self layout];
        self.inset = inset;
        
        
    }
    return self;
}

/**
 *  从顶部显示的警告框可设置距顶部的边距
 *  @param inset        距离底部的边距
 *  @param title        标题
 *  @param detailtext   子标题
 *  @param cancelTitle  取消按钮
 *  @param othersTitles 其他按钮
 *
 *  @return 返回一个从底部显示的警告框
 */
- (instancetype)initWithMainAlertViewTopInset:(CGFloat)inset Title:(NSString *)title detailText:(NSString *)detailtext cancelTitle:(NSString *)cancelTitle otherTitles:(NSMutableArray  *)othersTitles;
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        if (self.startTitleColumn == YES) {
            
        }
        
        self.animationComplit = NO;
        self.titleText = title;
        self.detailText = detailtext;
        self.cancelTitle = cancelTitle;
        self.otherTitles = othersTitles;
        self.otherClickExit = YES;
        [self layout];
        self.inset = inset;
        
        
    }
    return self;
}


#pragma mark Layout
- (void)layout {
    [self addView];
    [self setupLabel];
    [self setupButton];
    [self updateModeStyle];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}




#pragma mark UI

- (void)addView {
    
    [self addSubview:self.maskView];
    
    [self addSubview:self.mainAlertView];
    [self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.tableViewVC.view];
    
    
}



#pragma mark -- 根据不同的样式 显示不同的弹框
/** 根据不同的样式 显示不同的弹框*/
- (void)updateModeStyle {
    //self.mode == RomAlertViewModeDefault || self.mode == RomAlertViewModeCenterTableView)
    if (self.RomMode == RomAlertViewModeDefault || self.RomMode == RomAlertViewModeCenterTableView) {// 默认是表格的形式
        self.tableViewVC.delegate = self;
        self.tableViewVC.dataArray = self.otherTitles;
        self.mainAlertView.clipsToBounds = YES;
    }
    if(self.RomMode == RomAlertViewModeBottomTableView){
        if (self.isChangeColor == YES) {
            self.tableViewVC.isChangeColor = self.isChangeColor;
            self.tableViewVC.color = self.color;
            self.titleBottomLabel.text = self.titleText;
        }
        
        [self cancelButton];
    }
    // 增加从顶部弹出------
    if(self.RomMode == RomAlertViewModeTopTableView){
        if (self.isChangeColor == YES) {
            self.tableViewVC.isChangeColor = self.isChangeColor;
            self.tableViewVC.color = self.color;
            self.titleBottomLabel.text = self.titleText;
        
        }
        
        self.tableViewVC.isChangeFont = YES;
    }
    
    
    if(self.RomMode == RomAlertViewModeReport){
        self.tableViewVC.tableView.hidden = YES;
        self.imageViewStatus.image = self.image;
        self.mainAlertView.layer.cornerRadius = 4.0;
        self.label_Title.text = self.titleText;
        self.maskView.alpha = 0.1;
        [self performSelector:@selector(hideTip) withObject:nil afterDelay:1];;
        self.maskView.userInteractionEnabled = NO;
        
    }
    if(self.RomMode == RomAlertViewModeNormal){
        self.tableViewVC.tableView.hidden = YES;
        self.mainAlertView.layer.cornerRadius = 10;
        [self.mainAlertView addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self.mainAlertView addSubview:self.scrollView];
        
        self.detailLabel.font = [UIFont systemFontOfSize:12];
        self.detailLabel.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1];
        [self.scrollView addSubview:self.detailLabel];
        self.detailLabel.text = self.detailText;
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.numberOfLines = 0;
        
        [self.mainAlertView addSubview:self.view_Line];
        self.view_Line.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        self.view_LineTwo.backgroundColor =  [UIColor colorWithRed:215/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        
        [self.cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        
        
        
    }
    
    
    // 日期年月日模式
    if (self.RomMode == RomAlertViewModeDatePicker) {
        self.tableViewVC.tableView.hidden = YES;
        self.view_DateLine.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        
    }
    
    
    // 时间段模式
    if(self.RomMode == RomAlertViewModeDateTime){
        
        self.tableViewVC.tableView.hidden = YES;
        NSMutableArray *arrayTimeOne = [NSMutableArray arrayWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00",nil];
        NSMutableArray *arrayTimeTwo = [NSMutableArray arrayWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00",nil];
        // [self.arrayTime addObject:arrayTimeOne];
        //[self.arrayTime addObject:arrayTimeTwo];
        //reloadComponent
        self.arrayTime = [[NSMutableArray alloc ] initWithObjects:arrayTimeOne, arrayTimeTwo,nil];
        [self.pickerTimeV addSubview:self.view_TimeLine];
        [self.pickerTimeV reloadAllComponents];
        
        self.view_DateLine.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        self.view_TimeLine.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
    }

    
    
    
    // 选择时间点
    if (self.RomMode == RomAlertViewModeTimePoint) {
         self.tableViewVC.tableView.hidden = YES;
         [self.mainAlertView addSubview:self.view_TimeLine];
        self.view_DateLine.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        self.view_TimeLine.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
    
    
    if (self.RomMode == RomAlertViewModeShare) {// 分享
        self.tableViewVC.tableView.hidden = YES;
        // 添加横线
        [self.mainAlertView addSubview:self.view_Line];
        // 设置颜色
        self.view_Line.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    }
    
}



- (void)setArray_OpenAndEndTime:(NSArray *)array_OpenAndEndTime
{
    _array_OpenAndEndTime = array_OpenAndEndTime;
    
    if (_array_OpenAndEndTime.count != 0) {
        NSString *openStartTime = [array_OpenAndEndTime firstObject];
        NSString *openEndTime  = [array_OpenAndEndTime lastObject];
        NSMutableArray *arrayTimeOne = self.arrayTime[0];
        NSMutableArray *arrayTimeTwo = self.arrayTime[1];
        for (int i = 0 ; i < arrayTimeOne.count ; i++) {
            if ([openStartTime isEqualToString:arrayTimeOne[i]]) {
                [self.pickerTimeV selectRow:i inComponent:0 animated:YES];
            }
            
        }
        
        
        for (int i = 0 ; i < arrayTimeTwo.count ; i++) {
            if ([openEndTime isEqualToString:arrayTimeTwo[i]]) {
                [self.pickerTimeV selectRow:i inComponent:1 animated:YES];
            }
            
        }
    }
    
    
}



#pragma mark -- 标题和子标题
- (void)setupLabel {

    self.titleLabel.backgroundColor = BACKGROUND_COLOR;
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    
}

- (void)setTitleLabelBackgroundColor:(UIColor *)color
{
    self.titleLabel.backgroundColor = color;
}

// 设置按钮的标题
- (void)setupButton {
    if (self.cancelTitle == nil && self.otherTitles.count ==0) {
        return;
    }
    

    [self cancelButton];
    
    if (self.otherTitles.count > 0) {
        NSMutableArray *tempButtonArray = [[NSMutableArray alloc] init];
        NSInteger i = 1;
        [self.mainAlertView addSubview:self.view_LineTwo];
        for (NSString *title in self.otherTitles) {
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTag:KbuttonTag + i];
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            //[[button layer] setCornerRadius:4.0];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:68/255.0 blue:4/255.0 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [tempButtonArray addObject:button];
            [self.mainAlertView addSubview:button];
            i++;
        }
        self.otherButtons = [tempButtonArray copy];
    }
}


#pragma mark -- 设置空间的位置
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mainAlertView setBackgroundColor:[UIColor whiteColor]];
    
    
    //中心的弹框
    if (self.RomMode == RomAlertViewModeDefault || self.RomMode == RomAlertViewModeCenterTableView) {
        
        
        [[self.mainAlertView layer] setCornerRadius:self.radius];
        self.mainAlertView.clipsToBounds = YES;
        if (self.startMiddleTitleColumn == YES) {// 有标题栏的toast
            self.titleLabel.frame = CGRectMake(0, 0, KRomAlertView_Width, 44);
            CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, CGRectGetHeight(self.titleLabel.frame)/2);
            
            [self.titleLabel setCenter:titleCenter];
        }else{// 有标题栏的toast
            
        }
        
        
        CGFloat tableViewHeightMAX = 44 *self.otherTitles.count;
        
        
        tableViewHeightMAX = tableViewHeightMAX <= KRomAlertView_Height + 10 - 44?44 *self.otherTitles.count:KRomAlertView_Height ;
        // 最大的高度 KRomAlertView_Height - 44
        self.tableViewVC.tableView.scrollEnabled = tableViewHeightMAX <= KRomAlertView_Height - 44?NO:YES;
        
        CGRect rect = self.mainAlertView.frame;
        if (self.startMiddleTitleColumn == YES) {// 有标题栏的toast
           rect.size.height= tableViewHeightMAX + 44 ;
        }else{// 没有有标题栏的toast
            rect.size.height= tableViewHeightMAX;
        }
        
        
        self.mainAlertView.frame = rect;
        
        
        self.mainAlertView.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
        self.mainAlertView.bounds = CGRectMake(0, 0, self.mainAlertView.frame.size.width, self.mainAlertView.frame.size.height);
        
        
        self.tableViewVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), KRomAlertView_Width, tableViewHeightMAX );
        self.tableViewVC.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        

    }
    
    // 底部的弹框
    if (self.RomMode == RomAlertViewModeBottomTableView) {
        
        if (self.startTitleColumn == YES) { // 有标题栏的toast
            
            
            // 设置标题位置
            self.titleBottomView.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
            self.titleBottomLabel.frame = self.titleBottomView.frame;
            //self.titleBottomLabel.text = @"Romantic";
            
            
            CGFloat tableViewHeightMAX = 44 *self.otherTitles.count;
            
            tableViewHeightMAX = tableViewHeightMAX <= KRomAlertView_Height - 44 - 44 ?44 *self.otherTitles.count:KRomAlertView_Height ;
            // 最大的高度 KRomAlertView_Height - 44
            
            self.tableViewVC.tableView.scrollEnabled = tableViewHeightMAX <= KRomAlertView_Height - 44?NO:YES;
            
            //self.mainAlertView.backgroundColor = [UIColor redColor];
            
            CGRect rect = self.mainAlertView.frame;
            rect.size.width = SCREENWIDTH;
            rect.size.height= tableViewHeightMAX + 44 + 44 ;
            rect.origin.y = SCREENHEIGHT - rect.size.height - self.inset;
            rect.origin.x = 0;
            self.mainAlertView.frame = rect;
            
            self.mainAlertView.backgroundColor = [UIColor whiteColor];
            //[UIColor colorWithRed:206/255. green:207/255.0 blue:212/255.0 alpha:1];
            
            self.tableViewVC.view.frame = CGRectMake(0,44, SCREENWIDTH, self.mainAlertView.frame.size.height-44 - 44);
            self.view_BottomInsetLine.frame = CGRectMake(0,self.mainAlertView.frame.size.height-40 -4, SCREENWIDTH,4 );
            
            self.cancelButton.frame = CGRectMake(0, self.mainAlertView.frame.size.height-40 , SCREENWIDTH, 40);
            
        }else{// 没有标题栏的toast
            CGFloat tableViewHeightMAX = 44 *self.otherTitles.count;
            
            tableViewHeightMAX = tableViewHeightMAX <= KRomAlertView_Height + 10 - 44?44 *self.otherTitles.count:KRomAlertView_Height ;
            // 最大的高度 KRomAlertView_Height - 44
            
            self.tableViewVC.tableView.scrollEnabled = tableViewHeightMAX <= KRomAlertView_Height - 44?NO:YES;
            
            //self.mainAlertView.backgroundColor = [UIColor redColor];
            
            CGRect rect = self.mainAlertView.frame;
            rect.size.width = SCREENWIDTH;
            rect.size.height= tableViewHeightMAX + 44 ;
            rect.origin.y = SCREENHEIGHT - rect.size.height - self.inset;
            rect.origin.x = 0;
            self.mainAlertView.frame = rect;
            
            self.mainAlertView.backgroundColor = [UIColor whiteColor];
            //[UIColor colorWithRed:206/255. green:207/255.0 blue:212/255.0 alpha:1];
            self.tableViewVC.view.frame = CGRectMake(0,0, SCREENWIDTH, self.mainAlertView.frame.size.height-44 );
            
            self.view_BottomInsetLine.frame = CGRectMake(0,self.mainAlertView.frame.size.height-40  - 4, SCREENWIDTH,4 );
            
            self.cancelButton.frame = CGRectMake(0, self.mainAlertView.frame.size.height-40 , SCREENWIDTH, 40);
        }
        
       
    }
    
       // 增加从顶部弹出------
    if (self.RomMode == RomAlertViewModeTopTableView) {
        CGFloat tableViewHeightMAX = 44 *self.otherTitles.count;
        tableViewHeightMAX = tableViewHeightMAX <= KRomAlertView_Height - 44?44 *self.otherTitles.count:KRomAlertView_Height ;
        // 最大的高度 KRomAlertView_Height - 44
        
        self.tableViewVC.tableView.scrollEnabled = tableViewHeightMAX <= KRomAlertView_Height - 44?NO:YES;
        
        CGRect rect = self.mainAlertView.frame;
        rect.size.width = SCREENWIDTH / 4;
        rect.size.height= tableViewHeightMAX + 44;
        rect.origin.y = __MainTopHeight + self.inset ;
        rect.origin.x = SCREENWIDTH / 4;
        self.mainAlertView.frame = rect;
        
        self.maskView.frame = CGRectMake(0,  rect.origin.y, SCREENWIDTH, SCREENHEIGHT - rect.origin.y );
//        self.maskView.backgroundColor= [UIColor clearColor];
        self.mainAlertView.backgroundColor = [UIColor clearColor];
        self.tableViewVC.view.frame = CGRectMake(0,0, SCREENWIDTH / 4, self.mainAlertView.frame.size.height-44);
        
    }
    
    // 警告 提示框
    if (self.RomMode == RomAlertViewModeReport) {
        
        self.mainAlertView.frame = CGRectMake(0, 0,125, 100);
        [self.mainAlertView setCenter:self.center];
        self.mainAlertView.backgroundColor = [UIColor blackColor];
        self.mainAlertView.alpha = 0.4;
        
        
        self.imageViewStatus.center = CGPointMake(self.mainAlertView.bounds.size.width/2.0,  13+(self.image.size.height/2.0));
        
        self.imageViewStatus.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        
        self.label_Title.frame = CGRectMake(0, CGRectGetMaxY(self.imageViewStatus.frame)+10, self.mainAlertView.frame.size.width, 30);
        CGSize sizeTitle = [self.label_Title.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        
        if (sizeTitle.width > self.mainAlertView.frame.size.width) {
            
            CGRect rectTitle  = self.mainAlertView.frame;
            rectTitle.size.width = sizeTitle.width+20;
            rectTitle.size.height = 120;
            self.mainAlertView.frame = rectTitle;
            [self.mainAlertView setCenter:self.center];
            self.imageViewStatus.center = CGPointMake(self.mainAlertView.bounds.size.width/2.0 ,  13+(self.image.size.height/2.0));
            self.label_Title.frame = CGRectMake(0, CGRectGetMaxY(self.imageViewStatus.frame)+20, self.mainAlertView.frame.size.width, 30);
            
            
        }
        
        
    }
    
    // 正常模式
    if (self.RomMode == RomAlertViewModeNormal) {
        
        // 只有一个取消按钮 其他的按钮是空
        if (![self.cancelTitle isEqualToString:@""] && self.otherTitles.count == 0){
            self.mainAlertView.frame = CGRectMake(0, 0,270, 126);
            [self.mainAlertView setCenter:self.center];
            
            self.mainAlertView.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
            self.mainAlertView.bounds = CGRectMake(0, 0, self.mainAlertView.frame.size.width, self.mainAlertView.frame.size.height);
            
            //titleLabel frame
            self.titleLabel.bounds = CGRectMake(0, 0, self.mainAlertView.bounds.size.width, 30);
            CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2.0, 15+CGRectGetHeight(self.titleLabel.frame)/2.0);
            [self.titleLabel setCenter:titleCenter];
            
            //
            //detailLabel frame
            CGSize sizeDetail = [self.detailLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.mainAlertView.frame)-KRomAlertView_Padding*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat detailHeight = 30;
            if (sizeDetail.height < 30 ) {
                detailHeight = 30;
            }else{
                detailHeight = sizeDetail.height;
            }
            
            if (sizeDetail.height > (SCREENHEIGHT *0.5)*0.2) {
                detailHeight = 100;
                self.scrollView.contentSize = CGSizeMake(0, sizeDetail.height);
            }
            [self.scrollView setFrame:CGRectMake(KRomAlertView_Padding, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.mainAlertView.frame)-KRomAlertView_Padding*2, detailHeight)];
            self.detailLabel.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, sizeDetail.height);
            //self.detailLabel.backgroundColor = [UIColor redColor];
            
            // 线条view_Line
            self.view_Line.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)+5,  CGRectGetWidth(self.mainAlertView.frame), 0.5);
            
            
            
             //self.mainAlertView.bounds.size.height - CGRectGetMaxY(self.view_Line.frame)
            CGRect buttonFrame = CGRectMake(0, CGRectGetMaxY(self.view_Line.frame), self.mainAlertView.bounds.size.width, 45);
            [self.cancelButton setFrame:buttonFrame];
            
            
            CGRect rect_MainAlertView = self.mainAlertView.frame;
            rect_MainAlertView.size.height = CGRectGetMaxY(self.cancelButton.frame);
            self.mainAlertView.frame = rect_MainAlertView;
            
            self.mainAlertView.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
            self.mainAlertView.bounds = CGRectMake(0, 0, self.mainAlertView.frame.size.width, self.mainAlertView.frame.size.height);
            
            
        }
        
        // 有取消按钮 其他按钮只有一个 总共有两个按钮
        if (![self.cancelTitle isEqualToString:@""] && [self.otherTitles count]==1) {
            
            self.mainAlertView.frame = CGRectMake(0, 0,270, 126);
            [self.mainAlertView setCenter:self.center];
            
            //titleLabel frame
            self.titleLabel.bounds = CGRectMake(0, 0, self.mainAlertView.bounds.size.width, 30);
            CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2.0, 15+CGRectGetHeight(self.titleLabel.frame)/2.0);
            [self.titleLabel setCenter:titleCenter];
            
            //
            //detailLabel frame
            CGSize sizeDetail = [self.detailLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.mainAlertView.frame)-KRomAlertView_Padding*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat detailHeight = 30;
            if (sizeDetail.height < 30 ) {
                 detailHeight = 30;
            }else{
                detailHeight = sizeDetail.height;
            }
            
            if (sizeDetail.height > (SCREENHEIGHT *0.5)*0.2) {
                detailHeight = 100;
                self.scrollView.contentSize = CGSizeMake(0, sizeDetail.height);
            }
            [self.scrollView setFrame:CGRectMake(KRomAlertView_Padding, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.mainAlertView.frame)-KRomAlertView_Padding*2, detailHeight)];
            self.detailLabel.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, sizeDetail.height);
            
            // 线条view_Line
            self.view_Line.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)+5,  CGRectGetWidth(self.mainAlertView.frame),0.5);
            
            //self.mainAlertView.bounds.size.height - CGRectGetMaxY(self.view_Line.frame) --> 45.5 这个高度是由主视图的高度写死造成
            
            CGRect buttonFrame = CGRectMake(0,CGRectGetMaxY(self.view_Line.frame), (self.mainAlertView.bounds.size.width/2.0) -0.5, 45);
            [self.cancelButton setFrame:buttonFrame];
            
            
            self.view_LineTwo.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.view_Line.frame), 0.5, 45);
            
            UIButton *rightButton = (UIButton *)self.otherButtons[0];
            rightButton.frame = CGRectMake(CGRectGetMaxX(self.view_LineTwo.frame), CGRectGetMaxY(self.view_Line.frame), (self.mainAlertView.bounds.size.width/2.0) -0.5, 45);
            
            // 调整主视图的位置
            CGRect rect_MainAlertView = self.mainAlertView.frame;
            rect_MainAlertView.size.height = CGRectGetMaxY(rightButton.frame);
            self.mainAlertView.frame = rect_MainAlertView;
 
            // 让其居中显示
            self.mainAlertView.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
            self.mainAlertView.bounds = CGRectMake(0, 0, self.mainAlertView.frame.size.width, self.mainAlertView.frame.size.height);
            
            
        }
        
        
        
        
        
    }
    
    // 时间模式
    if (self.RomMode == RomAlertViewModeDatePicker) {
        [[self.mainAlertView layer] setCornerRadius:self.radius];
        self.mainAlertView.clipsToBounds = YES;
        self.mainAlertView.frame = CGRectMake(0, 0,SCREENWIDTH - 20-20, 300);
        [self.mainAlertView setCenter:self.center];
        self.titleLabel.frame = CGRectMake(0, 0, self.mainAlertView.bounds.size.width, 44);
        CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, CGRectGetHeight(self.titleLabel.frame)/2);
        [self.titleLabel setCenter:titleCenter];
        
        self.pickerV.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.mainAlertView.bounds.size.width, self.mainAlertView.bounds.size.height - 89);
        // self.pickerV.backgroundColor = [UIColor cyanColor];
        
        self.view_DateLine.frame = CGRectMake(0, CGRectGetMaxY(self.pickerV.frame), self.mainAlertView.bounds.size.width, 0.5);
        self.cancelDate.frame = CGRectMake(0, CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);
        self.sureDate.frame = CGRectMake(CGRectGetMaxX(self.cancelDate.frame), CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);
        
       // self.pickerV setDate:<#(nonnull NSDate *)#> animated:<#(BOOL)#>
    }
    
    
    
    
    
    // 时间段模式
    if(self.RomMode == RomAlertViewModeDateTime){
        
        [[self.mainAlertView layer] setCornerRadius:self.radius];
        self.mainAlertView.clipsToBounds = YES;
        self.mainAlertView.frame = CGRectMake(0, 0,SCREENWIDTH - 20-20, 300);
        [self.mainAlertView setCenter:self.center];
        self.titleLabel.frame = CGRectMake(0, 0, self.mainAlertView.bounds.size.width, 44);
        CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, CGRectGetHeight(self.titleLabel.frame)/2);
        [self.titleLabel setCenter:titleCenter];
        
        self.pickerTimeV.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.mainAlertView.bounds.size.width, self.mainAlertView.bounds.size.height - 89);
        if (self.array_OpenAndEndTime.count == 0) {
            [self.pickerTimeV selectRow:16 inComponent:0 animated:YES];
            [self.pickerTimeV selectRow:36 inComponent:1 animated:YES];
        }
        
        
        self.view_TimeLine.frame = CGRectMake((SCREENWIDTH - 40 -50)/2.0, (300 -89)/2.0 , 50, 1);
        // self.view_TimeLine.backgroundColor = [UIColor redColor];
        self.view_DateLine.frame = CGRectMake(0, CGRectGetMaxY(self.pickerTimeV.frame), self.mainAlertView.bounds.size.width, 0.5);
        
        self.cancelDate.frame = CGRectMake(0, CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);
        self.timeSureData.frame = CGRectMake(CGRectGetMaxX(self.cancelDate.frame), CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);
        
        
       
    }
    
    
    // 选择时间点
    if (self.RomMode == RomAlertViewModeTimePoint) {
        [[self.mainAlertView layer] setCornerRadius:self.radius];
        self.mainAlertView.clipsToBounds = YES;
        self.mainAlertView.frame = CGRectMake(0, 0,SCREENWIDTH - 20-20, 300);
        [self.mainAlertView setCenter:self.center];
        self.titleLabel.frame = CGRectMake(0, 0, self.mainAlertView.bounds.size.width, 44);
        
        self.datePickertimePoint_Left.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), (self.mainAlertView.bounds.size.width - 50) * 0.5, self.mainAlertView.bounds.size.height - 89);
        self.label_LeftColon.frame = CGRectMake(self.datePickertimePoint_Left.frame.size.width * 0.5 - 5, self.datePickertimePoint_Left.frame.size.height * 0.5 - 12, 10, 20);
        // (self.mainAlertView.bounds.size.height - 89)*0.5
         self.view_TimeLine.frame = CGRectMake(CGRectGetMaxX(self.datePickertimePoint_Left.frame), CGRectGetMaxY(self.titleLabel.frame) + self.datePickertimePoint_Left.bounds.size.height * 0.5, 50, 1);
         self.view_DateLine.frame = CGRectMake(0, CGRectGetMaxY(self.datePickertimePoint_Left.frame), self.mainAlertView.bounds.size.width, 0.5);
         self.datePickertimePoint_Right.frame = CGRectMake(CGRectGetMaxX(self.view_TimeLine.frame), CGRectGetMaxY(self.titleLabel.frame), (self.mainAlertView.bounds.size.width - 50) * 0.5, self.mainAlertView.bounds.size.height - 89);
        
        self.label_RightColon.frame = CGRectMake(self.datePickertimePoint_Right.frame.size.width * 0.5 - 5, self.datePickertimePoint_Right.frame.size.height * 0.5 - 12, 10, 20);
        
        self.cancelDate.frame = CGRectMake(0, CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);
        self.timeSureData.frame = CGRectMake(CGRectGetMaxX(self.cancelDate.frame), CGRectGetMaxY(self.view_DateLine.frame), self.mainAlertView.bounds.size.width/2.0, 44);

    }
}


#pragma mark Event Response

- (void)buttonTouch:(UIButton *)button {
    if (self.completeBlock) {
        self.completeBlock(button.tag - KbuttonTag);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RomAlertView:didClickButtonAnIndex:)]) {
        [self.delegate RomAlertView:self didClickButtonAnIndex:button.tag - KbuttonTag];
        
    }
    [self hide];
}

#pragma mark -- 时间的点击事件

//参数为：被选择的日期选择器
- (void)showDate:(id)sender
{
    //NSLog(@"------sender = %@",sender);
    UIDatePicker* datePicker = (UIDatePicker *)sender;
    
    NSDate* date = datePicker.date;
    
    
    // 设置日期格式化器：
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    // 设置格式化的格式：2016-05-25
    if(_kent_add_pickerFlag ==YES){
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *newTimeStr=[dateFormatter stringFromDate:date];
        self.dateString = newTimeStr;
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //将日期转换为字符串
        NSString* dateString = [dateFormatter stringFromDate:date];
        self.dateString = dateString;
    }
    NSLog(@"---%@",_dateString);
}

#pragma mark -- 时间选择器 取消按钮
// 时间选择器 取消按钮
- (void)cancelBtnClick{
    
    [self hide];
    
}
#pragma mark -- 时间选择器 确定按钮
// 时间选择器 确定按钮
- (void)completeBtnClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PickerSelectorIndixString:)]) {
        
        [self.delegate PickerSelectorIndixString:self.dateString];
    }
    
    [self hide];
    
}
// 选择日期滚动
- (void)setSelectDateWithDate:(NSString *)dateStr
{
    NSString *strDate = dateStr;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *tempDate = [fmt dateFromString:strDate];
    [self.pickerV setDate:tempDate animated:YES];
}


#pragma mark -- 时间   段   选择器 确定按钮
- (void)completeSureTimeBtnClick
{
    
    if (self.RomMode == RomAlertViewModeDateTime) { // 时间段确定按钮
        if (self.delegate && [self.delegate respondsToSelector:@selector(PickerTimeSelectorIndixStartTimeString:WithEndTimeString:)]) {
            NSString *openStartTime = nil;
            NSString *openEndTime = nil;
            
            if (_array_OpenAndEndTime.count != 0) {
                openStartTime = [_array_OpenAndEndTime firstObject];
                openEndTime  = [_array_OpenAndEndTime lastObject];
            }else{
                openStartTime = @"08:00";
                openEndTime = @"18:00";
            }
            if (self.stratTime == nil&&self.endTime == nil) {

                self.stratTime = openStartTime;
                self.endTime = openEndTime;
            }
            if (self.stratTime.exceptNull != nil&&self.endTime.exceptNull == nil) {
                self.endTime = openEndTime;
                //@"18:00";
            }
            
            if (self.stratTime.exceptNull == nil&&self.endTime.exceptNull != nil) {
                self.stratTime = openStartTime;
                //@"08:00";
            }
            
            [self.delegate PickerTimeSelectorIndixStartTimeString:self.stratTime WithEndTimeString:self.endTime];
            
        }
    }else if (self.RomMode == RomAlertViewModeTimePoint){ // 时间点确定按钮
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        //将日期转换为字符串
        
        if (self.timePoint_Left.exceptNull == nil) {
            NSString* dateString = [dateFormatter stringFromDate: self.datePickertimePoint_Left.date];
            self.timePoint_Left = dateString;
        }
        
        if (self.timePoint_Right.exceptNull == nil) {
            NSString* dateString = [dateFormatter stringFromDate: self.datePickertimePoint_Right.date];
            self.timePoint_Right = dateString;
        }
        
        if(self.timePoint_Left.exceptNull != nil && self.timePoint_Right.exceptNull != nil){
            
            [_delegate selectTimeStartTimePointString:self.timePoint_Left WithEndTimePointString:self.timePoint_Right];
            // 时间对比 由于8256bug需求 暂时注释
            /*
             if([self dateCompareLeftTime:self.timePoint_Left WithRight:self.timePoint_Right] == YES){
             if ([_delegate respondsToSelector:@selector(selectTimeStartTimePointString:WithEndTimePointString:)]) {
             [_delegate selectTimeStartTimePointString:self.timePoint_Left WithEndTimePointString:self.timePoint_Right];
             }
             }else{
             [SVProgressHUD setMinimumDismissTimeInterval:2];
             [SVProgressHUD showInfoWithStatus:@"请选择正确时间"];
             }
             */
            
            
        }
        
        
        
        NSLog(@"你的点击了时间点确定按钮");
        
    }
   
    [self hide];
}


- (BOOL)dateCompareLeftTime:(NSString *)leftTime WithRight:(NSString *)rightTime
{
    // 时间字符串
    // NSString *createdAtString = @"2015-11-20 11:10:05";
    NSDateFormatter *fmtOne = [[NSDateFormatter alloc] init];
    fmtOne.dateFormat = @"HH:mm";
    NSDate *leftDate = [fmtOne dateFromString:leftTime];
    
    
    NSDateFormatter *fmtTwo = [[NSDateFormatter alloc] init];
    fmtTwo.dateFormat = @"HH:mm";
    NSDate *rightDate = [fmtTwo dateFromString:rightTime];
    
    
    
    // 手机当前时间
    //NSDate *nowDate = [NSDate date];
    
    /**
     NSComparisonResult的取值
     NSOrderedAscending = -1L, // 升序, 越往右边越大
     NSOrderedSame,  // 相等
     NSOrderedDescending // 降序, 越往右边越小
     */
    // 获得比较结果(谁大谁小)
    NSComparisonResult result = [rightDate compare:leftDate];
    if (result == NSOrderedAscending) { // 升序, 越往右边越大
        NSLog(@"leftDate > rightDate");
        return NO;
    } else if (result == NSOrderedDescending) { // 降序, 越往右边越小
        NSLog(@"leftDate < rightDate");
        return YES;
    } else {
        NSLog(@"leftDate == rightDate");
        return YES;
    }
    
    return YES;
}


#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

#pragma mark -- 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        NSMutableArray *arrayTimeOne = self.arrayTime[component];
        return arrayTimeOne.count;
    }else{
        NSMutableArray *arrayTimeTwo = self.arrayTime[component];
        return arrayTimeTwo.count;
    }
    
}


//设置每一行的标题:  只要有滑动就会调用
#pragma mark -- 设置每一行的标题:  只要有滑动就会调用
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSMutableArray *arrayTimeOne = self.arrayTime[0];
        return [arrayTimeOne objectAtIndex:row];
        
    }else{
        
        
        NSMutableArray *arrayTimeTwo = self.arrayTime[1];
        return [arrayTimeTwo objectAtIndex:row];
        
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //根据第0区的行数刷新第1区的数据
    NSMutableArray *arrayTimeOne = self.arrayTime[0];
    NSMutableArray *arrayTimeTwo = self.arrayTime[1];
    if (component == 0) {
        NSLog(@"_第一区_>>>>>%@",arrayTimeOne[row]);
        self.stratTime = arrayTimeOne[row];
        NSLog(@"_self.stratTime第一区_>>>>>%@",self.stratTime);
        [pickerView selectRow:row inComponent:1 animated:YES];
        // 记录索引
        self.selectPickTimeIndex = (int)row;
        
        self.endTime = arrayTimeTwo[self.selectPickTimeIndex];
    }else{
        
        
        //NSLog(@"_第二区_>>>>>%@",arrayTimeTwo[row]);
        
        self.endTime = arrayTimeTwo[row];
        
        
        NSLog(@"_self.stratTime  _self.endTime第二区_>>>>>%@  %@",self.stratTime,self.endTime);
        
    }
    
    
    
    
}



#pragma mark show & hide

- (void)show {
    
    [self showAlertView];
}

// 弹款show方法抽取 主要防止分享积分的时候没有安装微信点击没有反应
- (void)showAlertView
{
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.enterMode) {
        switch (self.enterMode) {
            case RomAlertEnterModeTop:
            {
                frame.origin.y = 150;
                //-= CGRectGetHeight([[UIScreen mainScreen] bounds]) ;
                interval = 0.5;
            }
                break;
            case RomAlertEnterModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertEnterModeLeft:
            {
                frame.origin.x -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertEnterModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertEnterModeFadeIn:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    [self.mainAlertView setFrame:frame];
    // 动画
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:1];
        [self.mainAlertView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
    } completion:^(BOOL finished) {
        self.animationComplit = YES;
        if ([_delegate respondsToSelector:@selector(romAlertViewAnimationComplite)]) {
            [_delegate romAlertViewAnimationComplite];
        }
    }];
}

- (void)hide {
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.leaveMode) {
        switch (self.leaveMode) {
            case RomAlertLeaveModeTop:
            {
                frame.origin.y -= CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertLeaveModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertLeaveModeLeft:
            {
                frame.origin.y -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertLeaveModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case RomAlertLeaveModeFadeOut:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
//   __weak typeof(self)WeakSelf = self;
    if ([_delegate respondsToSelector:@selector(romAlertViewAnimationHideAlertview:)]) {
        [_delegate romAlertViewAnimationHideAlertview:self];
    }
    
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:0];
        [self.mainAlertView setFrame:frame];
    } completion:^(BOOL finished) {
         self.animationComplit = NO;
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
            
        }
        [self unregisterKVC];
    }];
}
#pragma mark -- 1 秒后隐藏弹框
- (void)hideTip
{
    [self hide];
}


- (void)registerKVC {
    for (NSString *keypath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unregisterKVC {
//    for (NSString *keypath in [self observableKeypaths]) {
//        [self removeObserver:self forKeyPath:keypath];
//    }
    @try {
        for (NSString *keypath in [self observableKeypaths]) {
            [self removeObserver:self forKeyPath:keypath];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"多次移除");
    }
   
}

- (NSArray *)observableKeypaths {
//    return [NSArray arrayWithObjects:@"RomMode",@"customView", nil];
     return [NSArray arrayWithObjects:@"RomMode", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    }
    else{
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keypath {
//    if ([keypath isEqualToString:@"RomMode"] || [keypath isEqualToString:@"customView"]) {
//        [self updateModeStyle];
//    }
        if ([keypath isEqualToString:@"RomMode"]) {
            [self updateModeStyle];
        }
}


#pragma mark -- getter 和setter 方法


- (RomCustomMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[RomCustomMaskView alloc] initWithFrame:self.bounds];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.2];
        _maskView.delegate = self;
    }
    return _maskView;
}

- (UIView *)mainAlertView {
    if (!_mainAlertView) {
        
        _mainAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KRomAlertView_Width, KRomAlertView_Height)];
        [_mainAlertView setCenter:self.center];
    }
    return _mainAlertView;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        //_scrollView.backgroundColor = [UIColor redColor];
    }
    return _scrollView;
}



- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    
    if(_detailLabel == nil){
        _detailLabel = [[UILabel alloc] init];
        //[self.mainAlertView addSubview:_detailLabel];
        
    }
    return _detailLabel;
}


- (RomCustomAlertViewTableVC *)tableViewVC
{
    if (_tableViewVC == nil) {
        _tableViewVC = [[RomCustomAlertViewTableVC alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _tableViewVC;
}







#pragma mark -- 取消按钮
- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitleColor:[UIColor colorWithRed:255/255.0 green:68/255.0 blue:4/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.tag = KbuttonTag;
        [_cancelButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainAlertView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIImageView *)imageViewStatus
{
    if (_imageViewStatus == nil) {
        _imageViewStatus = [[UIImageView alloc] init];
        [self.mainAlertView addSubview:_imageViewStatus];
    }
    return _imageViewStatus;
}



- (UILabel *)label_Title
{
    if (_label_Title == nil) {
        _label_Title = [[UILabel alloc] init];
        _label_Title.font = [UIFont systemFontOfSize:17];
        _label_Title.textColor = [UIColor whiteColor];
        _label_Title.textAlignment = NSTextAlignmentCenter;
        [self.mainAlertView addSubview:_label_Title];
    }
    return _label_Title;
}

- (UIView *)view_Line
{
    if (_view_Line == nil) {
        _view_Line = [[UIView alloc] init];
    }
    return _view_Line;
}

- (UIView *)view_LineTwo
{
    if (_view_LineTwo == nil) {
        _view_LineTwo = [[UIView alloc] init];
    }
    return _view_LineTwo;
}

- (NSMutableArray *)otherTitles
{
    if (_otherTitles == nil) {
        _otherTitles = [NSMutableArray arrayWithCapacity:0];
    }
    return _otherTitles;
}



/**
 *  标题view
 *
 *  @return <#return value description#>
 */
- (UIView *)titleBottomView
{
    if (_titleBottomView == nil) {
        _titleBottomView = [[UIView alloc] init];
        _titleBottomView.backgroundColor = [UIColor whiteColor];
        [self.mainAlertView addSubview:_titleBottomView];
    }
    return _titleBottomView;
}
/**
 *  标题label
 *
 *  @return <#return value description#>
 */
- (UILabel *)titleBottomLabel
{
    if (_titleBottomLabel == nil) {
        _titleBottomLabel = [[UILabel alloc] init];
        _titleBottomLabel.textColor = [UIColor colorWithHexString:@"323232"];
        _titleBottomLabel.font = [UIFont systemFontOfSize:16];
        _titleBottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleBottomView addSubview:_titleBottomLabel];
    }
    return _titleBottomLabel;
}


#pragma mark -- 时间处理控件
// 取消按钮
- (UIButton *) cancelDate
{
    if (_cancelDate == nil) {
        _cancelDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelDate setTitle:@"取消" forState:UIControlStateNormal];
        _cancelDate.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelDate setTitleColor:[UIColor colorWithRed:255/255.0 green:68/255.0 blue:4/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelDate.backgroundColor = [UIColor whiteColor];
        // _cancelDate.tag = KbuttonTag;
        [_cancelDate addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainAlertView addSubview:_cancelDate];
    }
    return _cancelDate;
    
}


// 确定按钮
- (UIButton *) sureDate
{
    if (_sureDate == nil) {
        _sureDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureDate setTitle:@"确定" forState:UIControlStateNormal];
        _sureDate.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureDate setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        _sureDate.backgroundColor = [UIColor whiteColor];
        // _sureDate.tag = KbuttonTag+1;
        [_sureDate addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainAlertView addSubview:_sureDate];
    }
    return _sureDate;
    
}


#pragma mark 时间段选择器--  确定按钮
- (UIButton *)timeSureData
{
    if (_timeSureData == nil) {
        _timeSureData = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeSureData setTitle:@"确定" forState:UIControlStateNormal];
        _timeSureData.titleLabel.font = [UIFont systemFontOfSize:16];
        [_timeSureData setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        _timeSureData.backgroundColor = [UIColor whiteColor];
        // _sureDate.tag = KbuttonTag+1;
        [_timeSureData addTarget:self action:@selector(completeSureTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainAlertView addSubview:_timeSureData];
    }
    return _timeSureData;
    
}

// 选择器
#pragma mark -- 时间段选择器
- (UIPickerView *)pickerTimeV
{
    if (_pickerTimeV == nil) {
        _pickerTimeV = [[UIPickerView alloc] initWithFrame:CGRectMake(0,44, SCREENWIDTH - 40, 300 -89)];
        _pickerTimeV.delegate = self;
        _pickerTimeV.dataSource = self;
        //_pickerTimeV.backgroundColor = [UIColor cyanColor];
        [self.mainAlertView addSubview:_pickerTimeV];
    }
    return _pickerTimeV;
    
}

// 时间选择器
- (UIDatePicker *)pickerV
{
    if (_pickerV == nil) {
        _pickerV = [[UIDatePicker alloc] init];
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _pickerV.backgroundColor  = [UIColor whiteColor];
        _pickerV.locale = locale;
        //设置显示日期格式
        _pickerV.datePickerMode = UIDatePickerModeDate;
        //获取当前日期：
        //NSDate日期类，date获取日期
        NSDate* date = [NSDate date];
        NSLog(@"--当前时间%@",date);// --2015-11-26 08:20:37 +0000
        // datePicker.date = date;
        
        
        
        /**
         
         NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
         NSDate *currentDate = [NSDate date];
         NSDateComponents *comps = [[NSDateComponents alloc] init];
         //        [comps setYear:10];//设置最大时间为：当前时间推后十年
         //        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
         [comps setYear:-100];//设置最小时间为：当前时间前推十年
         NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
         
         NSString *minStr = @"2008-01-01";
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
         
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         
         NSDate *minDate = [dateFormatter dateFromString:minStr];
         datePicker.minimumDate = minDate;
         */
        
        
        //从现在开始后多长时间：单位：秒
        NSDate* date1 = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*50];
       NSLog(@"---%@",date1);
        
        
        NSString *minStr = @"1916-11-11";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *minDate = [dateFormatter dateFromString:minStr];
        
        
        NSLog(@"---%@",minDate);
        //NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
        NSDate *todayDate = [NSDate date];
        NSLog(@"--当前时间%@",date);
 
        _pickerV.minimumDate = minDate;
        if (self.isOpenMaxDate) { // 默认是开启的 如果外界设置NO则不会有最大时间限时
           _pickerV.maximumDate = todayDate;
        }
        
        
        
        [_pickerV addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
        
        [self.mainAlertView addSubview:_pickerV];
        
    }
    return _pickerV;
}

#pragma mark -- 日期线条
- (UIView *)view_DateLine
{
    
    if (_view_DateLine == nil) {
        _view_DateLine = [[UIView alloc] init];
        [self.mainAlertView addSubview:_view_DateLine];
    }
    return _view_DateLine;
    
}


- (UIView *)view_BottomInsetLine
{
    if (_view_BottomInsetLine == nil) {
        _view_BottomInsetLine = [[UIView alloc] init];
        _view_BottomInsetLine.backgroundColor =[UIColor colorWithRed:206/255. green:207/255.0 blue:212/255.0 alpha:1];
        [self.mainAlertView addSubview:_view_BottomInsetLine];
    }
    return _view_BottomInsetLine;
}

#pragma mark -- 时间线条
- (UIView *)view_TimeLine
{
    
    if (_view_TimeLine == nil) {
        _view_TimeLine = [[UIView alloc] init];
        // [self.mainAlertView addSubview:_view_TimeLine];
    }
    return _view_TimeLine;
    
}



- (UIDatePicker *)datePickertimePoint_Left
{
    
    if (_datePickertimePoint_Left == nil) {
        _datePickertimePoint_Left = [[UIDatePicker alloc] init];
       // _datePickertimePoint_Left.backgroundColor = [UIColor cyanColor];
        //设置显示日期格式
        _datePickertimePoint_Left.datePickerMode = UIDatePickerModeTime;
        [_datePickertimePoint_Left setLocale:[NSLocale systemLocale]];
        _datePickertimePoint_Left.tag = 100;
        [_datePickertimePoint_Left addTarget:self action:@selector(showDate_LeftAndRight:) forControlEvents:UIControlEventValueChanged];
         [self.mainAlertView addSubview:_datePickertimePoint_Left];
    }
    
    return _datePickertimePoint_Left;
    
}

- (UILabel *)label_LeftColon
{
    if (_label_LeftColon == nil) {
        _label_LeftColon = [[UILabel alloc] init];
        _label_LeftColon.text = @":";
        _label_LeftColon.textColor = [UIColor blackColor];
        _label_LeftColon.font = [UIFont systemFontOfSize:18];
        [self.datePickertimePoint_Left addSubview:_label_LeftColon];
    }
    
    return _label_LeftColon;
}

- (UILabel *)label_RightColon
{
    if (_label_RightColon == nil) {
        _label_RightColon = [[UILabel alloc] init];
        _label_RightColon.text = @":";
        _label_RightColon.textColor = [UIColor blackColor];
        _label_RightColon.font = [UIFont systemFontOfSize:18];
        [self.datePickertimePoint_Right addSubview:_label_RightColon];
    }
    
    return _label_RightColon;
}
- (UIDatePicker *)datePickertimePoint_Right
{
    
    if (_datePickertimePoint_Right == nil) {
        _datePickertimePoint_Right = [[UIDatePicker alloc] init];
        //_datePickertimePoint_Right.backgroundColor = [UIColor brownColor];
        //设置显示日期格式
        _datePickertimePoint_Right.datePickerMode = UIDatePickerModeTime;
        [_datePickertimePoint_Right setLocale:[NSLocale systemLocale]];
        _datePickertimePoint_Right.tag = 200;
        [_datePickertimePoint_Right addTarget:self action:@selector(showDate_LeftAndRight:) forControlEvents:UIControlEventValueChanged];
         [self.mainAlertView addSubview:_datePickertimePoint_Right];
    }
    
    return _datePickertimePoint_Right;
    
}

- (void)showDate_LeftAndRight:(id)sender
{
    

    UIDatePicker* datePicker = (UIDatePicker *)sender;

    if (datePicker.tag == 100) {
        NSDate* date = datePicker.date;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        //将日期转换为字符串
        NSString* dateString = [dateFormatter stringFromDate:date];
        NSLog(@"左边的时间---%@",dateString);
        self.timePoint_Left = dateString;
    }else if (datePicker.tag == 200){
        NSDate* date = datePicker.date;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        //将日期转换为字符串
        NSString* dateString = [dateFormatter stringFromDate:date];
        self.timePoint_Right = dateString;
        NSLog(@"右边的时间---%@",dateString);
        
    }
    
    
}

// 时间点设置
- (void)setSelectLeftTime:(NSString *)leftTime WithRightTime:(NSString *)rightTime
{
    
    NSString *left_strTime = leftTime;
    NSDateFormatter *fmt_left = [[NSDateFormatter alloc] init];
    fmt_left.dateFormat = @"HH:mm";
    NSDate *left_tempTime = [fmt_left dateFromString:left_strTime];
    [self.datePickertimePoint_Left setDate:left_tempTime animated:YES];
    
    NSString *right_strTime = rightTime;
    NSDateFormatter *fmt_right = [[NSDateFormatter alloc] init];
    fmt_right.dateFormat = @"HH:mm";
    NSDate *right_tempTime = [fmt_right dateFromString:right_strTime];
    [self.datePickertimePoint_Right setDate:right_tempTime animated:YES];
    
}


#pragma mark -- block
- (void)showWithBlock:(selectButtonIndexComplete)completeBlock {
    self.completeBlock = completeBlock;
    [self show];
}


#pragma mark -- mark 取消按钮
- (void)cancelBtn
{
    if ( self.animationComplit == YES) {
        [self hide];
    }
}

#pragma mark -- 灰色蒙版的代理事件
- (void)customMaskView:(RomCustomMaskView *)maskView
{
    
    NSLog(@"执行了代理事件");
    
    if (self.animationComplit == YES) { // 判断动画是否执行完毕
        // 此属性控制点击其他区域是否消失
        if (self.otherClickExit == YES) {
            [self hide];
            if (_completHidBlock) {
                _completHidBlock();
            }
        }else{
            
        }
    }
    
    
    
    
}


#pragma mark -- 代理
#pragma mark -- 自定义的View
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_delegate respondsToSelector:@selector(alertview:didSelectRowAtIndexPath:)]) {
        [_delegate alertview:self didSelectRowAtIndexPath:indexPath];
    }
    NSLog(@"里面打印>>>>>>>>>>>>>%ld",indexPath.row);
    
    if ([_delegate respondsToSelector:@selector(alertview:didSelectWebRowAtIndexPath:)]) {
        [_delegate alertview:self didSelectWebRowAtIndexPath:indexPath];
        NSLog(@"web里面打印>>>>>>>>>>>>>%ld",indexPath.row);
    }
    [self hide];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveExitLoginNoti
{
    [self hide];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
