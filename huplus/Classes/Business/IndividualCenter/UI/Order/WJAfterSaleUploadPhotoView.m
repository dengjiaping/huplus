//
//  WJAfterSaleUploadPhotoView.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJAfterSaleUploadPhotoView.h"
#import "WJPhotoViewCollectionViewCell.h"
@interface WJAfterSaleUploadPhotoView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *mCollectionView;
    UILabel         *uploadL;
    
}
@property(nonatomic,strong)NSMutableArray   *uploadArray;

@end

@implementation WJAfterSaleUploadPhotoView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
    

        uploadL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), kScreenWidth - ALD(24), ALD(20))];
        uploadL.text = @"上传照片";
        uploadL.textColor = WJColorNavigationBar;
        uploadL.font = WJFont12;
        [self addSubview:uploadL];
        
        mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, uploadL.bottom + ALD(5), kScreenWidth, ALD(85)) collectionViewLayout:flowLayout];
        mCollectionView.backgroundColor = WJColorWhite;
        mCollectionView.scrollEnabled = NO;
        mCollectionView.delegate = self;
        mCollectionView.dataSource = self;
        [mCollectionView registerClass:[WJPhotoViewCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoViewCellIdentifier"];
        [self addSubview:mCollectionView];
        
        UILabel *tipsL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), mCollectionView.bottom + ALD(10), kScreenWidth - ALD(24), ALD(44))];

        tipsL.text = @"为了帮助我们更好的解决问题，请上传照片。最多五张，每张五不超过5M，支持JPG、BMP、PNG";
        tipsL.textColor = WJColorDardGray9;
        tipsL.numberOfLines = 0;
        tipsL.font = WJFont12;
        
        [self addSubview:tipsL];
    }
    return self;
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.uploadArray.count ? : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJPhotoViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCellIdentifier" forIndexPath:indexPath];

    if (self.uploadArray.count > 0) {
        
        [cell configDataWithImage:self.uploadArray[indexPath.row]];
    }
    
    __weak typeof(self) weakSelf = self;

    cell.deleteBlock = ^ {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSLog(@"删除%ld个图片",indexPath.row);
        
        if (strongSelf.uploadArray.count == 1) {
            
            [strongSelf.uploadArray replaceObjectAtIndex:indexPath.row withObject:@""];

        } else {
            
            [strongSelf.uploadArray removeObjectAtIndex:indexPath.row];
        }

        [mCollectionView reloadData];
        
    };

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - ALD(40))/4,(kScreenWidth - ALD(40))/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, ALD(10), ALD(5), ALD(10));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(clickAddPhotoWithIndex:)]) {
        [self.delegate clickAddPhotoWithIndex:indexPath.row];
    }
}


-(void)refreshViewWithArray:(NSMutableArray *)array
{
    self.uploadArray = array;
    [mCollectionView reloadData];
}

-(NSMutableArray *)uploadArray
{
    if (!_uploadArray) {
        _uploadArray = [NSMutableArray array];
    }
    return _uploadArray;
}

@end
