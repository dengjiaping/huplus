//
//  WJCustomBannerView.m
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCustomBannerView.h"
//#import <UIImageView+WebCache.h>
#import "WJHomeBannerModel.h"
#import "UIImageView+GCDImage.h"

#define SCREEN_COUNT 3

@interface WJCustomBannerView ()<UIScrollViewDelegate>
{
    UITapGestureRecognizer *tap;
    NSInteger              imgCount;      //图片总个数

    NSInteger              leftCurIndex;  //左边imageView当前的序号
    NSInteger              centerCurIndex;//中间imageView当前的序号
    NSInteger              rightCurIndex; //右边imageView当前的序号
    NSTimer                *timer;
}
@property(nonatomic,strong)UIScrollView      *myScrollView;
@property(nonatomic,strong)UIImageView       *leftImgView;
@property(nonatomic,strong)UIImageView       *centerImgView;
@property(nonatomic,strong)UIImageView       *rightImgView;
@property(nonatomic,strong)UIPageControl     *pageControl;

@property(nonatomic,strong)NSArray           *imageArray;
@property(nonatomic,assign)NSTimeInterval    timeInterVal;
@property(nonatomic,strong)ImageClickBlock   imageClickBlock;

@end

@implementation WJCustomBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - 添加定时器
-(void)addTimer
{
    if (timer==nil) {
        
        _timeInterVal = 3;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterVal target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }
}

#pragma mark - 定时器执行方法
-(void)timerAction
{
    [UIView animateWithDuration:1 animations:^{
        _myScrollView.contentOffset=CGPointMake(kScreenWidth*2, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_myScrollView];
    }];
}

#pragma mark---暂停定时器
-(void)pasueTimer
{
    [timer invalidate];
    timer = nil;
}

#pragma mark---开始定时器
-(void)startTimer
{
    [self addTimer];
}

+(instancetype)CreateBannerViewWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray timerWithTimeInterval:(NSTimeInterval)timeInterval imageClickBlock:(ImageClickBlock)imageClickBlock
{
    WJCustomBannerView *bannerView = [[WJCustomBannerView alloc] initWithFrame:frame];
    bannerView.imageArray = imageArray;
    bannerView.timeInterVal = timeInterval;
    bannerView.imageClickBlock = imageClickBlock;
    return bannerView;
}

#pragma mark---属性重新赋值
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray=imageArray;
    imgCount=_imageArray.count;
    
    [self addScrollView];
    [self addLeftImgView];
    [self addCenterImgView];
    [self addRightImgView];
    
    [self configCenterImageViewData];
    [self addPageControl];
}

-(void)setTimeInterVal:(NSTimeInterval)timeInterVal
{
    _timeInterVal = timeInterVal;
    
    [self addTimer];
}

#pragma mark - 小圆点控制器位置
-(void)setPageControlAlignment:(NSPageControlAlignment)pageControlAlignment
{
    CGSize size= [_pageControl sizeForNumberOfPages:imgCount];
    
    if (pageControlAlignment==NSPageControlAlignmentCenter) {
        _pageControl.center=CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-size.height/2);
    }else if(pageControlAlignment==NSPageControlAlignmentRight){
        _pageControl.center=CGPointMake(self.bounds.size.width-size.width/2-20, self.bounds.size.height-size.height/2);
    }
}

#pragma mark -当前小圆点颜色
-(void)setCurPageControlColor:(UIColor *)curPageControlColor
{
    _pageControl.currentPageIndicatorTintColor=curPageControlColor;
}

#pragma mark - 其余小圆点颜色
-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor
{
    _pageControl.pageIndicatorTintColor=otherPageControlColor;
}

-(void)configCenterImageViewData
{
    //默认第_imgCount-1个
    leftCurIndex=imgCount - 1;
    //默认第0个
    centerCurIndex=0;
    //默认第1个
    rightCurIndex=1;
    
    WJHomeBannerModel *bannerModel = _imageArray[centerCurIndex];
    [_centerImgView setImageWithURLString:bannerModel.picUrl placeholderImage:BitmapBannerImage];
}

