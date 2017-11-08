//
//  WJAboutMeViewController.m
//  HuPlus
//
//  Created by reborn on 17/3/3.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJAboutMeViewController.h"
#import "WJWebViewController.h"
#import "APIBaseService.h"
#import "APIServiceFactory.h"
@interface WJAboutMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation WJAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.tableView];
    [self initContentView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initContentView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(220))];
    bgView.backgroundColor = WJColorViewBg2;
    
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(70))/2, (ALD(220) - ALD(70))/2, ALD(70), ALD(70))];
    iconIV.image = [UIImage imageNamed:@"about us_icon"];
    [bgView addSubview:iconIV];
    
    UILabel *versionsL = [[UILabel alloc] initWithFrame:CGRectMake(0, iconIV.bottom + ALD(8), kScreenWidth, ALD(20))];
    versionsL.text = [NSString stringWithFormat:@"版本信息：%@",AppVersion];
    versionsL.font = WJFont13;
    versionsL.textColor = WJColorNavigationBar;
    versionsL.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:versionsL];

    self.tableView.tableHeaderView = bgView;
    
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.height - ALD(76), kScreenWidth, ALD(44))];
    dateL.numberOfLines = 0;
    dateL.textAlignment = NSTextAlignmentCenter;
    dateL.text = @"Copyright©2017-2018\n北京寅盛科技发展有限公司";
    dateL.font = WJFont12;
    dateL.textColor = WJColorDardGray9;
    [self.tableView addSubview:dateL];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutMeCellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutMeCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }

    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),0, ALD(100), ALD(44))];
    nameL.textColor = WJColorNavigationBar;
    nameL.font = WJFont14;
    [cell.contentView addSubview:nameL];
    
    if (indexPath.row == 0) {
        nameL.text = @"产品介绍";
    } else {
        nameL.text = @"用户协议";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    APIBaseService *service = [[APIServiceFactory sharedInstance] serviceWithIdentifier:kAPIServiceWanJiKa];
    NSRange r1 = [service.apiBaseUrl rangeOfString:@"/interface/dateService.do"];
    NSString *resultUrl = [service.apiBaseUrl substringToIndex:r1.location];
    
    if (indexPath.row == 0) {
        
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        [webVC loadWeb:[NSString stringWithFormat:@"%@//h5/aboutUs.html",resultUrl]];

        webVC.titleStr = @"产品介绍";
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else {
        
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        [webVC loadWeb:[NSString stringWithFormat:@"%@//h5/agreement.html",resultUrl]];

        webVC.titleStr = @"用户协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}


#pragma mark - setter/getter
-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg2;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

@end
