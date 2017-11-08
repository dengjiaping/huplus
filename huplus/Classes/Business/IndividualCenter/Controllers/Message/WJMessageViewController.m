//
//  WJMessageViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageViewController.h"
#import "WJSystemMessageViewController.h"
#import "WJMyPropertyViewController.h"
#import "WJMessageCell.h"
#import "WJSystemNewsModel.h"
#import "WJLogisticsViewController.h"
@interface WJMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView     *tableView;
@property(nonatomic,strong)NSArray         *dataArray;
@property(nonatomic,strong)NSArray         *listArray;

@end

@implementation WJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    
    WJSystemNewsModel *model1 = [[WJSystemNewsModel alloc] init];
    model1.title = @"系统通知";
    
    WJSystemNewsModel *model2 = [[WJSystemNewsModel alloc] init];
    model2.title = @"物流通知";

    
    WJSystemNewsModel *model3 = [[WJSystemNewsModel alloc] init];
    model3.title = @"我的资产";
    
    _listArray = [NSMutableArray arrayWithObjects:model1, model2,model3, nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ALD(78);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCellIdentifier"];
    if (!cell) {
        cell = [[WJMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }

    [cell configDataWith:self.listArray[indexPath.row] Icon:[self.dataArray[indexPath.row] objectForKey:@"icon"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        WJSystemMessageViewController *systemMessageVC = [[WJSystemMessageViewController alloc] init];
        [self.navigationController pushViewController:systemMessageVC animated:YES];
        
    } else if (indexPath.row == 1) {
        
        WJLogisticsViewController *logisticsVC = [[WJLogisticsViewController alloc] init];
        [self.navigationController pushViewController:logisticsVC animated:YES];

        
    } else {
        
        WJMyPropertyViewController *myPropertyVC = [[WJMyPropertyViewController alloc] init];
        [self.navigationController pushViewController:myPropertyVC animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter&getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(NSArray *)dataArray
{
    return @[
             @{@"icon":@"systemNews",@"text":@"系统消息"},
             @{@"icon":@"logisticsNews",@"text":@"物流通知"},
             @{@"icon":@"AssetsNews",@"text":@"我的资产"}
             ];
}

-(NSArray *)listArray
{
    if (!_listArray) {
//        _listArray = [NSArray array];
    }
    return _listArray;
}


@end
