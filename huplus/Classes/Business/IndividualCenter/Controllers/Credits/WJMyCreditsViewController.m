//
//  WJMyCreditsViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyCreditsViewController.h"
#import "WJRefreshTableView.h"
#import "WJSegmentedView.h"
#import "WJCreditsHeaderView.h"
#import "WJMyAllCreditsViewController.h"
#import "WJIncomeViewController.h"
#import "WJDisburseViewController.h"
#import "WJBaseScrollView.h"
#import "WJChooseCreditsValueView.h"
#import "WJCreditsValueModel.h"
#import "WJExchangeResultViewController.h"
#define kSegmentedViewHeight      ALD(50)
#define kCreditsHeaderViewHeight  ALD(200)

@interface WJMyCreditsViewController ()<UITableViewDelegate, UITableViewDataSource,WJSegmentedViewDelegate,WJCreditsHeaderViewDelegate,WJChooseCreditsValueViewDelegate>
{
    WJBaseScrollView    *baseScrollView;
    
    WJMyAllCreditsViewController *allCreditsVC;
    WJIncomeViewController       *incomeVC;
    WJDisburseViewController     *disburseVC;

}
@property(nonatomic,strong)WJRefreshTableView  *tableView;
@property(nonatomic,strong)WJSegmentedView     *segmentedView;
@property(nonatomic,strong)WJCreditsHeaderView *creditsHeaderView;
@property(nonatomic,strong)NSMutableArray      *creditsValueArray;
@property(nonatomic,strong)WJChooseCreditsValueView *chooseCreditsValueView;


@end

@implementation WJMyCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分";
    self.isHiddenTabBar = YES;
    self.view.backgroundColor = WJColorViewBg;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.creditsHeaderView;
    [self.view addSubview:self.chooseCreditsValueView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHeaderView) name:@"hideInnerTableView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHeaderView) name:@"showInnerTableView" object:nil];
}

-(void)hideHeaderView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.tableView.tableHeaderView = nil;
    }];
}

-(void)showHeaderView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.tableView.tableHeaderView = self.creditsHeaderView;
        [self.tableView reloadData];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return ALD(30);
    return (kScreenHeight- kNavigationBarHeight- kSegmentedViewHeight - kCreditsHeaderViewHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *headerView = self.segmentedView;
        return headerView;
    }
    UIView *headerView = [UIView new];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return kSegmentedViewHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    if (indexPath.section == 0) {
        
        baseScrollView = [[WJBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight- kNavigationBarHeight- kSegmentedViewHeight - kCreditsHeaderViewHeight))];
        baseScrollView.pagingEnabled = YES;
        baseScrollView.bounces = NO;
        baseScrollView.delegate = self;
        baseScrollView.showsHorizontalScrollIndicator = NO;
        baseScrollView.backgroundColor = WJColorNavigationBar;
        [cell.contentView addSubview:baseScrollView];
        
        allCreditsVC = [[WJMyAllCreditsViewController alloc] init];
        allCreditsVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScrollView.height);
        [self addChildViewController:allCreditsVC];
        [allCreditsVC didMoveToParentViewController:self];
        [baseScrollView addSubview:allCreditsVC.view];
        
        incomeVC = [[WJIncomeViewController alloc] init];
        incomeVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScrollView.height);
        [self addChildViewController:incomeVC];
        [incomeVC didMoveToParentViewController:self];
        [baseScrollView addSubview:incomeVC.view];
        
        disburseVC = [[WJDisburseViewController alloc] init];
        disburseVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScrollView.height);
        [self addChildViewController:disburseVC];
        [disburseVC didMoveToParentViewController:self];
        [baseScrollView addSubview:disburseVC.view];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[baseScrollView class]]) {
        NSLog(@"baseScrollView在滚动");
//        self.tableView.scrollEnabled = NO;
        
    }else if ([scrollView isKindOfClass:[UITableView class]]) {
        
        NSLog(@"TableView在滚动");
//        baseScrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[baseScrollView class]]) {
        NSLog(@"baseScrollView滚动结束");
//        self.tableView.scrollEnabled = NO;
        
        CGPoint endpoint = scrollView.contentOffset;
        NSInteger index = round(endpoint.x/kScreenWidth);
        _segmentedView.selectedSegmentIndex = index;
        
        [UIView animateWithDuration:0.3 animations:^{
            baseScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
        }];
        
    }else if ([scrollView isKindOfClass:[UITableView class]]) {
        
        NSLog(@"TableView滚动结束");
        
//        baseScrollView.scrollEnabled = YES;
    }
    
}

