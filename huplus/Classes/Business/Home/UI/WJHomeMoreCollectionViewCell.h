//
//  WJHomeMoreCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJHomeMoreCollectionViewCell;
@protocol WJHomeMoreCollectionViewCellDelegate <NSObject>

- (void)moreCollectionViewCellWithClickMore:(WJHomeMoreCollectionViewCell *)homeMoreCollectionViewCell section:(NSInteger)section;

@end

@interface WJHomeMoreCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak) id<WJHomeMoreCollectionViewCellDelegate>delegate;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,strong)NSString *title;


@end
