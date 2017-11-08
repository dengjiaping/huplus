//
//  WJPriceListView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJPriceListView.h"

@interface WJPriceListView()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation WJPriceListView

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
    
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return 0;
    } else {
        return self.dataArray.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriceListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = WJFont14;
        cell.textLabel.textColor = WJColorNavigationBar;
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine1;
        [cell.contentView addSubview:bottomLine];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"全部价格";
    }else{
        WJPriceListModel * priceListModel = [[WJPriceListModel alloc]init];
        priceListModel = self.dataArray[indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"￥%@-%@",priceListModel.minPrice,priceListModel.maxPrice];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //全部价格
        WJPriceListModel * priceListModel = [[WJPriceListModel alloc]initWithDic:@{@"min_price":@"",
                                                                                   @"max_price":@""}];
        self.priceListBlock(priceListModel);
    }else{
        WJPriceListModel * priceListModel = [[WJPriceListModel alloc]init];
        priceListModel = self.dataArray[indexPath.row - 1];
        self.priceListBlock(priceListModel);
    }
}

#pragma mark - Setter And Getter

- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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



@end
