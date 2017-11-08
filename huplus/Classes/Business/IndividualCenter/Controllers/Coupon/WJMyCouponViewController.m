//
//  WJMyCouponViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyCouponViewController.h"
#import "WJSegmentedView.h"
#import "WJUnUsedCouponViewController.h"
#import "WJAlreadyUsedCouponViewController.h"
#import "WJExpireCouponViewController.h"
#import "APIExchangeCouponManager.h"

#define kCouponTabSegmentHeight      ALD(50)

@interface WJMyCouponViewController ()<WJSegmentedViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,APIManagerCallBackDelegate>
{
    WJSegmentedView *segmentedView;
    UIScrollView    *baseScrollView;

    WJUnUsedCouponViewController      *unUsedCouponVC;
    WJAlreadyUsedCouponViewController *alreadyUsedCouponVC;
    WJExpireCouponViewController      *expireCouponVC;
    
    NSString *noUseTitle;
    NSString *useTitle;
    NSString *expiredTitle;
    
}

@property(nonatomic,strong)APIExchangeCouponManager         *exchangeCouponManager;

@end

@implementation WJMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的优惠券";
    self.isHiddenTabBar = YES;
    self.view.backgroundColor = WJColorViewBg;

    [self navigationSetup];
    [self createSegmentedView];
    
    baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentedView.bottom, kScreenWidth, (kScreenHeight-64 - kCouponTabSegmentHeight))];
    baseScrollView.pagingEnabled = YES;
    baseScrollView.bounces = NO;
    baseScrollView.scrollsToTop = NO;
    baseScrollView.delegate = self;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:baseScrollView];
    
    unUsedCouponVC = [[WJUnUsedCouponViewController alloc] init];
    unUsedCouponVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScrollView.height);
    unUsedCouponVC.fromVC = self.fromVC;
    __weak typeof(self) weakSelf = self;

    unUsedCouponVC.selectCouponBlock = ^(WJCouponModel *couponModel){
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.selectCouponBlock(couponModel);
    };
    [self addChildViewController:unUsedCouponVC];
    [unUsedCouponVC didMoveToParentViewController:self];
    [baseScrollView addSubview:unUsedCouponVC.view];
    
    alreadyUsedCouponVC = [[WJAlreadyUsedCouponViewController alloc] init];
    alreadyUsedCouponVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScrollView.height);
    [self addChildViewController:alreadyUsedCouponVC];
    [alreadyUsedCouponVC didMoveToParentViewController:self];
    [baseScrollView addSubview:alreadyUsedCouponVC.view];
    
    expireCouponVC = [[WJExpireCouponViewController alloc] init];
    expireCouponVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScrollView.height);
    [self addChildViewController:expireCouponVC];
    [expireCouponVC didMoveToParentViewController:self];
    [baseScrollView addSubview:expireCouponVC.view];
    
    baseScrollView.contentSize = CGSizeMake(3*kScreenWidth, baseScrollView.height);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSegmentView:) name:@"refreshSegmentCount" object:nil];

}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
}

-(void)createSegmentedView
{
    NSInteger    noUseCount = 0;
    NSInteger    useCount = 0;
    NSInteger    expiredCount = 0;
    
    noUseTitle = [NSString stringWithFormat:@"未使用(%ld)",noUseCount];
    useTitle = [NSString stringWithFormat:@"使用记录(%ld)",useCount];
    expiredTitle = [NSString stringWithFormat:@"已过期(%ld)",expiredCount];
    
    segmentedView  = [[WJSegmentedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCouponTabSegmentHeight) items:@[noUseTitle,useTitle,expiredTitle]];
    
    segmentedView.delegate = self;
    [self.view addSubview:segmentedView];
    
}

-(void)refreshSegmentView:(NSNotification *)note
{
    NSInteger noUseCount = [[note.userInfo objectForKey:@"noUseCount"] integerValue];
    NSInteger useCount = [[note.userInfo objectForKey:@"useCount"] integerValue];
    NSInteger expiredCount = [[note.userInfo objectForKey:@"expiredCount"] integerValue];

    noUseTitle = [NSString stringWithFormat:@"未使用(%ld)",noUseCount];
    useTitle = [NSString stringWithFormat:@"使用记录(%ld)",useCount];
    expiredTitle = [NSString stringWithFormat:@"已过期(%ld)",expiredCount];
    
    [segmentedView changeSegmentTitleWithItems:@[noUseTitle,useTitle,expiredTitle]];
}

- (void)navigationSetup
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [addButton setImage:[UIImage imageNamed:@"couponAdd_icon"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJSegmentedViewDelegate
-(void)segmentedView:(WJSegmentedView *)segmentedView buttonClick:(NSInteger)index
{
    NSLog(@"点击第%ld个",(long)index);
    
    [UIView animateWithDuration:0.3 animations:^{
        baseScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
    }];
    
    switch (index) {
        case 0:
            [unUsedCouponVC.tableView startHeadRefresh];
            break;
        case 1:
            [alreadyUsedCouponVC.tableView startHeadRefresh];
            break;
            
        case 2:
            [expireCouponVC.tableView startHeadRefresh];
            break;

        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint endpoint = scrollView.contentOffset;
    NSInteger index = round(endpoint.x/kScreenWidth);
    segmentedView.selectedSegmentIndex = index;
    
    [self segmentedView:segmentedView buttonClick:index];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [alertView resignFirstResponder];
        }
            break;
        case 1:{
            [alertView resignFirstResponder];
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                ALERT(@"请输入优惠码");
            } else {
                //请求接口
                //刷新
                self.exchangeCouponManager.couponCode = @"SDSAD3002";
//                [alertView textFieldAtIndex:0].text;
                [self.exchangeCouponManager loadData];
            }
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Action
-(void)addButtonAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加优惠券" message:@"请输入优惠码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
}


-(APIExchangeCouponManager *)exchangeCouponManager
{
    if (_exchangeCouponManager == nil) {
        _exchangeCouponManager = [[APIExchangeCouponManager alloc]init];
        _exchangeCouponManager.delegate = self;
    }
    _exchangeCouponManager.userId = USER_ID;
    return _exchangeCouponManager;
}


@end
