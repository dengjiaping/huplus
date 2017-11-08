//
//  WJChooseCreditsValueView.h
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJCreditsValueModel;
@protocol WJChooseCreditsValueViewDelegate <NSObject>

- (void)selectModel:(WJCreditsValueModel *)model;

@end

@interface WJChooseCreditsValueView : UIView
@property (nonatomic, weak)id<WJChooseCreditsValueViewDelegate> delegate;
- (void)refreshWithDictionaryWithListFaceValue:(NSArray *)cardArray;

@end
