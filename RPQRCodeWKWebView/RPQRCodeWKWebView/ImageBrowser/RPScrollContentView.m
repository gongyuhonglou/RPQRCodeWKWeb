//
//  RPScrollContentView.m
//  RPImageBrowser
//
//  Created by WRP on 2018/4/4.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "RPScrollContentView.h"
#import "RPImageView.h"

@interface RPScrollContentView()<PhotoDelegate>

@property (nonatomic, strong)UIScrollView * contentView;

@property (nonatomic, copy)selectBlock selectHandle;

@property (nonatomic, assign)int oldPage;

@property (nonatomic, strong)NSArray * imageUrls;

@property (nonatomic, copy)tapBlock clickBlock;

@property (nonatomic, strong)UIPageControl * pageControl;

@end
@implementation RPScrollContentView

- (UIPageControl*)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,__gTopViewHeight-90,__gScreenWidth, 30)];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    }
    
    return _pageControl;
}


- (void)dealloc
{
    [self.contentView removeObserver:self forKeyPath:@"contentOffset"];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
        self.oldPage = -1;
        
        if (@available(iOS 11.0,*)) {
            
            self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [self.contentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}
- (UIScrollView*)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.maximumZoomScale = 3;
        _contentView.minimumZoomScale = 1;
        _contentView.backgroundColor = [UIColor blackColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if (object == self.contentView)
    {
        NSValue * value = (NSValue*)[change valueForKey:@"new"];
        
        CGPoint newPoint = [value CGPointValue];
        
        int page = floor(newPoint.x/self.frame.size.width);
        
        if (page<=-1||page>=self.imageUrls.count)
        {
            return;
        }
        if (self.oldPage!=page)
        {
            if (self.selectHandle)
            {
                self.selectHandle(page);
            }
        }
        
        self.oldPage = page;
        NSLog(@"-------------%ld",(long)page);
    }
    
}

- (void)loadImageUrls:(NSArray *)images defaultIndex:(NSInteger)index currentSelectIndex:(selectBlock)indexBlock
{
    CGFloat viewWidth = self.frame.size.width;
    
    CGFloat viewHeight = self.frame.size.height;
    
    self.contentView.contentSize = CGSizeMake(viewWidth*images.count,viewHeight);
    
    self.imageUrls = images;
    
    self.pageControl.numberOfPages = images.count;
    
    self.selectHandle = indexBlock;
 
    for (int i =0; i<images.count; i++)
    {
        NSString * url = images[i];
        CGFloat X = i * viewWidth;
        
        RPImageView *imageView = [[RPImageView alloc]initWithFrame:CGRectMake(X,0,viewWidth,viewHeight)];
        imageView.delegate = self;
        [imageView setImageUrl:url placeHolderImage:self.placeholderImage];
        [self.contentView addSubview:imageView];
    }
    
    [self.contentView setContentOffset:CGPointMake(index*viewWidth, 0)];
}

- (void)tapHiddenView
{
    if (self.clickBlock)
    {
        self.clickBlock();
    }
}

- (void)tapViewBlock:(tapBlock)handleBlock
{
    if (handleBlock)
    {
        self.clickBlock = handleBlock;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
