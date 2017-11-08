//
//  WJBrandListView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJBrandListView.h"

@interface WJBrandListView()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation WJBrandListView

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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrandListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = WJFont14;
        cell.textLabel.textColor = WJColorNavigationBar;
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine1;
        [cell.contentView addSubview:bottomLine];
    }
    WJBrandListModel * brandListModel = [[WJBrandListModel alloc]init];
    brandListModel = self.dataArray[indexPath.row];
    cell.textLabel.text = brandListModel.brandName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    WJBrandListModel * brandListModel = [[WJBrandListModel alloc]init];
    brandListModel = self.dataArray[indexPath.row];
    self.brandListBlock(brandListModel);
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
