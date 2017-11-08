//
//  WJProductDetailHeadCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailHeadCell.h"

@implementation WJProductDetailHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = WJFont14;
        self.textLabel.textColor = WJColorNavigationBar;
        UIView * bottomLine = [[UIView alloc]initForAutoLayout];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        [self.contentView addConstraints:[bottomLine constraintsSize:CGSizeMake(kScreenWidth - 24, 0.5)]];
        [self.contentView addConstraints:[bottomLine constraintsLeftInContainer:12]];
        [self.contentView addConstraints:[bottomLine constraintsBottomInContainer:0]];
    }
    return self;
}

@end
