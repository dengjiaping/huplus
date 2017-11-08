//
//  WJMyIndividualViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyIndividualViewController.h"
#import "WJOrderTypeCollectionViewCell.h"
#import "WJIndivdualMoreCollectionViewCell.h"
#import "WJIndivdualCollectionViewCell.h"
#import "WJMyCollectionViewController.h"
#import "WJMyOrderController.h"
#import "WJMyVipCardViewController.h"
#import "WJMyCreditsViewController.h"
#import "WJMyCouponViewController.h"
#import "WJPaymentViewController.h"
#import "WJMyDeliveryAddressViewController.h"
#import "WJIndividualInformationController.h"
#import "WJIndividualRefundViewController.h"
#import "WJSettingViewController.h"
#import "WJMessageViewController.h"
#import "WJPasswordSettingController.h"
#import "WJShoppingCartViewController.h"
#import "UINavigationBar+Awesome.h"
#import "AppDelegate.h"
#import "APIIndividualCenterManager.h"
#import "WJIndividualCenterReformer.h"
#import "WJIndividualCenterModel.h"
#import "WJLoginController.h"
#import <UIImageView+WebCache.h>
#import "WJAboutMeViewController.h"

#define kHeaderViewIdentifier               @"kHeaderViewIdentifier"
#define kDefaultCellIdentifier              @"kDefaultCellIdentifier"
#define kOrderTypeCellIdentifier            @"kOrderTypeCellIdentifier"
#define kCollectionViewCellIdentifier       @"kCollectionViewCellIdentifier"
#define kMoreCollectionViewcellIdentifier   @"kMoreCollectionViewcellIdentifier"

#define NavigationBarHight     ALD(64)
#define HeaderViewHeight       ALD(250)

@interface WJMyIndividualViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,WJIndivdualMoreCollectionViewCellDelagate,APIManagerCallBackDelegate>
{
    UILabel         *messagePoint;
    UIImageView     *avatarImageView;
    UILabel         *phoneL;
}
@property(nonatomic,strong)APIIndividualCenterManager *noReadMessageManager;
@property(nonatomic,strong)UICollectionView           *collectionView;
@property(nonatomic,strong)NSArray                    *dataArray;
@property(nonatomic,strong)NSArray                    *orderTypeArray;
@property(nonatomic,strong)WJIndividualCenterModel    *individualCenterModel;

@end

@implementation WJMyIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isHiddenNavLine = YES;
    self.isWhiteNavItem = YES;
    self.ishiddenNav = YES;
    
    [self navigationSetup];
    [self gradientLayerWithView:self.view];

    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIndividualCenter) name:kTabIndividualCenterRefresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"IndividualCenterRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRefreshHead) name:@"loginRefreshHead" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeadPortrait:) name:@"refreshHeadPortrait" object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.noReadMessageManager loadData];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar lt_reset];
}

