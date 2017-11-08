//
//  WJIndivdualMoreCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJIndivdualMoreCollectionViewCell;
@protocol WJIndivdualMoreCollectionViewCellDelagate <NSObject>

- (void)allTypeOrderCollectionViewCellWithClick;

@end

@interface WJIndivdualMoreCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) id<WJIndivdualMoreCollectionViewCellDelagate>delegate;

@end
