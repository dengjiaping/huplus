//
//  WJShopListView.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/18.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectRowAtIndexPathBlock)(NSIndexPath *indexPath);

@interface WJShopListView : UIView

@property(nonatomic,copy)SelectRowAtIndexPathBlock       indexPathBlock;

//-(void)selectRowAtIndexPathBlock:(SelectRowAtIndexPathBlock)indexPathBlock;

@end
