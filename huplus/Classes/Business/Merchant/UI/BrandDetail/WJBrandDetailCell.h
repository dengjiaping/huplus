//
//  WJBrandDetailCell.h
//  HuPlus
//
//  Created by XT Xiong on 2017/4/1.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBrandDetailModel.h"

@interface WJBrandDetailCell : UICollectionViewCell

@property(nonatomic, strong) UIButton   * bottomButton;
@property(nonatomic, strong) UILabel    * detailLabel;

- (void)configData:(WJBrandDetailModel *)brandDetailModel;

- (void)changeLabelHight;

@end
