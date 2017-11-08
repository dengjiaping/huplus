//
//  WJInvoiceViewController.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJInvoiceViewController.h"
#import "WJInvoiceSelectCell.h"
#define kInvoiceSelectCellIdentifier    @"kInvoiceSelectCellIdentifier"
@interface WJInvoiceViewController ()<UITableViewDelegate,UITableViewDataSource,WJInvoiceSelectCellDelegate,UITextFieldDelegate>
{
    BOOL isMakingInvoice;
    UITextField *invoiceTitleTF;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation WJInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票信息";
    self.isHiddenTabBar = YES;
    isMakingInvoice = NO;
    [self.view addSubview:self.tableView];
    [self initBottomView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
    
}

-(void)initBottomView
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(ALD(12), kScreenHeight - ALD(110), kScreenWidth - ALD(24), ALD(40));
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    submitButton.backgroundColor = WJColorMainRed;
    submitButton.layer.cornerRadius = 4;
    submitButton.titleLabel.font = WJFont14;
    [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isMakingInvoice) {
        return 4;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;

    if (section == 0) {
        return ALD(80);
        
    } else if (section == 1) {
        return ALD(44);

    } else if (section == 2) {
        return ALD(44);
        
    } else {
        
        return ALD(95);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        WJInvoiceSelectCell *cell = [[WJInvoiceSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInvoiceSelectCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;

        return cell;
        
    
    } else if (section == 1) {
        
        UILabel *invoiceTypeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth, ALD(44))];
        invoiceTypeL.text = [NSString stringWithFormat:@"发票类型: 普通发票"];
        invoiceTypeL.textColor = WJColorNavigationBar;
        invoiceTypeL.font = WJFont14;
        [cell.contentView addSubview:invoiceTypeL];
        
    }  else if (section == 2) {
        
        UILabel *invoiceContentL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth, ALD(44))];
        invoiceContentL.text = [NSString stringWithFormat:@"发票内容: 明细"];
        invoiceContentL.textColor = WJColorNavigationBar;
        invoiceContentL.font = WJFont14;
        [cell.contentView addSubview:invoiceContentL];
        
    } else {
        
        UILabel *invoiceTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth, ALD(44))];
        invoiceTitleL.text = [NSString stringWithFormat:@"发票抬头"];
        invoiceTitleL.textColor = WJColorNavigationBar;
        invoiceTitleL.font = WJFont14;
        [cell.contentView addSubview:invoiceTitleL];
        
        invoiceTitleTF = [[UITextField alloc] initWithFrame:CGRectMake(ALD(12),invoiceTitleL.bottom, kScreenWidth - ALD(24), ALD(40))];
        if (self.invoiceString) {
            invoiceTitleTF.text = self.invoiceString;
        }
        invoiceTitleTF.placeholder = @"请输入发票抬头";
        invoiceTitleTF.textColor = WJColorNavigationBar;
        invoiceTitleTF.returnKeyType = UIReturnKeyDone;
        invoiceTitleTF.layer.cornerRadius = ALD(3);
        invoiceTitleTF.backgroundColor = WJColorViewBg2;
        invoiceTitleTF.font = WJFont14;
        [cell.contentView addSubview:invoiceTitleTF];

    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
}

#pragma mark - WJInvoiceSelectCellDelegate
-(void)clickNoInvoiceButton:(WJInvoiceSelectCell *)cell
{
    //不开发票
    NSLog(@"不开发票");
    cell.makingInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;
    [cell.makingInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    
    cell.noInvoiceButton.layer.borderColor = WJColorMainRed.CGColor;
    [cell.noInvoiceButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
    


    isMakingInvoice = NO;
    [self.tableView reloadData];
}

-(void)clickMakingInvoiceButton:(WJInvoiceSelectCell *)cell
{
    //开发票
    NSLog(@"开发票");
    
    cell.noInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;
    [cell.noInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    
    
    cell.makingInvoiceButton.layer.borderColor = WJColorMainRed.CGColor;
    [cell.makingInvoiceButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
    
    isMakingInvoice = YES;
    [self.tableView reloadData];
    
}

#pragma mark - Action
-(void)submitButtonAction
{
    
}

-(void)handletapPressGesture
{
    [invoiceTitleTF resignFirstResponder];
}

#pragma mark - setter/getter
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


@end
