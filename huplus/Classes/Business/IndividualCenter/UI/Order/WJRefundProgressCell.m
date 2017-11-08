//
//  WJRefundProgressCell.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundProgressCell.h"
#import "WJRefundProgressModel.h"
@interface WJRefundProgressCell ()
{
    UILabel *contentL;
}

@end

@implementation WJRefundProgressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.lineBreakMode = NSLineBreakByWordWrapping;
        contentL.numberOfLines = 0;
        contentL.font          = WJFont14;
        contentL.textColor     = WJColorDarkGray;

        [self.contentView addSubview:contentL];
        
    }
    return self;
}

- (void)configDataWithModel:(WJRefundProgressModel *)model{
    
    NSString *finalContent = [NSString stringWithFormat:@"【标题】%@\n【内容】\n %@",model.title,model.content];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText   = [finalContent boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:dic context:nil].size;
 
    contentL.frame = CGRectMake(ALD(12), ALD(10), kScreenWidth - ALD(24), sizeText.height);
    contentL.text = finalContent;
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
