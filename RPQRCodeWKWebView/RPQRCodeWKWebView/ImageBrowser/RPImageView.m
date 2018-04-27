//
//  RPImageView.m
//  RPImageBrowser
//
//  Created by WRP on 2018/3/29.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "RPImageView.h"
#import <UIImageView+WebCache.h>

#import "AppDelegate.h"
#import "ADWebViewViewController.h"
#import <Photos/Photos.h>

@interface RPImageView()<UIScrollViewDelegate,RomAlertViewDelegate>
{
    RomAlertView *alertview;
    NSString *qrCodeUrl;
}

@property (nonatomic, strong)UIImageView * imageView;

@property (nonatomic, strong)UIScrollView * contentView;

@end
@implementation RPImageView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.contentView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.maximumZoomScale = 3;
        _contentView.minimumZoomScale = 1;
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
        [_contentView setZoomScale:1];
        [self addSubview:self.contentView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
        //双击手势
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        //双指放大
        UITapGestureRecognizer * doubleFinger = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTwoFingerTap:)];
        doubleFinger.numberOfTouchesRequired = 2;
        [self.imageView addGestureRecognizer:doubleFinger];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
//        // 长按图片识别二维码
//        UILongPressGestureRecognizer *QrCodeTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(QrCodeClick:)];
//        [self.imageView addGestureRecognizer:QrCodeTap];
        
    }
    return self;
}



- (void)handleSingleTap:(UITapGestureRecognizer*)single
{
    if (single.numberOfTapsRequired==1)
    {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(tapHiddenView)])
        {
            [self.delegate tapHiddenView];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)doubleTap
{
    if (doubleTap.numberOfTapsRequired==2)
    {
        if (_contentView.zoomScale==1)
        {
            float newScale = [_contentView zoomScale]*2;
            
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleTap locationInView:doubleTap.view]];
            
            [_contentView zoomToRect:zoomRect animated:YES];
        }
        else
        {
            float newScale = [_contentView zoomScale]/2;
            
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleTap locationInView:doubleTap.view]];
            
            [_contentView zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)handleTwoFingerTap:(UITapGestureRecognizer*)gesture
{
    float newScale = [_contentView zoomScale]/2;
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    
    [_contentView zoomToRect:zoomRect animated:YES];
}

- (void)setImageUrl:(NSString *)url placeHolderImage:(UIImage *)placeHolder
{
    if ([url hasPrefix:@"http:"]||[url hasPrefix:@"https:"])
    {
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
         {
             UIImage * newImage = [weakSelf scaleSizeForImage:image];
             [weakSelf updateIGVFrameForImage:newImage];
         }];
    }
    else
    {
        UIImage * image = [UIImage imageNamed:url];
        UIImage * newImage = [self scaleSizeForImage:image];
        [self updateIGVFrameForImage:newImage];
        self.imageView.image = newImage;
    }
}
//对图片进行屏幕缩放
- (UIImage*)scaleSizeForImage:(UIImage*)sourceImage
{
    CGFloat scale = 1;
  
    if (__gTopViewHeight>__gScreenWidth)
    {
        scale = __gScreenWidth/sourceImage.size.width;
    }
    else
    {
        scale = __gTopViewHeight/sourceImage.size.height;
    }
   
    CGFloat imageWidth = sourceImage.size.width * scale;
    
    CGFloat imageHeight = sourceImage.size.height * scale;
    
    CGSize size = CGSizeMake(imageWidth, imageHeight);
    
    UIImage * newImage = nil;
    
    if (CGSizeEqualToSize(sourceImage.size, size)==NO)
    {
        UIGraphicsBeginImageContext(size);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.size.width = imageWidth;
        thumbnailRect.size.height = imageHeight;
        [sourceImage drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (void)updateIGVFrameForImage:(UIImage*)image
{
    CGRect imageViewRect = self.imageView.frame;
    imageViewRect.size = image.size;
    imageViewRect.origin.y = (self.frame.size.height-image.size.height)*0.5;
    self.imageView.frame = imageViewRect;
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01f animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

//让图片保持在屏幕中央，防止图片放大时，位置出现跑偏
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (_contentView.bounds.size.width>_contentView.contentSize.width)?(_contentView.bounds.size.width-_contentView.contentSize.width)*0.5:0;
    
    CGFloat offsetY = (_contentView.bounds.size.height>_contentView.contentSize.height)?(_contentView.bounds.size.height-_contentView.contentSize.height)*0.5:0;
    
    self.imageView.center = CGPointMake(_contentView.contentSize.width*0.5+offsetX, _contentView.contentSize.height*0.5+offsetY);
    
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = _contentView.frame.size.height/scale;
    
    zoomRect.size.width = _contentView.frame.size.width/scale;
    
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    
    return zoomRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
