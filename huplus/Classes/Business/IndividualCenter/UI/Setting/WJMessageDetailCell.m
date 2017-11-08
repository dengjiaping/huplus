//
//  WJMessageDetailCell.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageDetailCell.h"
#import "WJSystemNewsModel.h"

@interface WJMessageDetailCell ()
{
    UILabel *titleL;
    UILabel *timeL;
    UILabel *contentL;
}
@end

@implementation WJMessageDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = WJColorViewBg2;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),contentL.bottom + ALD(10), ALD(200),  ALD(15))];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = WJFont12;
        timeL.textColor = WJColorLightGray;
 
        
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.font = WJFont32;
        titleL.textColor =WJColorNavigationBar;
        titleL.textAlignment = NSTextAlignmentCenter;
        
        
        contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.lineBreakMode = NSLineBreakByWordWrapping;
        contentL.numberOfLines = 0;
        contentL.font          = WJFont14;
        contentL.textColor     = WJColorDarkGray;
        
        
        [self.contentView addSubview:titleL];
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:contentL];
    }
    return self;
}

- (void)configData:(WJSystemNewsModel *)model{
    
    timeL.text  = [NSString stringWithFormat:@"%@",model.date];
    titleL.text = model.title;
    contentL.text = model.content;
    
    NSDictionary *dic           = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText             = [contentL.text boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:dic context:nil].size;
    
    
    titleL.frame = CGRectMake(ALD(12), ALD(15), ALD(kScreenWidth - ALD(34)), ALD(40));
    
    timeL.frame = CGRectMake((kScreenWidth - ALD(200))/2,titleL.bottom + ALD(5), ALD(200), ALD(15));

    contentL.frame = CGRectMake(ALD(12), timeL.bottom + ALD(10), kScreenWidth - ALD(24), sizeText.height);

    
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
