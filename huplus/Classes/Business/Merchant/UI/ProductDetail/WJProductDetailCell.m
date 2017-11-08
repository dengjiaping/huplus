//
//  WJProductDetailCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailCell.h"
#import "WJProductDescribeModel.h"
@implementation WJProductDetailCell

- (void)configDataWithModel:(NSArray *)dataArray
{
    for (int i = 0; i< dataArray.count; i++) {
        WJProductDescribeModel *productDescribeModel = dataArray[i];
//        NSLog(@"-----contentView.subviews:%@",self.contentView.subviews);
        UILabel * label = [[UILabel alloc]initForAutoLayout];
        UILabel *content = [[UILabel alloc] initForAutoLayout];
//        label.text = dataArray[i];
        label.text = [NSString stringWithFormat:@"%@:  %@",productDescribeModel.name,productDescribeModel.content];
        content.text = [NSString stringWithFormat:@"%@",productDescribeModel.content];

        label.font = WJFont12;
        label.numberOfLines = 0;
        label.textColor = WJColorDardGray6;
        if (i == 0) {
            [self.contentView addSubview:label];
            [self.contentView addConstraint:[label constraintWidth:kScreenWidth - 24]];
            [self.contentView addConstraints:[label constraintsTopInContainer:15]];
            [self.contentView addConstraints:[label constraintsLeftInContainer:12]];
        }else{
            if (i+1 <= dataArray.count) {
                [self.contentView addSubview:label];
                [self.contentView addConstraint:[label constraintWidth:kScreenWidth - 24]];
                [self.contentView addConstraints:[label constraintsTop:13 FromView:self.contentView.subviews[i-1]]];
                [self.contentView addConstraints:[label constraintsLeftInContainer:12]];
            }
        }
    }
}

//- (void)configDataWithModel:(NSArray *)dataArray
//{
//    for (int i = 0; i< dataArray.count; i++) {
//        WJProductDescribeModel *productDescribeModel = dataArray[i];
//        
//        UILabel * label = [[UILabel alloc]initForAutoLayout];
//        UILabel *content = [[UILabel alloc] initForAutoLayout];
//        
//        label.text = [NSString stringWithFormat:@"%@:  ",productDescribeModel.name];
//        content.text = [NSString stringWithFormat:@"%@",productDescribeModel.content];
//        
//        label.font = WJFont12;
//        label.numberOfLines = 0;
//        label.textColor = WJColorDardGray6;
//        
//        content.font = WJFont12;
//        content.numberOfLines = 0;
//        content.textColor = WJColorDardGray6;
//        
//        if (i == 0) {
//            [self.contentView addSubview:label];
//            [self.contentView addConstraint:[label constraintWidth:90]];
//            [self.contentView addConstraints:[label constraintsTopInContainer:15]];
//            [self.contentView addConstraints:[label constraintsLeftInContainer:12]];
//        }else{
//            if (i+1 <= dataArray.count) {
//                [self.contentView addSubview:label];
//                [self.contentView addConstraint:[label constraintWidth:90]];
//                [self.contentView addConstraints:[label constraintsTop:13 FromView:self.contentView.subviews[i-1]]];
//                [self.contentView addConstraints:[label constraintsLeftInContainer:12]];
//            }
//        }
//        
//        if (i == 0) {
//            [self.contentView addSubview:content];
//            [self.contentView addConstraint:[content constraintWidth:kScreenWidth - 124]];
//            [self.contentView addConstraints:[content constraintsTopInContainer:15]];
//            [self.contentView addConstraints:[content constraintsLeftInContainer:112]];
//        }else{
//            if (i+1 <= dataArray.count) {
//                [self.contentView addSubview:content];
//                [self.contentView addConstraint:[content constraintWidth:kScreenWidth - 124]];
//                [self.contentView addConstraints:[content constraintsTop:13 FromView:self.contentView.subviews[i-1]]];
//                [self.contentView addConstraints:[content constraintsLeftInContainer:112]];
//            }
//        }
//        
//    }
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}



@end
