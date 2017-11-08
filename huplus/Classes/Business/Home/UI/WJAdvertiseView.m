//
//  WJAdvertiseView.m
//  HuPlus
//
//  Created by reborn on 17/3/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJAdvertiseView.h"
#import <UIButton+WebCache.h>
#import "WJHomeBannerModel.h"
#import "WJAdvertiseModel.h"
@interface WJAdvertiseView ()
{
    NSMutableArray   *buttonsArray;
}

@end

@implementation WJAdvertiseView


-(instancetype)initWithFrame:(CGRect)frame UIType:(NSString *)type
{
    self=[super initWithFrame:frame];
    if (self) {
        
        buttonsArray = [[NSMutableArray alloc] init];
        
        [self setUIWithType:type];
        
    }
    return self;
}


-(void)setUIWithType:(NSString *)type
{
    if ([type isEqualToString:@"app_special_ad1"]) {
        [self thirdUI];


    } else if ([type isEqualToString:@"app_special_ad2"]) {
        [self firstUI];


    } else if ([type isEqualToString:@"app_special_ad3"]) {
        [self fourUI];

    } else if ([type isEqualToString:@"app_special_ad4"]) {
        
        [self secondUI];

    } else {
        
        [self fiveUI];

    }
}

-(void)firstUI
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1004 + i;
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(btnClickAdvertise:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth/2, ALD(80));
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 1) {
            button.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, ALD(80));
            
        } else if (i == 2) {
            button.frame = CGRectMake(0, ALD(80), kScreenWidth/4, ALD(80));
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 3) {
            button.frame = CGRectMake(kScreenWidth/4, ALD(80), kScreenWidth/2, ALD(80));
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else {
            
            button.frame = CGRectMake(kScreenWidth/4 * 3, ALD(80), kScreenWidth/4, ALD(80));
            
        }
        [self addSubview:button];
        
        [buttonsArray addObject:button];
    }

}

-(void)secondUI
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1004 + i;
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(btnClickAdvertise:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth/4, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 1) {
            button.frame = CGRectMake(kScreenWidth/4, 0, kScreenWidth/2, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 2) {
            button.frame = CGRectMake(kScreenWidth/4 * 3, 0, kScreenWidth/4, ALD(160));
            
        } else if (i == 3) {
            button.frame = CGRectMake(0, ALD(80), kScreenWidth/2, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else {
            
            button.frame = CGRectMake(kScreenWidth/2, ALD(80), kScreenWidth/4, ALD(80));
            
        }
        [self addSubview:button];
        
        [buttonsArray addObject:button];
    }
}

-(void)thirdUI
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1004 + i;
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(btnClickAdvertise:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth/2, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 1) {
            button.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, ALD(80));
            
        } else if (i == 2) {
            button.frame = CGRectMake(0, ALD(80), kScreenWidth/2, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 3) {
            button.frame = CGRectMake(kScreenWidth/2, ALD(80), kScreenWidth/4, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else {
            
            button.frame = CGRectMake(kScreenWidth/4 * 3, ALD(80), kScreenWidth/4, ALD(80));
        }
        [self addSubview:button];
        
        [buttonsArray addObject:button];
    }
}

-(void)fourUI
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1004 + i;
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(btnClickAdvertise:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth/2, ALD(160));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(160))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 1) {
            button.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/4, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, button.bottom, kScreenWidth/4, 0.5)];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 2) {
            button.frame = CGRectMake(kScreenWidth/4 * 3, 0, kScreenWidth/4, ALD(160));
            
        } else if (i == 3) {
            button.frame = CGRectMake(kScreenWidth/2, ALD(80), kScreenWidth/4, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(160))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
        }
        [self addSubview:button];
        
        [buttonsArray addObject:button];
    }
}

-(void)fiveUI
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1004 + i;
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(btnClickAdvertise:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth/2, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(160))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 1) {
            button.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/4, ALD(160));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, 0, 0.5, ALD(160))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else if (i == 2) {
            button.frame = CGRectMake(kScreenWidth/4 * 3, 0, kScreenWidth/4, ALD(160));
            
        } else if (i == 3) {
            button.frame = CGRectMake(0, ALD(80), kScreenWidth/4, ALD(80));
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.right, ALD(80), 0.5, ALD(80))];
            lineView.backgroundColor = WJColorSeparatorLine;
            [self addSubview:lineView];
            
        } else {
            
            button.frame = CGRectMake(kScreenWidth/4, ALD(80), kScreenWidth/4, ALD(80));
            
        }
        [self addSubview:button];
        
        [buttonsArray addObject:button];
    }

}

-(void)configDataWithArray:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
    
        if (buttonsArray.count > 0) {
            
            UIButton *button = [buttonsArray objectAtIndex:i];
            
            for (WJAdvertiseModel *model in array) {
                
                if (i + 1 == model.positonNumber) {
                    
                    [button sd_setImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:BitmapBannerImage];
                }
                
            }
        }

    }
}

#pragma makr - Action
-(void)btnClickAdvertise:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickAdvertiseWithIndex:)]) {
        NSInteger index = button.tag - 1004;
        [self.delegate clickAdvertiseWithIndex:index];
    }
}

@end
