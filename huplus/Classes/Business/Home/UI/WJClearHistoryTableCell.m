//
//  WJClearHistoryTableCell.m
//  HuPlus
//
//  Created by reborn on 17/3/29.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJClearHistoryTableCell.h"

@implementation WJClearHistoryTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGSize textSize = [@"清除历史记录" boundingRectWithSize:CGSizeMake(10000000, 100)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName, nil]
                                                  context:nil].size;
        
        UIImage *clearImg = [UIImage imageNamed:@"searchHistoryClean_icon"];
//        UIImageView *cleanImageIV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (clearImg.size.width + textSize.width) - ALD(5))/2, (ALD(44)  - clearImg.size.height)/2, clearImg.size.width, clearImg.size.height)];
        UIImageView *cleanImageIV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (ALD(15) + textSize.width) - ALD(5))/2, (ALD(44)  - ALD(15))/2,ALD(15), ALD(15))];
        cleanImageIV.image = clearImg;
        [self.contentView addSubview:cleanImageIV];
        
        
        UILabel *labelL  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cleanImageIV.frame) + ALD(5), 0, textSize.width, ALD(44))];
        labelL.text = @"清除历史记录";
        labelL.font = WJFont14;
        labelL.textColor = WJColorDardGray9;
        [self.contentView addSubview:labelL];
        

//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(CGRectGetMaxX(cleanImage.frame) + ALD(5), 0, textSize.width, ALD(44))];
//        [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
//        [button setTitleColor:WJColorLightGray forState:UIControlStateNormal];
//        button.backgroundColor = WJColorWhite;
//        [button.titleLabel setFont:WJFont14];
//        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:button];
//        
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44)-0.5, SCREEN_WIDTH, 0.5)];
//        bottomLine.backgroundColor = WJColorSeparatorLine;
//        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
