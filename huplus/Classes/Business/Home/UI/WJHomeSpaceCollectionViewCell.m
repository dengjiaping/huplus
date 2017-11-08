//
//  WJHomeSpaceCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 17/3/31.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHomeSpaceCollectionViewCell.h"

@implementation WJHomeSpaceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, ALD(10))];
        spaceView.backgroundColor = WJColorViewBg;
        [self addSubview:spaceView];
        
    }
    return self;
}
@end
