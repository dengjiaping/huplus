//
//  WJPriceListView.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPriceListModel.h"

typedef void (^PriceListSelectBlock)(WJPriceListModel * priceListModel);

@interface WJPriceListView : UIView

@property(nonatomic,strong) UITableView                   * mainTableView;
@property(nonatomic,strong) NSMutableArray                * dataArray;

@property(nonatomic,copy)PriceListSelectBlock               priceListBlock;

@end
