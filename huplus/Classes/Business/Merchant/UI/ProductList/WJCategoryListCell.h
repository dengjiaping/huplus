//
//  WJCategoryListCell.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCategoryListModel.h"

@interface WJCategoryListCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView    * imageView;
@property(nonatomic,strong)UILabel        * titelLabel;

- (void)configDataWithModel:(WJCategoryListModel *)model;

@end