- (void)navigationSetup
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [settingButton setImage:[UIImage imageNamed:@"setting_icon"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [messageButton setImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    
    messagePoint = [[UILabel alloc] initWithFrame:CGRectMake(ALD(13), -ALD(2), ALD(12), ALD(12))];
    messagePoint.backgroundColor = WJColorWhite;
    messagePoint.layer.cornerRadius = messagePoint.width/2;
    messagePoint.layer.masksToBounds = YES;
    messagePoint.textColor = WJColorMainRed;
    messagePoint.font = WJFont10;
    messagePoint.textAlignment = NSTextAlignmentCenter;
    messagePoint.hidden = YES;
    [messageButton addSubview:messagePoint];
    
}

-(void)refreshIndividualCenter
{
    [self.noReadMessageManager loadData];
}

-(void)refreshView
{
    self.individualCenterModel = nil;
    [self.collectionView reloadData];
}

-(void)loginRefreshHead
{
    [self.collectionView reloadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if([manager isKindOfClass:[APIIndividualCenterManager class]])
    {
        self.individualCenterModel = [manager fetchDataWithReformer:[[WJIndividualCenterReformer alloc] init]];
        if (self.individualCenterModel.noReadMessageCount > 0) {
            messagePoint.hidden = NO;
            messagePoint.text = [NSString stringWithFormat:@"%@",NumberToString(self.individualCenterModel.noReadMessageCount)];
        }
        [self.collectionView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
        
    } else if (section == 1) {
        return self.orderTypeArray.count;
        
    } else {
        return self.dataArray.count;
    }

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 1) {
        
        WJOrderTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kOrderTypeCellIdentifier forIndexPath:indexPath];
        
        NSDictionary * orderDic = [self.orderTypeArray  objectAtIndex:indexPath.row];

        [cell configDataWithIcon:orderDic[@"icon"] orderType:orderDic[@"text"] count:self.individualCenterModel.orderCountArray[indexPath.row]];
        
        return cell;
        
    } else if (section == 2) {
        
        WJIndivdualCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
        
        NSDictionary * dic = [self.dataArray  objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.countL.hidden = NO;
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:self.individualCenterModel.collectionCountArray[0]];

        } else if (indexPath.row == 1) {
            cell.countL.hidden = NO;
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:self.individualCenterModel.collectionCountArray[1]];

        } else {
            
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:@""];

        }
    
        return cell;
        
    }
    
//    else if (section == 3) {
//        
//        WJIndivdualCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
//        
//        NSDictionary * dic = [self.bottomArray  objectAtIndex:indexPath.row];
//        
//        [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"]];
//        return cell;
//    }


    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0) {
            
            UICollectionReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier forIndexPath:indexPath];
