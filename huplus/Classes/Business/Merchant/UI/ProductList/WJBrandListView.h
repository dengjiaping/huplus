//
//  WJBrandListView.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBrandListModel.h"

typedef void (^BrandListSelectBlock)(WJBrandListModel * brandListModel);

@interface WJBrandListView : UIView

@property(nonatomic,strong) UITableView                          * mainTableView;
@property(nonatomic,strong) NSMutableArray                       * dataArray;

@property(nonatomic,copy)BrandListSelectBlock                 brandListBlock;

@end
