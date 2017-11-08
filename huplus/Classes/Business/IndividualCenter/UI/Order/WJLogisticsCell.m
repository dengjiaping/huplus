//
//  WJLogisticsCell.m
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsCell.h"
#define DotViewCentX ALD(20)      //圆点中心 x坐标
#define VerticalLineWidth 2       //时间轴 线条 宽度
#define ShowLabTop ALD(20)        //cell间距
#define dotViewRadius  5
#define ShowLabWidth (kScreenWidth - DotViewCentX - ALD(20))

@interface WJLogisticsCell ()
{
    UIView *verticalLineTopView; //上面线条
    UIView *dotView;             //圆点
    UIView *verticalLineBottomView; //下面线条
    UIButton *showLab;              //内容
}
@end

@implementation WJLogisticsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        verticalLineTopView = [[UIView alloc] init];
        verticalLineTopView.backgroundColor = WJColorLightGray;
        
        dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotViewRadius * 2, dotViewRadius * 2)];
        dotView.center = CGPointMake(DotViewCentX, ShowLabTop + ALD(13));
        dotView.backgroundColor = [UIColor orangeColor];
        dotView.layer.cornerRadius = dotViewRadius;
        
        verticalLineBottomView = [[UIView alloc] init];
        verticalLineBottomView.backgroundColor = WJColorLightGray;
        
        showLab = [[UIButton alloc] init];
        showLab.titleLabel.font = WJFont15;
        showLab.titleLabel.numberOfLines = 20;
        [showLab setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
        showLab.titleLabel.textAlignment = NSTextAlignmentLeft;
        showLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        showLab.titleEdgeInsets = UIEdgeInsetsMake(ALD(5), ALD(15), ALD(5), ALD(5));
        
        [self addSubview:verticalLineTopView];
        [self addSubview:dotView];
        [self addSubview:verticalLineBottomView];
        [self addSubview:showLab];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = super.frame;
    dotView.center = CGPointMake(DotViewCentX, ShowLabTop + ALD(13));
    int cutHeight = dotView.frame.size.height/2.0 - 2;
    verticalLineTopView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, 0, VerticalLineWidth, dotView.center.y - cutHeight);
    verticalLineBottomView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, dotView.center.y + cutHeight, VerticalLineWidth, frame.size.height - (dotView.center.y + cutHeight));
}


- (void)setDataSource:(NSString *)content isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    showLab.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0 + ALD(10), ShowLabTop, ShowLabWidth, [WJLogisticsCell cellHeightWithString:content isContentHeight:YES]);
    
    [showLab setTitle:content forState:UIControlStateNormal];
        
    //设置最上面和最下面线条是否隐藏
    verticalLineTopView.hidden = isFirst;
    verticalLineBottomView.hidden = isLast;
    
    //判断是否是第一个圆点（第一个黄色）
    dotView.backgroundColor = isFirst ? [UIColor orangeColor] : WJColorLightGray;
    
    //判断是否是第一条内容（第一个黑色）

    if (isFirst) {
        
        [showLab setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        dotView.frame = CGRectMake(0, 0, dotViewRadius * 4, dotViewRadius * 4);
        dotView.center = CGPointMake(DotViewCentX, ShowLabTop + ALD(13));
        dotView.layer.cornerRadius = dotViewRadius * 2;

    } else {

        [showLab setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
    }

}


//根据字符串的高度设置cell的高度
+ (float)cellHeightWithString:(NSString *)content isContentHeight:(BOOL)b{
    
     CGRect textRect = [content boundingRectWithSize:CGSizeMake(ShowLabWidth - ALD(20), ALD(100)) options:0 attributes:@{NSFontAttributeName:WJFont15} context:nil];
    float height = textRect.size.height;
    
    return (b ? height : (height + ShowLabTop * 2)) + ALD(15);
    
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
