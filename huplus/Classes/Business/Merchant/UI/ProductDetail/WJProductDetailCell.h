//
//  WJProductDetailCell.h
//  HuPlus
//
//  Created by XT Xiong on 2017/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJProductDetailCell : UITableViewCell

@property(nonatomic,assign)CGFloat   cellHigh;


- (void)configDataWithModel:(NSArray *)dataArray;

@end
