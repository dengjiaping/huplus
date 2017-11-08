//
//  WJLogisticsCell.h
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJLogisticsCell : UITableViewCell

+ (float)cellHeightWithString:(NSString *)str isContentHeight:(BOOL)b;

//- (void)setDataSource:(NSDictionary *)dic isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

- (void)setDataSource:(NSString *)content isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

@end
