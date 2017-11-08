//
//  WJAdvertiseView.h
//  HuPlus
//
//  Created by reborn on 17/3/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJAdvertiseViewDelegate <NSObject>

-(void)clickAdvertiseWithIndex:(NSInteger)index;

@end

@interface WJAdvertiseView : UIView
@property(nonatomic,weak)id <WJAdvertiseViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame UIType:(NSString *)type;
-(void)configDataWithArray:(NSMutableArray *)array;

@end
