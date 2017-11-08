//
//  WJShopDetailTopCell.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJShopDetailTopCell : UICollectionViewCell

@property(nonatomic,strong)UIView         * addressBGView;
@property(nonatomic,strong)UIButton       * telephoneButton;

- (void)configDataWithModel:(NSDictionary *)dic;

@end
