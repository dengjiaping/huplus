//
//  WJAfterSaleUploadPhotoView.h
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJAfterSaleUploadPhotoViewDelegate <NSObject>

-(void)clickAddPhotoWithIndex:(NSInteger)index;

@end

@interface WJAfterSaleUploadPhotoView : UIView
@property(nonatomic,weak)id<WJAfterSaleUploadPhotoViewDelegate>delegate;

-(void)refreshViewWithArray:(NSMutableArray *)array;


@end