#pragma mark - 图片点击事件
-(void)tap:(UIPanGestureRecognizer *)pan
{
    self.imageClickBlock(centerCurIndex);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    //图片向左滑动，展示下一张图片
    if (offsetX>kScreenWidth) {
        leftCurIndex ++;
        centerCurIndex ++;
        rightCurIndex ++;
        
        if (leftCurIndex > imgCount - 1) {
            leftCurIndex = 0;
        }
        if (centerCurIndex > imgCount - 1) {
            centerCurIndex = 0;
        }
        if (rightCurIndex > imgCount - 1) {
            rightCurIndex = 0;
        }
        //图片向右滑动，展示上一张图片
    } else if (offsetX < kScreenWidth){
        leftCurIndex --;
        centerCurIndex --;
        rightCurIndex --;
        
        if (leftCurIndex < 0) {
            leftCurIndex = imgCount - 1;
        }
        if (centerCurIndex < 0) {
            centerCurIndex = imgCount - 1;
        }
        if (rightCurIndex < 0) {
            rightCurIndex = imgCount - 1;
        }
    }
    //设置小圆点控制器的位置
    _pageControl.currentPage=centerCurIndex;
    
    //切换左，中，右三个位置上面的图片
    if (self.imageArray.count > 0) {
        
        WJHomeBannerModel *leftBannerModel = self.imageArray[leftCurIndex];
        WJHomeBannerModel *centerBannerModel = self.imageArray[centerCurIndex];
        WJHomeBannerModel *rightBannerModel = self.imageArray[rightCurIndex];

        [_leftImgView setImageWithURLString:leftBannerModel.picUrl placeholderImage:BitmapBannerImage];
        [_centerImgView setImageWithURLString:centerBannerModel.picUrl placeholderImage:BitmapBannerImage];
        [_rightImgView setImageWithURLString:rightBannerModel.picUrl placeholderImage:BitmapBannerImage];
    }

    //scrollView滑动之后始终保持_centerImgView在正中间
    scrollView.contentOffset=CGPointMake(kScreenWidth, 0);
}

-(void)addScrollView
{
    if (_myScrollView == nil) {
        _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _myScrollView.showsVerticalScrollIndicator=NO;
        _myScrollView.delegate=self;
        _myScrollView.bounces=NO;
        _myScrollView.pagingEnabled=YES;
        _myScrollView.showsHorizontalScrollIndicator=NO;
        _myScrollView.contentSize=CGSizeMake(SCREEN_COUNT*kScreenWidth, self.bounds.size.height);
        _myScrollView.contentOffset=CGPointMake(kScreenWidth, 0);
        [self addSubview:_myScrollView];
    }
}

-(void)addLeftImgView
{
    if (_leftImgView == nil) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _myScrollView.height)];
        _leftImgView.contentMode =  UIViewContentModeScaleToFill;
        [_myScrollView addSubview:_leftImgView];
    }
}

-(void)addCenterImgView
{
    if (_centerImgView == nil) {
        
        _centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, SCREEN_WIDTH, _myScrollView.height)];
        _centerImgView.userInteractionEnabled = YES;
        _centerImgView.contentMode =  UIViewContentModeScaleToFill;
        [_myScrollView addSubview:_centerImgView];

        tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_centerImgView addGestureRecognizer:tap];
    }
}

-(void)addRightImgView
{
    if (_rightImgView == nil) {
        _rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, SCREEN_WIDTH, _myScrollView.height)];
        _rightImgView.contentMode = UIViewContentModeScaleToFill;
        [_myScrollView addSubview:_rightImgView];
    }
}

-(void)addPageControl
{
    if (_pageControl == nil) {
        
        _pageControl=[[UIPageControl alloc]init];
        CGSize size= [_pageControl sizeForNumberOfPages:imgCount];
        _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
        _pageControl.center=CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-size.height/2);
        _pageControl.pageIndicatorTintColor = COLOR(255, 255, 255, 0.3);
        _pageControl.currentPageIndicatorTintColor = [WJUtilityMethod colorWithHexColorString:@"#ffffff"];
        _pageControl.numberOfPages=imgCount;
        [self addSubview:_pageControl];
    }
}
@end
