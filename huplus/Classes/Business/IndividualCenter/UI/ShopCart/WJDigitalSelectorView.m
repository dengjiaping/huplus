//
//  WJDigitalSelectorView.m
//  HuPlus
//
//  Created by reborn on 17/1/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJDigitalSelectorView.h"

@interface WJDigitalSelectorView ()
{
    UIButton *reduceButton;
    UIButton *plusButton;
    UILabel  *curCountL;
    
    NSInteger curCount;
}

@end


@implementation WJDigitalSelectorView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        curCount = 0;
        
        self.backgroundColor = WJColorWhite;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 22;
        self.layer.borderColor = WJColorSeparatorLine.CGColor;
        
        //减
        UIImage *reduceImage = [UIImage imageNamed:@"icon_SelectDele"];
        reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceButton.frame = CGRectMake(0, 0, reduceImage.size.width + ALD(30), reduceImage.size.height + ALD(20));
        [reduceButton setTitle:@"-" forState:UIControlStateNormal];
        reduceButton.layer.borderWidth = 1;
        reduceButton.layer.borderColor = WJColorSeparatorLine.CGColor;
        [reduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [reduceButton setImage:reduceImage forState:UIControlStateNormal];
        [reduceButton addTarget:self action:@selector(reduceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //数量值
        curCountL = [[UILabel alloc] initWithFrame:CGRectMake(reduceButton.right  +ALD(10), 0, reduceImage.size.width + ALD(20), reduceImage.size.height + ALD(20))];
        curCountL.font = WJFont14;
        curCountL.textColor = WJColorNavigationBar;
        curCountL.textAlignment = NSTextAlignmentCenter;
        curCountL.text = [NSString stringWithFormat:@"%ld",curCount];
        curCountL.backgroundColor = [UIColor clearColor];
        
        //加
        UIImage *plusImage = [UIImage imageNamed:@"icon_SelectAdd"];
        plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame = CGRectMake(curCountL.right + ALD(10), 0, plusImage.size.width + ALD(30), plusImage.size.height + ALD(20));
        [plusButton setTitle:@"+" forState:UIControlStateNormal];
        plusButton.layer.borderWidth = 1;
        plusButton.layer.borderColor = WJColorSeparatorLine.CGColor;
//        [plusButton setImage:plusImage forState:UIControlStateNormal];
        [plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [plusButton addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:curCountL];
        [self addSubview:reduceButton];
        [self addSubview:plusButton];
        
    }
    
    return self;
}

-(void)refeshDigitalSelectorViewWithCount:(NSInteger)count
{
    curCount = count;
    curCountL.text = [NSString stringWithFormat:@"%ld",curCount];
}


-(void)reduceBtnClicked
{
    NSLog(@"减");
    if (self.countChangeBlock) {
        self.countChangeBlock(NO);
    }
}

-(void)plusBtnClicked
{
    NSLog(@"加");
    if (self.countChangeBlock) {
        self.countChangeBlock(YES);
    }

}

+(CGFloat)width
{
    UIImage *reduceImage = [UIImage imageNamed:@"icon_SelectDele"];
        return reduceImage.size.width *3 +ALD(100);
    
}

+ (CGFloat)height
{
    UIImage *reduceImage = [UIImage imageNamed:@"icon_SelectDele"];
    return reduceImage.size.height+ALD(20);
}

@end
