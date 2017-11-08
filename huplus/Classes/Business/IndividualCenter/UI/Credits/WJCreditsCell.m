//
//  WJCreditsCell.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCreditsCell.h"
#import "WJCreditsModel.h"
@interface WJCreditsCell ()
{
    UILabel *creditsL;
    UILabel *createTimeL;
    UILabel *creditsDescribeL;
    UILabel *timeDescribeL;
}

@end

@implementation WJCreditsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        creditsL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(100), ALD(20))];
        creditsL.text = @"-700";
        creditsL.textColor = WJColorNavigationBar;
        creditsL.font = WJFont12;
//        creditsL.backgroundColor = WJRandomColor;
        
        createTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(120), ALD(10), ALD(120), ALD(20))];
        createTimeL.text = @"2016-12-10 12:03:24";
        createTimeL.font = WJFont12;
        createTimeL.textColor = WJColorNavigationBar;
//        createTimeL.backgroundColor = WJRandomColor;

        
        
        creditsDescribeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), creditsL.bottom, ALD(60), ALD(20))];
        creditsDescribeL.textColor = WJColorNavigationBar;
        creditsDescribeL.text = @"获得积分";
        creditsDescribeL.font = WJFont12;
//        creditsDescribeL.backgroundColor = WJRandomColor;

        
        timeDescribeL = [[UILabel alloc] initWithFrame:CGRectMake(createTimeL.frame.origin.x, createTimeL.bottom, ALD(80), ALD(20))];
        timeDescribeL.text = @"兑换积分时间";
        timeDescribeL.textColor = WJColorNavigationBar;
        timeDescribeL.font = WJFont12;
//        timeDescribeL.backgroundColor = WJRandomColor;

        
        [self.contentView addSubview:creditsL];
        [self.contentView addSubview:createTimeL];
        [self.contentView addSubview:creditsDescribeL];
        [self.contentView addSubview:timeDescribeL];
        
    }
    
    return self;
}

-(void)configDataWithCreditsModel:(WJCreditsModel *)model
{
    creditsL.text = model.creditsNum;
    createTimeL.text = model.createTime;
    timeDescribeL.text = model.TimeDes;
    creditsDescribeL.text = model.creditsDes;
    
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
