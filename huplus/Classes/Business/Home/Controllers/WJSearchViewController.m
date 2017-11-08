//
//  WJSearchViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJSearchViewController.h"
#import "WJRefreshTableView.h"
#import "WJSearchHistoryTableCell.h"
#import "WJTagView.h"
#import "APIHotSearchManager.h"
#import "WJHotSearchReformer.h"
#import "WJProductListController.h"
#import "WJSearchHistoryTableCell.h"
#import "WJClearHistoryTableCell.h"

#define kHotkeyCellIdentifier           @"kHotkeyCellIdentifier"
#define kHistoryCellIdentifier          @"kHistoryCellIdentifier"
#define kTitleCellIdentifier            @"kTitleCellIdentifier"
#define kClearCellIdentifier            @"kClearCellIdentifier"
#define kDefaultTableCellIdentifier     @"kTitleCellIdentifier"
#define SearchHistory                   @"SearchHistory"

@interface WJSearchViewController ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,APIManagerCallBackDelegate>

@property(nonatomic,strong)WJRefreshTableView  *tableView;
@property(nonatomic,strong)APIHotSearchManager *hotSearchManager;
@property(nonatomic,strong)UISearchBar         *searchBar;
@property(nonatomic,strong)NSMutableArray      *hotKeyArray;
@property(nonatomic,strong)NSMutableArray      *historyArray;
@property(nonatomic,strong)NSArray             *sectionTitleArray;
@property(nonatomic,strong)WJTagView           *tagView;

@end

@implementation WJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHiddenTabBar = YES;
    [self navigationSetUp];
    [self.view addSubview:self.tableView];
    [self.hotSearchManager loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)navigationSetUp
{
    [self hiddenBackBarButtonItem];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:WJFont14];
    [cancelButton setFrame:CGRectMake(0, 0, ALD(40), ALD(30))];
    [cancelButton addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.navigationItem.titleView = self.searchBar;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIHotSearchManager class]]) {
    
        self.hotKeyArray = [manager fetchDataWithReformer:[[WJHotSearchReformer alloc]init]];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.historyArray.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if(self.hotKeyArray.count > 0){
            
            return 1;
            
        } else {
            
            return 0;
        }
        
    } else {
        
        if (self.historyArray.count > 0) {
            
            return [self.historyArray count] + 1;
            
        } else {
            
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return self.tagView.totalHeight;
        
    } else {
        
        return ALD(44);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(33);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = WJColorViewBg;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(200), ALD(33))];
    titleL.textColor = WJColorDarkGray;
    titleL.font = WJFont14;
    titleL.text = [self.sectionTitleArray objectAtIndex:section];
    titleL.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleL];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kHotkeyCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHotkeyCellIdentifier];
            cell.backgroundColor = WJColorViewBg;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
        if (_tagView) {
            [_tagView removeAllTags];
            [self.tagView configViewWithArray:self.hotKeyArray];
            [cell.contentView addSubview:self.tagView];
        }
        return cell;
        
    } else {
        
        if (indexPath.row < self.historyArray.count) {
            WJSearchHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryCellIdentifier];
            if (!cell) {
                cell = [[WJSearchHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHistoryCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = WJColorWhite;
                if (indexPath.row == 1) {
                    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
                    upLine.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:upLine];
                }
            }
            
            cell.nameLabel.text = self.historyArray[indexPath.row];
            
            return cell;
            
        } else {
            
            WJClearHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCellIdentifier];
            if (!cell) {
                cell = [[WJClearHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = WJColorWhite;
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    if (indexPath.section == 1) {
        if (self.historyArray.count >0) {
        
            if (indexPath.row < self.historyArray.count) {
                [self searchMerchant:[self.historyArray objectAtIndex:indexPath.row]];
                
            } else {
                
                [self.historyArray removeAllObjects];
                
                if (USER_ID) {
                    [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"%@history",USER_ID]];

                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:SearchHistory];
                }
                
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BOOL hasEmp = NO;
    
    if ([searchBar.text length] > 0) {
        for (int i =0; i<[searchBar.text length]; i++) {
            NSString *s = [searchBar.text substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@" "]) {
                hasEmp = YES;
                break;
            }
        }
        //如果有空格
        if (hasEmp) {
            
            NSString *searchStr = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([searchStr length] > 0) {
                [self searchMerchant:searchStr];
                
            } else {
                ALERT(@"搜索内容不能为空");
            }
            
        } else {
            [self searchMerchant:searchBar.text];
        }
        
    } else {
        ALERT(@"搜索内容不能为空");
    }
}

- (void)searchMerchant:(NSString *)text
{
    [MobClick event:@"out_search"];
    
    [self editHistoryList:text];
    [self.searchBar resignFirstResponder];
    
    //跳转列表
    WJProductListController *productListVC = [[WJProductListController alloc]init];
    productListVC.condition = text;
    productListVC.comeFormType = ComeFromTypeSearch;
    [self.navigationController pushViewController:productListVC animated:YES];
}

- (void)editHistoryList:(NSString *)text
{
    NSMutableArray *hisArray = nil;
    if (USER_ID) {
        
        hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@history",USER_ID]];
        
    } else {
        
        hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:SearchHistory]];
    }
    
    if (hisArray.count > 0) {
        
        self.historyArray = [NSMutableArray arrayWithArray:hisArray];
        
        for (int i = 0; i < hisArray.count ; i++) {
            
            if ([[hisArray objectAtIndex:i] isEqualToString:text]) {
                
                [self.historyArray removeObject:[hisArray objectAtIndex:i]];
                
            }
        }
        [self.historyArray insertObject:text atIndex:0];
        
        while ([self.historyArray count] > 10) {
            
            [self.historyArray removeLastObject];
        }
        
    } else {
        
        [self.historyArray addObject:text];
    }
    
    [self saveLocalHistory];
}

- (void)saveLocalHistory
{
    if (USER_ID) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"%@history",USER_ID]];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:SearchHistory]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = ALD(32);
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - Button Action
- (void)backToList
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        self.searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = WJColorMainRed;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.placeholder = @"请输入您要搜索的内容";
        _searchBar.keyboardType =  UIKeyboardTypeDefault;
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}


