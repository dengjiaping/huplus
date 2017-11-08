//
//  MyPropertyViewListCell.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "MyPropertyViewListCell.h"
#import "WJSystemNewsModel.h"
@interface MyPropertyViewListCell ()
{
    UILabel           *timeL;
    UIView            *bgView;
    UILabel           *titleL;
    UILabel           *orderNoL;
    UILabel           *priceL;

}

@end

@implementation MyPropertyViewListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorViewBg2;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectZero];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = WJFont12;
        timeL.textColor = WJColorLightGray;
        
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = WJColorWhite;
        bgView.layer.cornerRadius = ALD(4);
        bgView.layer.masksToBounds = YES;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.font = WJFont16;
        titleL.textColor =WJColorNavigationBar;
    
        
        orderNoL = [[UILabel alloc] initWithFrame:CGRectZero];
        orderNoL.textColor = WJColorDardGray6;
        orderNoL.font = WJFont13;
        
        
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:bgView];
        [bgView addSubview:titleL];
        [bgView addSubview:orderNoL];

    }
    return self;
}

-(void)configData:(WJSystemNewsModel *)model{
    
    timeL.text  = [NSString stringWithFormat:@"%@",model.assetData];
    titleL.text = model.title;
    NSArray *array = [model.messageContent componentsSeparatedByString:@";"];
    orderNoL.text = [NSString stringWithFormat:@"%@              %@",[array firstObject],[array lastObject]];
    
    timeL.frame = CGRectMake((kScreenWidth - ALD(200))/2,ALD(10), ALD(200), ALD(15));
    bgView.frame = CGRectMake(ALD(12), timeL.bottom + ALD(5), kScreenWidth - ALD(24),(80));
    titleL.frame = CGRectMake(ALD(12), ALD(10), ALD(kScreenWidth - ALD(34)), ALD(20));
    orderNoL.frame = CGRectMake(CGRectGetMinX(titleL.frame), titleL.bottom + ALD(10), kScreenWidth - ALD(48), ALD(20));
    
}
@end
