//
//  WJCategoryView.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCategoryListModel.h"

typedef enum
{
    CategoryFromAll,        //更多分类
    CategoryFromSingle,     //某个分类
} CategoryFrom;

typedef void (^CategoryListSelectBlock)(WJCategoryListModel *categoryListModel);


@interface WJCategoryView : UIView
@property(nonatomic,assign) CategoryFrom                  categoryFrom;
@property(nonatomic,strong) UITableView                   * mainTableView;
@property(nonatomic,strong) UICollectionView              * mainCollectionView;
@property(nonatomic,strong) NSMutableArray                * dataArray;
@property(nonatomic,strong) NSMutableArray                * collecDataArray;
@property(nonatomic,copy)CategoryListSelectBlock            categoryListSelectBlock;

-(void)changeSelectStatus:(WJCategoryListModel *)model;

@end
