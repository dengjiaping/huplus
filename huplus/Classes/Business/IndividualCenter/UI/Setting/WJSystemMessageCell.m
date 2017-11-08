//
//  WJSystemMessageCell.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSystemMessageCell.h"
#import "WJSystemNewsModel.h"
@interface WJSystemMessageCell ()
{
    UILabel           *timeL;
    UILabel           *titleL;
    UILabel           *contentL;
    UIView            *bgView;
    UIImageView       *rightArrowIV;
}

@end

@implementation WJSystemMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorViewBg2;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),contentL.bottom + ALD(10), ALD(200),  ALD(15))];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = WJFont12;
        timeL.textColor = WJColorLightGray;
        
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = WJColorWhite;
        bgView.layer.cornerRadius = ALD(4);
        bgView.layer.masksToBounds = YES;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.font = WJFont32;
        titleL.textColor =WJColorNavigationBar;

        
        contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.lineBreakMode = NSLineBreakByWordWrapping;
        contentL.numberOfLines = 0;
        contentL.font          = WJFont14;
        contentL.textColor     = WJColorDarkGray;
        
        
        rightArrowIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:bgView];
        [bgView addSubview:titleL];
        [bgView addSubview:contentL];
        [bgView addSubview:rightArrowIV];
        
    }
    return self;
}

- (void)configData:(WJSystemNewsModel *)model{
    
    timeL.text  = [NSString stringWithFormat:@"%@",model.date];
    timeL.frame = CGRectMake((kScreenWidth - ALD(200))/2,ALD(10), ALD(200), ALD(15));
    titleL.text = model.title;
    contentL.text = model.content;
    
    NSDictionary *dic           = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText             = [contentL.text boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:dic context:nil].size;

    
    bgView.frame           = CGRectMake(ALD(12), timeL.bottom + ALD(5), kScreenWidth - ALD(24), sizeText.height + ALD(70));
    titleL.frame           = CGRectMake(ALD(12), ALD(15), ALD(kScreenWidth - ALD(34)), ALD(40));
    contentL.frame         = CGRectMake(ALD(12), titleL.bottom + ALD(10), kScreenWidth - ALD(54), sizeText.height);
    
    UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];

    rightArrowIV.frame     = CGRectMake(bgView.width-image.size.width-ALD(10), (bgView.height - image.size.height)/2, image.size.width, image.size.height);

    rightArrowIV.image = image;

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