//            [self gradientLayerWithView:headerview];
            
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderViewHeight)];
            bgView.image = [UIImage imageNamed:@"my_bg_icon"];
            [headerview addSubview:bgView];
            
            NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation];

            avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerview.width- ALD(80))/2, (headerview.height - ALD(80))/2, ALD(80), ALD(80))];
            avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
            [avatarImageView sd_setImageWithURL:USER_headPortrait placeholderImage:BitmapHeaderImg];
            avatarImageView.layer.cornerRadius = avatarImageView.width/2;
            avatarImageView.clipsToBounds = YES;
            [bgView addSubview:avatarImageView];
            
            phoneL = [[UILabel alloc] initWithFrame:CGRectMake((headerview.width - ALD(100))/2,avatarImageView.bottom + ALD(10) , ALD(100), ALD(20))];
            
            
            if (USER_ID) {
                
                if ([infoDic[@"nick_name"] isEqualToString:@""]) {
                    phoneL.text = USER_TEL;
                } else {
                    phoneL.text = infoDic[@"nick_name"];
                }
                
            } else {
                
                phoneL.text = @"未登录";
            }

            phoneL.textColor = [UIColor whiteColor];
            phoneL.textAlignment = NSTextAlignmentCenter;
            phoneL.font = WJFont12;
            [bgView addSubview:phoneL];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
            [headerview  addGestureRecognizer:tapGesture];
            
            return headerview;
            
        } else if (indexPath.section == 1) {
            
            WJIndivdualMoreCollectionViewCell *moreView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:kMoreCollectionViewcellIdentifier forIndexPath:indexPath];
            moreView.delegate = self;
            return moreView;
            
        }

        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    }

    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 0) {
        return CGSizeMake(0,0);
        
    } else if (section == 1) {
        
        return CGSizeMake(kScreenWidth/4,kScreenWidth/4);

    } else {
        
        return CGSizeMake(kScreenWidth,ALD(44));
    }

    return CGSizeMake(0,0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    } else if (section == 1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);

    } else if (section == 2) {
        return UIEdgeInsetsMake(0, 0, 0, 0);

    }

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
        
    } else if (section == 1) {
        return 0.f;

    } else if (section == 2) {
        return 0.f;

    }

    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
        
    } else if (section == 1) {
        return 0.f;

    } else if (section == 2) {
        return 0.f;

    }
    
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(kScreenWidth, HeaderViewHeight);
        
    } else if (section == 1) {
        
        return CGSizeMake(kScreenWidth, ALD(44));
        
    } else if (section == 2) {
        
        return CGSizeMake(0, 0);

    }

    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger index = indexPath.row;
    
    switch (section) {
        case 1:
        {
            switch (index) {
                case 0:
                {
                    if (USER_ID) {
                        
                        //待付款
                        WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
                        myOrderVC.scrollIndex = 1;
                        [self.navigationController pushViewController:myOrderVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }

                }
                    break;
                    
                case 1:
                {
                    if (USER_ID) {
                        
                        //待发货
                        WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
                        myOrderVC.scrollIndex = 2;
                        [self.navigationController pushViewController:myOrderVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;
                case 2:
                {
                    if (USER_ID) {
                        
                        //待收货
                        WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
                        myOrderVC.scrollIndex = 3;
                        [self.navigationController pushViewController:myOrderVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;

//                case 3:
//                {
//                    //已完成
//                    WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
//                    myOrderVC.scrollIndex = 4;
//                    [self.navigationController pushViewController:myOrderVC animated:YES];
//                    
//                }
//                    break;
                    
                case 3:
                {
                    if (USER_ID) {
                        
                        //退款/售后
                        WJIndividualRefundViewController *individualRefundVC = [[WJIndividualRefundViewController alloc] init];
                        [self.navigationController pushViewController:individualRefundVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:
        {
            switch (index) {
                case 0:
                {
//                    //线下支付
//                    WJPaymentViewController *paymentVC = [[WJPaymentViewController alloc] init];
//                    [self.navigationController pushViewController:paymentVC animated:YES];
                    
                    if (USER_ID) {
                        
                        //我的收藏
                        WJMyCollectionViewController *myCollectionVC = [[WJMyCollectionViewController alloc] init];
                        [self.navigationController pushViewController:myCollectionVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }

                }
                    break;
                    
                case 1:
                {
                    if (USER_ID) {
                        
                        //我的优惠券
                        WJMyCouponViewController *myCouponVC = [[WJMyCouponViewController alloc] init];
                        //                    myCouponVC.showSelectedStatus = NO;
                        myCouponVC.fromVC = fromIndividualController;
                        [self.navigationController pushViewController:myCouponVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;
                    
                case 2:
                {
//                    //我的贵宾卡
//                    WJMyVipCardViewController *myVipCardVC = [[WJMyVipCardViewController alloc] init];
//                    [self.navigationController pushViewController:myVipCardVC animated:YES];
                    
                    if (USER_ID) {
                        
                        //地址管理
                        WJMyDeliveryAddressViewController *myDeliveryAddressVC = [[WJMyDeliveryAddressViewController alloc] init];
                        myDeliveryAddressVC.fromVC = fromIndividualVC;
                        [self.navigationController pushViewController:myDeliveryAddressVC animated:YES];
                        
                    } else {
                        
                        WJLoginController *loginVC = [[WJLoginController alloc]init];
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }

                    break;
                    
                case 3:
                {
//                    //我的积分
//                    WJMyCreditsViewController *myCreditsVC = [[WJMyCreditsViewController alloc] init];
//                    [self.navigationController pushViewController:myCreditsVC animated:YES];
                    
                    //支付密码设置
//                    WJPasswordSettingController *passwordSettingVC = [[WJPasswordSettingController alloc]init];
//                    [self.navigationController pushViewController:passwordSettingVC animated:YES];
                    
                    WJAboutMeViewController *aboutMeVC = [[WJAboutMeViewController alloc] init];
                    [self.navigationController pushViewController:aboutMeVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        
        default:
            break;
    }
}

#pragma mark - Custom Function
- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [WJUtilityMethod colorWithHexColorString:@"#f11c61"];
    UIColor *color2 = [WJUtilityMethod colorWithHexColorString:@"#fb551b"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    
}

#pragma mark - WJIndivdualMoreCollectionViewCellDelagate
- (void)allTypeOrderCollectionViewCellWithClick
{
    if (USER_ID) {
        
        WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
        [self.navigationController pushViewController:myOrderVC animated:YES];
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Action
- (void)settingButtonAction
{
    WJSettingViewController *settingVC = [[WJSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];

}

- (void)messageButtonAction
{
    if (USER_ID) {
        
        WJMessageViewController *messageVC = [[WJMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)tapGesture
{
    if (USER_ID) {
        
        WJIndividualInformationController *individualInformationVC = [[WJIndividualInformationController alloc] init];
        [self.navigationController pushViewController:individualInformationVC animated:YES];
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)refreshHeadPortrait:(NSNotification *)note
{
    avatarImageView.image = [note.userInfo objectForKey:@"head_portrait"];
    phoneL.text = note.userInfo[@"nick_name"] ? : note.userInfo[@"login_name"];
}

#pragma mark - setter属性
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -NavigationBarHight - kStatusBarHeight, kScreenWidth,  kScreenHeight + kNavigationBarHeight + kStatusBarHeight) collectionViewLayout:flowLayout];

        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //默认
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
        
        //header
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier];

         //订单类型cell
        [_collectionView registerClass:[WJOrderTypeCollectionViewCell class] forCellWithReuseIdentifier:kOrderTypeCellIdentifier];
        
        //中间cell
        [_collectionView registerClass:[WJIndivdualCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        
        //全部订单cell
        [_collectionView registerClass:[WJIndivdualMoreCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMoreCollectionViewcellIdentifier];
        
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    if(nil==_dataArray)
    {
//        _dataArray = @[@{@"icon":@"myShopCart",@"text":@"我的购物车"},
//                       @{@"icon":@"offlinePay",@"text":@"线下支付"},
//                       @{@"icon":@"setPassword",@"text":@"支付密码设置"},
//                       @{@"icon":@"myVIPCard",@"text":@"我的贵宾卡"},
//                       @{@"icon":@"myCredits",@"text":@"我的积分"},
//                       @{@"icon":@"myCoupons",@"text":@"我的优惠券"}
//                       ];
        _dataArray = @[@{@"icon":@"myCollection",@"text":@"我的收藏"},
                       @{@"icon":@"myCoupons",@"text":@"我的优惠券"},
                       @{@"icon":@"addressManage",@"text":@"地址管理"},
                       @{@"icon":@"aboutMe",@"text":@"关于我们"}
                       ];
    }
    return _dataArray;
}

- (NSArray *)orderTypeArray
{
    if(nil == _orderTypeArray)
    {
//        _orderTypeArray = @[@{@"icon":@"waitingPay",@"text":@"待付款"},
//                            @{@"icon":@"waitingReceive",@"text":@"待发货"},
//                            @{@"icon":@"waitingReceive",@"text":@"待收货"},
//                            @{@"icon":@"alreadyFinished",@"text":@"已完成"},
//                            @{@"icon":@"refund",@"text":@"退款/售后"}
//                            ];
        
        _orderTypeArray = @[@{@"icon":@"waitingPay",@"text":@"待付款"},
                            @{@"icon":@"waitingdeliver",@"text":@"待发货"},
                            @{@"icon":@"waitingReceive",@"text":@"待收货"},
                            @{@"icon":@"refund",@"text":@"退款/售后"}
                            ];
    }
    return _orderTypeArray;
}

- (APIIndividualCenterManager *)noReadMessageManager
{
    if (nil == _noReadMessageManager) {
        _noReadMessageManager = [[APIIndividualCenterManager alloc] init];
        _noReadMessageManager.delegate = self;
    }
    _noReadMessageManager.userId = USER_ID;
    return _noReadMessageManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
