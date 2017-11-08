//
//  WJOrderConfirmCell.m
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderConfirmCell.h"

@interface WJOrderConfirmCell ()
{
    UILabel     *nameL;
    UIImageView *rightArrowImageView;
}

@end


@implementation WJOrderConfirmCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(110), ALD(44))];
        nameL.textColor = WJColorNavigationBar;
        nameL.font = WJFont14;
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(34) - ALD(220), 0, ALD(220), ALD(44))];
        _contentL.textColor = WJColorDardGray9;
        _contentL.font = WJFont14;
        _contentL.textAlignment = NSTextAlignmentRight;
        
        UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
        rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - image.size.width, (ALD(44) - image.size.height)/2, image.size.width, image.size.height)];
        rightArrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        rightArrowImageView.hidden = YES;
        
        [self addSubview:nameL];
        [self addSubview:_contentL];
        [self addSubview:rightArrowImageView];
    }
    
    return self;
}

-(void)configDataWithName:(NSString *)name Content:(NSString *)content
{
    nameL.text = name;
    _contentL.text = content;
    
    if (self.isShowRightArrow) {
        rightArrowImageView.hidden = NO;
    } else {
        rightArrowImageView.hidden = YES;
        _contentL.frame = CGRectMake(kScreenWidth - ALD(12) - ALD(220), 0, ALD(220), ALD(44));

    }
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
