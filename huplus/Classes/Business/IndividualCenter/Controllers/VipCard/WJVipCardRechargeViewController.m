//
//  WJVipCardRechargeViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJVipCardRechargeViewController.h"
#import "WJChooseChargeValueView.h"
#import "WJChargeValueModel.h"
#import "WJSystemAlertView.h"
@interface WJVipCardRechargeViewController ()<WJChooseChargeValueViewDelegate,UITableViewDelegate,UITableViewDataSource,WJSystemAlertViewDelegate>
{
    UIButton *payRightNowButton;
}
@property(nonatomic,strong)WJChooseChargeValueView *chooseChargeValueView;
@property(nonatomic,strong)NSMutableArray *chooseChargeListArray;
@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSArray        *payArray;
@property(nonatomic,assign)NSInteger      selectPayAwayIndex;

@end

@implementation WJVipCardRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贵宾卡充值";
    self.isHiddenTabBar = YES;
    // Do any additional setup after loading the view.
    
    WJChargeValueModel *chargeValueModel1 = [[WJChargeValueModel alloc] init];
    chargeValueModel1.sellValue = @"10元";
    chargeValueModel1.faceValue = @"9";
    
    WJChargeValueModel *chargeValueModel2 = [[WJChargeValueModel alloc] init];
    chargeValueModel2.sellValue = @"20元";
    chargeValueModel2.faceValue = @"19";
    
    WJChargeValueModel *chargeValueModel3 = [[WJChargeValueModel alloc] init];
    chargeValueModel3.sellValue = @"30元";
    chargeValueModel3.faceValue = @"29";
    
    WJChargeValueModel *chargeValueModel4 = [[WJChargeValueModel alloc] init];
    chargeValueModel4.sellValue = @"40元";
    chargeValueModel4.faceValue = @"39";
    
    WJChargeValueModel *chargeValueModel5 = [[WJChargeValueModel alloc] init];
    chargeValueModel5.sellValue = @"50元";
    chargeValueModel5.faceValue = @"49";
    
    WJChargeValueModel *chargeValueModel6 = [[WJChargeValueModel alloc] init];
    chargeValueModel6.sellValue = @"60元";
    chargeValueModel6.faceValue = @"59";
    
    self.chooseChargeListArray = [NSMutableArray arrayWithObjects:chargeValueModel1,chargeValueModel2,chargeValueModel3,chargeValueModel4,chargeValueModel5,chargeValueModel6 ,nil];
    [self.chooseChargeValueView refreshWithDictionaryWithListFaceValue:self.chooseChargeListArray];
    
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.chooseChargeValueView;
    
    [self UISetup];
}

-(void)UISetup
{
    payRightNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payRightNowButton.frame = CGRectMake(ALD(20), self.tableView.height - ALD(80), kScreenWidth - ALD(40), ALD(40));
    [payRightNowButton setTitle:@"立即支付" forState:UIControlStateNormal];
    payRightNowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [payRightNowButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    payRightNowButton.backgroundColor = WJColorMainRed;
    payRightNowButton.layer.cornerRadius = 4;
    payRightNowButton.layer.masksToBounds = YES;
    payRightNowButton.titleLabel.font = WJFont14;
    
    [payRightNowButton addTarget:self action:@selector(payRightNowButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView addSubview:payRightNowButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.payArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(10);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipCardRechargeIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VipCardRechargeIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(11), ALD(22), ALD(22))];
        logoImageView.tag = 10000 + indexPath.row;
        
        UILabel  *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + ALD(11), ALD(11), ALD(11), ALD(22))];
        nameLabel.textColor = WJColorNavigationBar;
        nameLabel.font = WJFont14;
        nameLabel.tag = 11000 + indexPath.row;
        
        UIImageView *selectIV = [[UIImageView alloc] init];
        [selectIV setFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(7), ALD(15), ALD(13), ALD(13))];
        selectIV.tag = 13000 + indexPath.row;
        
        [cell.contentView addSubview:logoImageView];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:selectIV];

    }
    
    UIImageView * logoIV = (UIImageView *) [cell.contentView viewWithTag:10000 + indexPath.row];
    UILabel     * nameL = (UILabel  *)[cell.contentView viewWithTag:11000 + indexPath.row];
    UIImageView * selIV = (UIImageView *)[cell.contentView viewWithTag:13000 + indexPath.row];
    
    logoIV.image = [UIImage imageNamed:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    nameL.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    [nameL sizeToFit];
    [nameL setFrame:CGRectMake(nameL.x, nameL.y, nameL.width, ALD(22))];
    
    
    if (self.selectPayAwayIndex == indexPath.row) {
        selIV.image = [UIImage imageNamed:@"toggle_button_selected"];
    }else
    {
        selIV.image = [UIImage imageNamed:@"toggle_button_nor"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectPayAwayIndex = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - Action
-(void)payRightNowButtonAction
{
//    WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"提示" message:@"设置贵宾卡支付密码，支付更安全" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去设置" textAlignment:NSTextAlignmentCenter];
//    [alertView showIn];
    
}

#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
     
        NSLog(@"去设置");
        
    }
}

#pragma mark - WJChooseChargeValueViewDelegate
-(void)selectChargeModel:(WJChargeValueModel *)model
{
    
}

#pragma mark - 属性方法
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorColor = WJColorSeparatorLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - setter &getter
-(WJChooseChargeValueView *)chooseChargeValueView
{
    if (!_chooseChargeValueView) {
        _chooseChargeValueView = [[WJChooseChargeValueView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(240))];
        _chooseChargeValueView.backgroundColor = WJColorViewBg;
        _chooseChargeValueView.delegate = self;
        
    }
    return _chooseChargeValueView;
}

-(NSMutableArray *)chooseChargeListArray
{
    if (!_chooseChargeListArray) {
//        _chooseChargeListArray = [NSMutableArray array];
    }
    return _chooseChargeListArray;
}

- (NSArray *)payArray
{
    return @[
             @{@"image":@"pay_alipay",@"text":@"支付宝支付",@"away":@"alipay"},
             @{@"image":@"pay_weixin",@"text":@"微信支付",@"away":@"weixin"}
             ];
}

@end
