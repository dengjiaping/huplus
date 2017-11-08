//
//  WJShopListView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/18.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJShopListView.h"
#import "WJShopListCell.h"

@interface WJShopListView()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
}

@property(nonatomic,strong) WJRefreshTableView                   * mainTableView;
@property(nonatomic,strong) NSMutableArray                       * dataArray;

@end


@implementation WJShopListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTableView];
    }
    return self;
}


#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArray.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(170);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListCell"];
    if (cell == nil) {
        cell = [[WJShopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    [cell configDataWithModel:self.dataArray[indexPath.row]];
    cell.backgroundColor = WJRandomColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathBlock(indexPath);

}


#pragma mark - WJRefreshTableView Delegate
//- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
//{
//    if (!isHeaderRefresh && !isFooterRefresh) {
//        isHeaderRefresh = YES;
////        self.cardExchangeListManager.shouldCleanData = YES;
//        isShowMiddleLoadView = NO;
////        [self.cardExchangeListManager loadData];
//    }
//}
//
//- (void)startFootRefreshToDo:(UITableView *)tableView
//{
//    if (!isFooterRefresh && !isHeaderRefresh) {
//        isFooterRefresh = YES;
//        isShowMiddleLoadView = NO;
////        [self.cardExchangeListManager loadData];
//    }
//}
//
//- (void)endGetData:(BOOL)needReloadData{
//
//    if (isHeaderRefresh) {
//        isHeaderRefresh = NO;
//        [self.mainTableView endHeadRefresh];
//    }
//
//    if (isFooterRefresh){
//        isFooterRefresh = NO;
//        [self.mainTableView endFootFefresh];
//    }
//
//    if (needReloadData) {
//        [self.mainTableView reloadData];
//    }
//}
//
//- (void)refreshFooterStatus:(BOOL)status{
//
//    if (status) {
//        [self.mainTableView hiddenFooter];
//    }else {
//        [self.mainTableView showFooter];
//    }
//
//    if (self.dataArray.count > 0) {
//        self.mainTableView.tableFooterView = [UIView new];
//    }else{
//        self.mainTableView.tableFooterView = nil;
//    }
//}

#pragma mark - Setter And Getter

- (WJRefreshTableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
