//
//  WJSearchHistoryTableCell.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJSearchHistoryTableCell.h"

@implementation WJSearchHistoryTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *timeImage = [UIImage imageNamed:@"historyRecord"];
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(44) -timeImage.size.height)/2, timeImage.size.width, timeImage.size.height)];
        timeImageView.image = timeImage;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame) + ALD(10), 0, SCREEN_WIDTH - timeImageView.width - ALD(12), ALD(44))];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = WJColorLightGray;
        self.nameLabel.font = WJFont15;
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44)-0.5, kScreenWidth-ALD(24), 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        
        [self.contentView addSubview:timeImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:bottomLine];
        
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
