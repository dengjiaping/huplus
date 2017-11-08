//
//  WJCategoryView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCategoryView.h"
#import "WJCategoryListCell.h"
#import "WJCategoryListSectionCell.h"
#import "WJCategoryListModel.h"
@interface WJCategoryView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation WJCategoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTableView];
        [self addSubview:self.mainCollectionView];
    }
    return self;
}

-(void)changeSelectStatus:(WJCategoryListModel *)model
{
    for (int i = 0; i < self.dataArray.count; i++) {
        WJCategoryListModel *categoryListModel = self.dataArray[i];
        if ([categoryListModel.categoryId isEqualToString:model.categoryId]) {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            
            [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }

}

#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.font = WJFont14;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = WJColorNavigationBar;
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 100, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine1;
        [cell.contentView addSubview:bottomLine];
        UIView *selectedBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        selectedBGView.backgroundColor = WJColorViewBg;
        cell.selectedBackgroundView = selectedBGView;
    }
    WJCategoryListModel *categoryListModel = [[WJCategoryListModel alloc]init];
    categoryListModel = self.dataArray[indexPath.row];
    cell.textLabel.text = categoryListModel.categoryName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    WJCategoryListModel *categoryListModel = [[WJCategoryListModel alloc]init];
    categoryListModel = self.dataArray[indexPath.row];
    
    if (self.categoryFrom == CategoryFromSingle) {
        
        if (indexPath.row == 0) {
            
            //选择全部分类
            self.categoryListSelectBlock(categoryListModel);
            
        }else{
            self.collecDataArray = categoryListModel.childListArray;
            [self.mainCollectionView reloadData];
        }
        
        //改变顶部显示
        NSDictionary *dict = @{@"categoryName":categoryListModel.categoryName};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCategoryButtonRefresh" object:nil userInfo:dict];
        
    } else {
        
        self.collecDataArray = categoryListModel.childListArray;
        [self.mainCollectionView reloadData];
    }
    
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.collecDataArray == nil || self.collecDataArray.count == 0) {
        return 0;
    } else {
        return self.collecDataArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WJCategoryListModel *childListModel = self.collecDataArray[section];
    return childListModel.childListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    for (UIView * v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.size.width, cell.contentView.size.height)];
    titleLabel.font = WJFont14;
    titleLabel.textColor = WJColorDardGray6;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;

    WJCategoryListModel *middleListModel = self.collecDataArray[indexPath.section];
    if (middleListModel.childListArray.count != 0) {
        WJCategoryListModel *childListModel = middleListModel.childListArray[indexPath.row];
        NSLog(@"%@",childListModel.categoryName);
        titleLabel.text = childListModel.categoryName;
    }
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = WJColorViewBg2.CGColor;
    cell.contentView.backgroundColor = WJColorWhite;
    [cell.contentView addSubview:titleLabel];

    return cell;
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    if (kind == UICollectionElementKindSectionHeader) {
        WJCategoryListSectionCell * spaceCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WJCategoryListSectionCell" forIndexPath:indexPath];
        WJCategoryListModel * middleListModel = self.collecDataArray[indexPath.section];
        [spaceCell configDataWithModel:middleListModel];
        return spaceCell;
//    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 110 - 24)/3, 37);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //头部大小
    return CGSizeMake(kScreenWidth, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击分类第%ld个cell",(long)indexPath.row);
    WJCategoryListModel * middleListModel = self.collecDataArray[indexPath.section];
    WJCategoryListModel * childListModel = middleListModel.childListArray[indexPath.row];
    self.categoryListSelectBlock(childListModel);
}

#pragma mark - Setter And Getter
- (UICollectionView *)mainCollectionView
{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsZero;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth - 100, self.frame.size.height) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = WJColorViewBg;
        
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        //上面图片下面文字样式
        [_mainCollectionView registerClass:[WJCategoryListCell class] forCellWithReuseIdentifier:@"categoryCell"];
        
        //二级分割头部
        [_mainCollectionView registerClass:[WJCategoryListSectionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WJCategoryListSectionCell"];
        
        //三级按钮
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];

    }
    return _mainCollectionView;
}


- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = WJColorWhite;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)collecDataArray
{
    if (_collecDataArray == nil) {
        _collecDataArray = [NSMutableArray array];
    }
    return _collecDataArray;
}

@end
