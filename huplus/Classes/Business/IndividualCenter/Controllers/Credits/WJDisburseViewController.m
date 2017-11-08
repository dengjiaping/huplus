//
//  WJDisburseViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJDisburseViewController.h"
#import "WJCreditsCell.h"
#import "WJRefreshTableView.h"
#define kWJCreditsCellIdentifier   @"kWJCreditsCellIdentifier"
@interface WJDisburseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL   isHeaderRefresh;
    BOOL   isFooterRefresh;
}
@property (nonatomic,strong)NSMutableArray     *creditsListArray;
@end

@implementation WJDisburseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.isHiddenTabBar = YES;

    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - refresh

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.tableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.tableView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.tableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.tableView hiddenFooter];
    }else {
        [self.tableView showFooter];
    }
    
    if (self.creditsListArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
    }else{
        self.tableView.tableFooterView = nil;
        self.tableView.showsVerticalScrollIndicator = NO;
        
    }
    
}


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
    //    if (self.creditsListArray == nil || self.creditsListArray.count == 0) {
    //        return 0;
    //    } else {
    //        return self.creditsListArray.count;
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ALD(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJCreditsCell *cell = [tableView dequeueReusableCellWithIdentifier:kWJCreditsCellIdentifier];
    if (!cell) {
        cell = [[WJCreditsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWJCreditsCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    //    [cell configDataWithCreditsModel:self.creditsListArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y < - 50) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showInnerTableView" object:nil];
        
    } else if (scrollView.contentOffset.y > 50) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideInnerTableView" object:nil];
        
    }
    
}


#pragma mark - setter/getter

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64  - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    }
    return _tableView;
}
-(NSMutableArray *)creditsListArray
{
    if (!_creditsListArray) {
        _creditsListArray = [NSMutableArray array];
    }
    return _creditsListArray;
}


@end
