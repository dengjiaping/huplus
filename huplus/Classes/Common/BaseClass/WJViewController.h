//
//  WJViewController.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJLoadingView.h"
#import "WJNoNetWorkView.h"
#import "APIBaseManager.h"

@interface WJViewController : UIViewController<APIManagerCallBackDelegate>

/** 隐藏TabBar */
@property(nonatomic,assign)BOOL         isHiddenTabBar;
/** 隐藏NavLine */
@property(nonatomic,assign)BOOL         isHiddenNavLine;
/** 显示白色item */
@property(nonatomic,assign)BOOL         isWhiteNavItem;
/** 隐藏Navigation */
@property(nonatomic,assign)BOOL         ishiddenNav;
/** 模态起来的页面 */
@property(nonatomic,assign)BOOL         isPresentVC;


@property (nonatomic, strong, readonly) WJNavigationController *navigationController;
@property (nonatomic, strong) WJLoadingView   *loadingView;
@property (nonatomic, strong) WJNoNetWorkView *noNetWorkView;


/** 隐藏导航栏左侧返回按钮 */
- (void)hiddenBackBarButtonItem;

/** 移除侧滑返回手势 */
- (void)removeScreenEdgePanGesture;

/** 显示LoadingView */
- (void)showLoadingView;

/** 隐藏LoadingView */
- (void)hiddenLoadingView;


- (void)backBarButton:(UIButton *)btn;

@end
