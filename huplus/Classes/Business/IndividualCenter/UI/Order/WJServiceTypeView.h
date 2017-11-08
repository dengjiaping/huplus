//
//  WJServiceTypeView.h
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJServiceTypeViewDelegate <NSObject>

//-(void)maintainButtonClick;
//-(void)returnedProductButtonClick;
//-(void)refundButtonClick;

@end

@interface WJServiceTypeView : UIView
@property(nonatomic,weak)id<WJServiceTypeViewDelegate>delegate;
@property(nonatomic,assign)ServiceType serviceType;
@end
