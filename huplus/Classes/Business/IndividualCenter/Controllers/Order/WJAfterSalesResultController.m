//
//  WJAfterSalesResultController.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJAfterSalesResultController.h"
#import "AppDelegate.h"
#import "WJIndividualRefundViewController.h"
@interface WJAfterSalesResultController ()

@end

@implementation WJAfterSalesResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.serviceType == 0) {
        self.title = @"申请退款";
    } else {
        self.title = @"售后申请";
    }
    self.isHiddenTabBar = YES;
    [self hiddenBackBarButtonItem];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView
{
    UIImage *iconImage = [UIImage imageNamed:@"refundSuccess_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - iconImage.size.width)/2, ALD(65), iconImage.size.width, iconImage.size.height)];
    imageView.image = iconImage;
    [self.view addSubview:imageView];
    
    UILabel *tipL = [[UILabel alloc] init];
    if (self.serviceType == 0) {
        tipL.text = @"您的退款申请已经提交,请耐心等待商家处理审核~";
        
    } else {
        tipL.text = @"您的退货申请已经提交,请等待审核~";
    }
    tipL.font = WJFont15;
    tipL.textColor = WJColorNavigationBar;
    [tipL setTextAlignment:NSTextAlignmentCenter];
    tipL.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize txtSize = [tipL.text sizeWithAttributes:@{NSFontAttributeName:WJFont15} constrainedToSize:CGSizeMake(1000000, 20)];
    tipL.frame = CGRectMake((kScreenWidth - txtSize.width)/2, imageView.bottom + ALD(30), txtSize.width, ALD(20));
    [self.view addSubview:tipL];
    
    UILabel *detailTipsL = [[UILabel alloc] init];
    detailTipsL.hidden = YES;
    if (self.serviceType == 0) {
        detailTipsL.hidden = NO;
        
    } else {
        detailTipsL.hidden = YES;
    }
    
    detailTipsL.textColor = WJColorDardGray9;
    detailTipsL.font = WJFont12;
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:@"退款时间为48小时,商家同意或者超时未处理,系统将退款给您"];
    [textStr setAttributes:@{NSForegroundColorAttributeName: WJColorMainRed} range:NSMakeRange(5, 4)];
    [detailTipsL setAttributedText:textStr];
    [detailTipsL setTextAlignment:NSTextAlignmentCenter];
//    detailTipsL.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize detailTxtSize = [detailTipsL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, 20)];
    detailTipsL.frame = CGRectMake((kScreenWidth - detailTxtSize.width)/2, tipL.bottom + ALD(5), detailTxtSize.width, ALD(20));
    [self.view addSubview:detailTipsL];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight - ALD(50), kScreenWidth, ALD(50))];
    [self.view addSubview:bottomView];
    
    UIButton *checkProgressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkProgressButton.frame = CGRectMake(0, 0, bottomView.width, bottomView.height);
    [checkProgressButton setTitle:@"进度查询"
                         forState:UIControlStateNormal];
    [checkProgressButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    checkProgressButton.backgroundColor = WJColorMainRed;
    checkProgressButton.titleLabel.font = WJFont15;
    [checkProgressButton addTarget:self action:@selector(checkProgressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkProgressButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)checkProgressButtonAction
{
    WJIndividualRefundViewController *individualRefundVC = [[WJIndividualRefundViewController alloc] init];
//    [self.navigationController pushViewController:individualRefundVC animated:YES];
    [self.navigationController pushViewController:individualRefundVC animated:YES whetherJump:YES];

}

@end
