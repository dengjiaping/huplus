//
//  WJPasswordSettingController.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPasswordSettingController.h"
#import "WJIdentityAuthenticationViewController.h"
@interface WJPasswordSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView     *tableView;
@property(nonatomic,strong)NSArray         *dataArray;

@end

@implementation WJPasswordSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码设置";
    self.isHiddenTabBar = YES;
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ALD(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(100), ALD(44))];
        titleL.font = WJFont13;
        titleL.tag = 3001;
        titleL.textColor = WJColorNavigationBar;
        [cell.contentView addSubview:titleL];
        
        UIImage *arrawImage = [UIImage imageNamed:@"icon_arrow_right"];
        UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - arrawImage.size.width, (ALD(44) - arrawImage.size.height)/2, arrawImage.size.width, arrawImage.size.height)];
        rightArrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        [cell.contentView addSubview:rightArrowImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44) - 1, kScreenWidth - ALD(24), 1)];
        lineView.backgroundColor = WJColorSeparatorLine;
        [cell.contentView addSubview:lineView];
        
    }
    
    if (indexPath.row == 0) {
        
        UIImage *arrawImage = [UIImage imageNamed:@"icon_arrow_right"];
        UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - arrawImage.size.width - ALD(50), 0, ALD(50), ALD(44))];
        statusL.font = WJFont13;
        statusL.text = @"已设置";
        statusL.textColor = WJColorDardGray9;
        [cell.contentView addSubview:statusL];
    }
    
    UILabel *titleL = (UILabel *)[cell.contentView viewWithTag:3001];

    titleL.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJIdentityAuthenticationViewController *identityAuthenticationVC = [[WJIdentityAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:identityAuthenticationVC animated:YES];
}

#pragma mark - setter&getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

-(NSArray *)dataArray
{
    return @[@"设置支付密码",@"重置支付密码"];
}

@end
