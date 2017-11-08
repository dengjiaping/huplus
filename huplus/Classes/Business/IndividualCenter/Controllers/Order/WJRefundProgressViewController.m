//
//  WJRefundProgressViewController.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundProgressViewController.h"
#import "WJRefundProgressCell.h"
#import "WJMailMessageViewController.h"
#import "WJSystemAlertView.h"
#import "APIRefundProgressManager.h"
#import "WJRefundProgressReformer.h"
#import "APICancelRefundManager.h"
#define kRefundProgressCellIdentifier @"kRefundProgressCellIdentifier"
@interface WJRefundProgressViewController ()<UITableViewDelegate, UITableViewDataSource,APIManagerCallBackDelegate,WJSystemAlertViewDelegate>
{
    UIView      *bottomView;

}
@property(nonatomic,strong)UITableView                  *tableView;
@property(nonatomic,strong)APIRefundProgressManager     *refundProgressManager;
@property(nonatomic,strong)APICancelRefundManager       *cancelRefundManager;
@property(nonatomic,strong)NSMutableArray               *listArray;
@property(nonatomic,assign)ProductStatus                productStatus;

@end

@implementation WJRefundProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理进度";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.tableView];
    [self initBottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showLoadingView];
    [self.refundProgressManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight - ALD(50), kScreenWidth, ALD(50))];

    self.productStatus = (ProductStatus)self.orderModel.orderStatus;

    if (self.productStatus == ProductStatusWaitBuyerSend  || self.productStatus == ProductStatusWaitSellerConfirm || self.productStatus == OnlyRefundStatusWaitSellerConfirm) {
    

        UIButton *cancelRefundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelRefundButton.frame = CGRectMake(0, 0, ALD(60), ALD(21));
        cancelRefundButton.titleLabel.font = WJFont14;
        [cancelRefundButton setTitle:@"取消退款" forState:UIControlStateNormal];
        [cancelRefundButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [cancelRefundButton addTarget:self action:@selector(cancelRefundButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelRefundButton];
        
    }
    if (self.productStatus == ProductStatusWaitBuyerSend) {
        
        UIButton *waybillNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        waybillNumberButton.frame = CGRectMake(0, 0, bottomView.width, bottomView.height);
        [waybillNumberButton setTitle:@"填写运单号"
                             forState:UIControlStateNormal];
        [waybillNumberButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        waybillNumberButton.backgroundColor = WJColorMainRed;
        waybillNumberButton.titleLabel.font = WJFont15;
        [waybillNumberButton addTarget:self action:@selector(waybillNumberButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:waybillNumberButton];
    }
    
    [self.view addSubview:bottomView];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIRefundProgressManager class]]) {
        
         NSMutableDictionary *dic  = [manager fetchDataWithReformer:[[WJRefundProgressReformer alloc] init]];
        self.listArray = dic[@"order_path_list"];
        [self.tableView reloadData];
        
    } else {
        
        self.productStatus = ProductStatusRefundClose;
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.listArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
        
    } else {
        return ALD(44);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ALD(15);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = nil;
    
    if (!(section == 0)) {
        headerView = [UIView new];
        headerView.backgroundColor = WJColorWhite;
        
        UIImage *buyerImage = [UIImage imageNamed:@"afterSale_buy_icon"];
        UIImage *sellerImage = [UIImage imageNamed:@"afterSale_seller_icon"];
        
        WJRefundProgressModel *refundProgressModel = self.listArray[section - 1];

        UIImageView *merchantIconView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(44) - buyerImage.size.height)/2, buyerImage.size.width, buyerImage.size.height)];
        
        if ([refundProgressModel.name isEqualToString:@"买家"]) {
            merchantIconView.image = buyerImage;

        } else {
            merchantIconView.image = sellerImage;

        }
        [headerView addSubview:merchantIconView];
        
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(merchantIconView.right + ALD(10), (ALD(44) - ALD(20))/2, ALD(150), ALD(20))];
        nameL.textColor = WJColorBlack;
        nameL.font = WJFont12;
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.text = refundProgressModel.name;
        [headerView addSubview:nameL];
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(15) - ALD(150), (ALD(44) - ALD(20))/2, ALD(150), ALD(20))];
        timeL.textColor = WJColorBlack;
        timeL.font = WJFont12;
        timeL.textAlignment = NSTextAlignmentRight;
        timeL.text = refundProgressModel.time;
        [headerView addSubview:timeL];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(43), kScreenWidth, ALD(1))];
        lineView.backgroundColor = WJColorSeparatorLine;
        [headerView addSubview:lineView];
        
        return headerView;
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return ALD(64);
        
    } else {
        
        if (self.listArray.count > 0) {
            
            WJRefundProgressModel *refundProgressModel = self.listArray[indexPath.section - 1];
            
            NSString *finalContent = [NSString stringWithFormat:@"【标题】%@\n 【内容】\n %@",refundProgressModel.title,refundProgressModel.content];
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
            CGSize sizeText = [finalContent boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:dic context:nil].size;
            return sizeText.height + ALD(20);
        }
        
        return 0;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        UILabel *serviceNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(250), ALD(20))];
        serviceNoL.text = [NSString stringWithFormat:@"服务单号：%@",self.orderModel.refundId];
        serviceNoL.textColor = WJColorNavigationBar;
        serviceNoL.font = WJFont12;
        [cell.contentView addSubview:serviceNoL];
        
        UILabel *orderStatusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(80), ALD(10), ALD(80), ALD(20))];
        orderStatusL.textAlignment = NSTextAlignmentRight;
        orderStatusL.textColor = WJColorMainRed;
        orderStatusL.font = WJFont12;
        [cell.contentView addSubview:orderStatusL];
        
        
        UILabel *applyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), serviceNoL.bottom, ALD(200), ALD(20))];
        applyTimeL.textAlignment = NSTextAlignmentLeft;
        applyTimeL.textColor = WJColorLightGray;
        applyTimeL.font = WJFont12;
        applyTimeL.text = [NSString stringWithFormat:@"申请时间：%@",self.orderModel.refundTime];;
        [cell.contentView addSubview:applyTimeL];
        
        switch (self.productStatus) {
                
            case ProductStatusWaitSellerConfirm:
            {
                orderStatusL.text = @"等待商家确认";
            }
                break;
                
            case ProductStatusWaitBuyerSend:
            {
                orderStatusL.text = @"等待买家邮寄";
            }
                break;
                
            case ProductStatusWaitSellerReceive:
            {
                orderStatusL.text = @"等待商家收货";
            }
                break;
                
            case ProductStatusWaitSellerRefund:
            {
                orderStatusL.text = @"等待商家退款";
            }
                break;
                
            case ProductStatusRefundFinish:
            {
                orderStatusL.text = @"退款完成";
            }
                break;
                
            case ProductStatusRefundRefuse:
            {
                orderStatusL.text = @"拒绝退款";
            }
                break;
                
            case ProductStatusRefundClose:
            {
                orderStatusL.text = @"退款关闭";
            }
                break;
                
            case OnlyRefundStatusWaitSellerConfirm:
            {
                orderStatusL.text = @"等待商家退款";
            }
                break;
                
            case OnlyRefundStatusRefundFinish:
            {
                orderStatusL.text = @"退款完成";
            }
                break;
                
            case OnlyRefundStatusRefundRefuse:
            {
                orderStatusL.text = @"拒绝退款";
            }
                break;
                
            case OnlyRefundStatusRefundClose:
            {
                orderStatusL.text = @"退款关闭";
            }
                break;
                
            case OnlyRefundStatusRefunding:
            {
                orderStatusL.text = @"退款中";
            }
                break;
                
            default:
                break;
        }
        
        
    } else {
        
        WJRefundProgressCell *progressCell = [tableView dequeueReusableCellWithIdentifier:kRefundProgressCellIdentifier];
        
        if (!progressCell) {
            
            progressCell = [[WJRefundProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRefundProgressCellIdentifier];
            progressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        WJRefundProgressModel *refundProgressModel = self.listArray[section - 1];
        [progressCell configDataWithModel:refundProgressModel];
        return progressCell;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = ALD(44);
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - WJSystemAlertViewDelegate
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        //取消退款
        [self showLoadingView];
        [self.cancelRefundManager loadData];
    }
}

#pragma mark - Action
-(void)waybillNumberButtonAction
{
    WJMailMessageViewController *mailMessageVC = [[WJMailMessageViewController alloc] init];
    mailMessageVC.orderModel = self.orderModel;
    [self.navigationController pushViewController:mailMessageVC animated:YES];
}

-(void)cancelRefundButtonAction
{
    WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"确认取消此本次退款吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"我再想想" textAlignment:NSTextAlignmentCenter];
    [alertView showIn];
}

#pragma mark - setter& getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - ALD(64)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(APIRefundProgressManager *)refundProgressManager
{
    if (_refundProgressManager == nil) {
        _refundProgressManager = [[APIRefundProgressManager alloc] init];
        _refundProgressManager.delegate = self;
        
    }
    _refundProgressManager.userId = USER_ID;
    _refundProgressManager.refundId = self.orderModel.refundId;
    _refundProgressManager.refundType = [NSString stringWithFormat:@"%ld",(long)self.orderModel.refundType];
    return _refundProgressManager;
}

-(APICancelRefundManager *)cancelRefundManager
{
    if (_cancelRefundManager == nil) {
        _cancelRefundManager = [[APICancelRefundManager alloc] init];
        _cancelRefundManager.delegate = self;
    }
    _cancelRefundManager.userId = USER_ID;
    _cancelRefundManager.refundId = self.orderModel.refundId;
    return _cancelRefundManager;
}

-(NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
