//
//  WJHotBrandCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJHotBrandCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface WJHotBrandCollectionViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView *brandImageView;
}
@end

@implementation WJHotBrandCollectionViewCell

- (void)hotBrandCellLoadDataWithArray:(NSMutableArray *)dataArray
{
    self.hotBrandArray = dataArray;
    if (self.hotBrandArray == nil || self.hotBrandArray.count == 0) {
        NSLog(@"没有数据");
    }else{
        [self.contentView addSubview:self.hotBrandCollectionView];
    }
}


#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.hotBrandArray == nil || self.hotBrandArray.count == 0) {
        return 0;
    } else {
        return self.hotBrandArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotBrandCollectionViewCell" forIndexPath:indexPath];
    
    brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
    brandImageView.backgroundColor = WJColorWhite;
    brandImageView.layer.cornerRadius = 3;
    brandImageView.layer.masksToBounds = YES;
    brandImageView.layer.borderColor = WJColorViewBg2.CGColor;
    brandImageView.layer.borderWidth = 0.5f;
    WJBrandModel * model = self.hotBrandArray[indexPath.row];
    [brandImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:BitmapBrandImage];
    [cell.contentView addSubview:brandImageView];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 12, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:[NSString stringWithFormat:@"sy_pp%ld",(long)indexPath.row+1]];
    
    NSLog(@"点击分类第%ld个cell",(long)indexPath.row);
    if ([self.delegate respondsToSelector:@selector(hotBrandCollectionViewCellDelegateSelectWithModel:)]) {
        WJBrandModel * model = self.hotBrandArray[indexPath.row];
        [self.delegate hotBrandCollectionViewCellDelegateSelectWithModel:model];
    }
}


-(UICollectionView *)hotBrandCollectionView
{
    if (_hotBrandCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _hotBrandCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) collectionViewLayout:flowLayout];
        _hotBrandCollectionView.backgroundColor = WJColorViewBg;
        _hotBrandCollectionView.delegate = self;
        _hotBrandCollectionView.dataSource = self;
        _hotBrandCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_hotBrandCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"hotBrandCollectionViewCell"];
    }
    return _hotBrandCollectionView;
}

- (NSMutableArray *)hotBrandArray
{
    if (_hotBrandArray == nil) {
        _hotBrandArray = [NSMutableArray array];
    }
    return _hotBrandArray;
}

@end
