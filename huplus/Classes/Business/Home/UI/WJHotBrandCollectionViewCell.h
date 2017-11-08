//
//  WJHotBrandCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBrandModel.h"
@protocol WJHotBrandCollectionViewCellDelegate <NSObject>

- (void)hotBrandCollectionViewCellDelegateSelectWithModel:(WJBrandModel *)hotBrandSelectModel;

@end

@interface WJHotBrandCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UICollectionView                          * hotBrandCollectionView;
@property (nonatomic, strong) NSMutableArray                            * hotBrandArray;
@property (nonatomic, weak)   id<WJHotBrandCollectionViewCellDelegate>    delegate;

- (void)hotBrandCellLoadDataWithArray:(NSMutableArray *)dataArray;

@end
