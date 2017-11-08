//
//  WJMessageDetailViewController.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageDetailViewController.h"
#import "WJSystemNewsModel.h"
#import "WJMessageDetailCell.h"
@interface WJMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)WJRefreshTableView         *tableView;
@property (nonatomic, strong)NSMutableArray             *listArray;

@end

@implementation WJMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.isHiddenTabBar = YES;
    
    [self UISetUp];
    
    WJSystemNewsModel *model1 = [[WJSystemNewsModel alloc] init];
    model1.title = @"新店开业";
    model1.content = @"的快递费是到打发斯蒂芬的发挥发挥的康师傅和凯撒红科技示范户卡死机后付款时就按发货的的房间号就撒手机丢了快疯了烧开后放很多事第三方市委日前如何让人人人人人人人人人";
    model1.date = @"2016-10-26";
    
    WJSystemNewsModel *model2 = [[WJSystemNewsModel alloc] init];
    model2.title = @"送福利咯";
    model2.content = @"的饭卡号发了第三方康师傅流口水了撒谎发大水了发回来佛挡杀佛快圣诞节后付款的首付款电视剧后付款后第三款发货的首付款的首付款后发货快圣诞节付货款是符合反倒是空间看看好看看空间看反倒是开会开会疯狂的首付款好看反倒是考核分客户卡沙拉斯发货啦发生大黄蜂厉害了撒谎发来撒会发顺丰了打色卡号法拉盛分发生的劳拉和啦啦啦啦啦啦啦啦啦发生的考核分老卡了为人好人发的撒啊啊啊啊啊啊啊啊啊啊啊啊戴假发狂欢节发挥空间发挥卡刷饭卡上交电话费卡上发卡号是副科级安徽省的看法的设计费哈萨克减肥哈市";
    model2.date = @"2017-10-26";
    
    _listArray = [NSMutableArray arrayWithObjects:model1, model2, nil];
    
}

- (void)UISetUp{
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArray == nil || self.listArray.count == 0) {
        return 0;
    } else {
        return self.listArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJSystemNewsModel *model = [self.listArray objectAtIndex:indexPath.row];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:dic context:nil].size;
    return sizeText.height + ALD(110);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailCellIdentifier"];
    if (nil == cell) {
        cell = [[WJMessageDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageDetailCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg2;
        
    }
    [cell configData:self.listArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WJColorViewBg2;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(NSMutableArray *)listArray
{
    if (_listArray) {
        //        _listArray = [NSMutableArray array];
    }
    return _listArray;
}



@end