-(WJTagView *)tagView
{
    if (!_tagView) {
        
        [_tagView removeAllTags];
        _tagView = [[WJTagView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _tagView.lineSpacing = 15;
        _tagView.interitemSpacing = 20;
        _tagView.regularHeight = ALD(31);
        _tagView.preferredMaxLayoutWidth = kScreenWidth;
        _tagView.backgroundColor = WJColorWhite;
        
        __weak typeof(self) weakSelf = self;

        self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
            
            NSLog(@"点击了第%ld个热门搜索",idx);
            __strong typeof(self) strongSelf = weakSelf;
            
            WJProductListController *productListVC = [[WJProductListController alloc]init];
            productListVC.condition = [strongSelf.hotKeyArray[idx] name];
            productListVC.comeFormType = ComeFromTypeSearch;
            [strongSelf.navigationController pushViewController:productListVC animated:NO];
            
        };
    }
    return _tagView;
}

- (NSMutableArray *)hotKeyArray
{
    if (!_hotKeyArray) {
        _hotKeyArray = [NSMutableArray array];
        
    }
    return _hotKeyArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
        
        if (nil == USER_ID) {
            
            [_historyArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:SearchHistory]]];
        } else {
            
            [_historyArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@history",USER_ID]]];
        }
        
    }
    
    return _historyArray;
}

- (NSArray *)sectionTitleArray
{
    return @[@"热门搜索",@"历史搜索"];
}

-(APIHotSearchManager *)hotSearchManager
{
    if (_hotSearchManager == nil) {
        _hotSearchManager = [[APIHotSearchManager alloc] init];
        _hotSearchManager.delegate = self;
    }
    return _hotSearchManager;
}

@end
