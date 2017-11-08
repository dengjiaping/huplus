//
//  WJCategoryListSectionCell.h
//  HuPlus
//
//  Created by XT Xiong on 2017/4/18.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCategoryListModel.h"

@interface WJCategoryListSectionCell : UICollectionViewCell

@property(nonatomic ,strong)UILabel             *titleLabel;

- (void)configDataWithModel:(WJCategoryListModel *)model;

@end
