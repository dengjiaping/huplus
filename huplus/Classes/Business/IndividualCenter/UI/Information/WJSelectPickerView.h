//
//  WJSelectPickerView.h
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJAreaModel.h"

@class WJSelectPickerView;
@protocol WJSelectPickerViewDelegate <NSObject>

-(void)selectPickerView:(WJSelectPickerView *)selectPickerView clickCancelButton:(UIButton *)cancelButton;

-(void)selectPickerView:(WJSelectPickerView *)selectPickerView clickConfirmButtonWithProvince:(WJAreaModel *)selectProvince city:(WJAreaModel *)selectCity  district:(WJAreaModel *)selectDistrict;


@end

@interface WJSelectPickerView : UIView
@property(nonatomic,weak)id<WJSelectPickerViewDelegate>delegate;
@end