#pragma mark - WJSegmentedViewDelegate
-(void)segmentedView:(WJSegmentedView *)segmentedView buttonClick:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        baseScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
    }];
    
    switch (index) {
        case 0:
            
            [allCreditsVC.tableView startHeadRefresh];
            break;
        case 1:
            [incomeVC.tableView startHeadRefresh];

            break;
            
        case 2:
            [disburseVC.tableView startHeadRefresh];

            break;
            
        default:
            break;
    }

}

#pragma mark - WJCreditsHeaderViewDelegate
-(void)creditsExchangeButtonClick
{
    NSLog(@"立即兑换");
    
    WJCreditsValueModel *creditsValueModel1 = [[WJCreditsValueModel alloc] init];
    creditsValueModel1.sellValue = @"10元";
    creditsValueModel1.faceValue = @"9";
    
    WJCreditsValueModel *creditsValueModel2 = [[WJCreditsValueModel alloc] init];
    creditsValueModel2.sellValue = @"20元";
    creditsValueModel2.faceValue = @"19";
    
    WJCreditsValueModel *creditsValueModel3 = [[WJCreditsValueModel alloc] init];
    creditsValueModel3.sellValue = @"30元";
    creditsValueModel3.faceValue = @"29";
    
    WJCreditsValueModel *creditsValueModel4 = [[WJCreditsValueModel alloc] init];
    creditsValueModel4.sellValue = @"40元";
    creditsValueModel4.faceValue = @"39";
    
    WJCreditsValueModel *creditsValueModel5 = [[WJCreditsValueModel alloc] init];
    creditsValueModel5.sellValue = @"50元";
    creditsValueModel5.faceValue = @"49";
    
    WJCreditsValueModel *creditsValueModel6 = [[WJCreditsValueModel alloc] init];
    creditsValueModel6.sellValue = @"60元";
    creditsValueModel6.faceValue = @"59";

    self.creditsValueArray = [NSMutableArray arrayWithObjects:creditsValueModel1,creditsValueModel2,creditsValueModel3,creditsValueModel4,creditsValueModel5,creditsValueModel6 ,nil];
    [self.chooseCreditsValueView refreshWithDictionaryWithListFaceValue:self.creditsValueArray];
    self.chooseCreditsValueView.hidden = NO;

    
}

#pragma mark - WJChooseCreditsValueViewDelegate
-(void)selectModel:(WJCreditsValueModel *)model
{
    self.chooseCreditsValueView.hidden = YES;
    WJExchangeResultViewController *exchangeResultVC = [[WJExchangeResultViewController alloc] init];
    [self.navigationController pushViewController:exchangeResultVC animated:YES];
    
}

#pragma mark - setter/getter

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64  - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}

-(WJSegmentedView *)segmentedView
{
    if (!_segmentedView) {
        _segmentedView = [[WJSegmentedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSegmentedViewHeight) items:@[@"全部",@"收入",@"支出"]];
        _segmentedView.delegate = self;
        
    }
    return _segmentedView;
}

-(WJCreditsHeaderView *)creditsHeaderView
{
    if (!_creditsHeaderView) {
        _creditsHeaderView = [[WJCreditsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCreditsHeaderViewHeight)];
        _creditsHeaderView.delegate = self;
    }
    return _creditsHeaderView;
}
-(WJChooseCreditsValueView *)chooseCreditsValueView
{
    if (!_chooseCreditsValueView) {
        _chooseCreditsValueView = [[WJChooseCreditsValueView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _chooseCreditsValueView.hidden = YES;
        _chooseCreditsValueView.delegate = self;
    }
    return _chooseCreditsValueView;
}

-(NSMutableArray *)creditsListArray
{
    if (!_creditsValueArray) {
//        _creditsValueArray = [NSMutableArray array];
    }
    return _creditsValueArray;
}
@end
