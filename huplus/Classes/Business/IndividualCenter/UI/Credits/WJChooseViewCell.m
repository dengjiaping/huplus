//
//  WJChooseViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJChooseViewCell.h"

@interface WJChooseViewCell ()
{
    UILabel     * valueLabel;
    UILabel     * desLabel;
}
@end

@implementation WJChooseViewCell

- (instancetype) initWithPoint:(CGPoint)point value:(NSString *)value des:(NSString *)describe
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, ALD(110), ALD(60))];
    if (self) {
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(10), ALD(110), ALD(25))];
        valueLabel.font = [UIFont boldSystemFontOfSize:19];
        valueLabel.textColor = WJColorDardGray3;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = value;
        
        desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(35), ALD(110), ALD(20))];
        desLabel.font = WJFont11;
        desLabel.textColor = WJColorDardGray3;
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.text = [NSString stringWithFormat:@"%.2f积分",[describe floatValue]];
        
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [[WJUtilityMethod colorWithHexColorString:@"e6e7e8"] CGColor];
        self.layer.borderWidth = 1;
        
        [self addSubview:valueLabel];
        [self addSubview:desLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        valueLabel.textColor = WJColorMainRed;
        desLabel.textColor = WJColorMainRed;
        self.layer.borderColor = [WJColorMainRed CGColor];
    } else {
        desLabel.textColor = WJColorDardGray3;
        valueLabel.textColor = WJColorDardGray3;
        self.layer.borderColor = [[WJUtilityMethod colorWithHexColorString:@"e6e7e8"] CGColor];
    }
}


@end
