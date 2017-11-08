//
//  WJMessageCell.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageCell.h"
#import "WJSystemNewsModel.h"

@interface WJMessageCell ()
{
    UIImageView *imageIV;
    UILabel *titleL;
    UILabel *timeL;
    UILabel *contentL;
}

@end


@implementation WJMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        imageIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(78) - ALD(48))/2, ALD(48), ALD(48))];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(imageIV.right + ALD(15), (ALD(78) - ALD(17))/2, ALD(100), ALD(20))];
        titleL.textColor = WJColorNavigationBar;
        titleL.font = WJFont16;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(70), CGRectGetMinY(titleL.frame), ALD(70), ALD(20))];
        timeL.textColor = WJColorDardGray6;
        timeL.font = WJFont14;
        
        contentL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleL.frame),titleL.bottom + ALD(5), kScreenWidth - ALD(48) - ALD(27) - ALD(12), ALD(20))];
        contentL.lineBreakMode = NSLineBreakByTruncatingTail;
        contentL.textColor = WJColorDardGray6;
        contentL.font = WJFont14;
        
        [self.contentView addSubview:imageIV];
        [self.contentView addSubview:titleL];
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:contentL];
    }
    return self;
}

-(void)configDataWith:(WJSystemNewsModel *)model Icon:(NSString *)icon
{
    imageIV.image = [UIImage imageNamed:icon];
    titleL.text = model.title;
    timeL.text = model.date;
    contentL.text = model.content;
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
