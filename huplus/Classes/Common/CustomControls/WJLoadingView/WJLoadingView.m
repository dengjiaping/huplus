//
//  WJLoadingView.m
//  WanJiCard
//
//  Created by 孙明月 on 16/1/13.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJLoadingView.h"

@implementation WJLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAnimating = NO;
        
        UIImage *loadimage = [UIImage imageNamed:@"WJLoading_001"];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - loadimage.size.width)/2,0, loadimage.size.width,loadimage.size.height)];

//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width,frame.size.height-20)];
        [self addSubview:imageView];
        //设置动画帧
        imageView.animationImages=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"WJLoading_001"],
                                   [UIImage imageNamed:@"WJLoading_002"],
                                   [UIImage imageNamed:@"WJLoading_003"],
                                   [UIImage imageNamed:@"WJLoading_004"],
                                   [UIImage imageNamed:@"WJLoading_005"],
                                   [UIImage imageNamed:@"WJLoading_006"],
                                   [UIImage imageNamed:@"WJLoading_007"],
                                   [UIImage imageNamed:@"WJLoading_008"],
                                   [UIImage imageNamed:@"WJLoading_009"],
                                   [UIImage imageNamed:@"WJLoading_010"],
                                   [UIImage imageNamed:@"WJLoading_011"],
                                   [UIImage imageNamed:@"WJLoading_012"],
                                   [UIImage imageNamed:@"WJLoading_013"],
                                   [UIImage imageNamed:@"WJLoading_014"],
                                   [UIImage imageNamed:@"WJLoading_015"],
                                   [UIImage imageNamed:@"WJLoading_016"],
                                   [UIImage imageNamed:@"WJLoading_017"],

                                   nil];
        
        
        Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.textAlignment = NSTextAlignmentCenter;
        Infolabel.textColor = [UIColor colorWithRed:84.0/255 green:86./255 blue:212./255 alpha:1];
        Infolabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14.0f];
        [self addSubview:Infolabel];
        self.layer.hidden = YES;
    }
    return self;
}


- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

- (void)doAnimation{
    
    Infolabel.text = _loadtext;
    //设置动画总时间
    imageView.animationDuration=1.0;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"WJLoading_017"]];
    }
    
}


- (void)setLoadText:(NSString *)text;
{
    if(text){
        
        _loadtext = text;
    }
}

@end
