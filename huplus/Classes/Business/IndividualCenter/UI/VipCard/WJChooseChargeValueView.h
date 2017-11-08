//
//  WJChooseChargeValueView.h
//  HuPlus
//
//  Created by reborn on 16/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJChargeValueModel;
@protocol WJChooseChargeValueViewDelegate <NSObject>

- (void)selectChargeModel:(WJChargeValueModel *)model;

@end

@interface WJChooseChargeValueView : UIView


@property(nonatomic,strong)id <WJChooseChargeValueViewDelegate> delegate;
- (void)refreshWithDictionaryWithListFaceValue:(NSArray *)cardArray;

@end
