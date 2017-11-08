//
//  WJRefreshCollectionView.m
//  WanJiCard
//
//  Created by silinman on 16/8/26.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJRefreshCollectionView.h"
#import "MJRefresh.h"

@implementation WJRefreshCollectionView{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
}

- (void)refreshNow:(BOOL)isRefresh
    refreshViewType:(WJRefreshViewType)type{
    
    isHeaderRefresh = isRefresh;
    isFooterRefresh = NO;
    
    NSArray *idleImages = @[[UIImage imageNamed:@"loading_001"],
                            [UIImage imageNamed:@"loading_002"],
                            [UIImage imageNamed:@"loading_003"],
                            [UIImage imageNamed:@"loading_004"],
                            [UIImage imageNamed:@"loading_005"],
                            [UIImage imageNamed:@"loading_006"],
                            [UIImage imageNamed:@"loading_007"],
                            [UIImage imageNamed:@"loading_008"],
                            [UIImage imageNamed:@"loading_009"],
                            [UIImage imageNamed:@"loading_010"],
                            [UIImage imageNamed:@"loading_011"],
                            [UIImage imageNamed:@"loading_012"],
                            [UIImage imageNamed:@"loading_013"],
                            [UIImage imageNamed:@"loading_014"],
                            [UIImage imageNamed:@"loading_015"],
                            [UIImage imageNamed:@"loading_016"]
                            ];
    
    switch (type) {
        case WJRefreshViewTypeHeader:{
            [self createHeaderWithImages:idleImages];
        }
            break;
            
        case WJRefreshViewTypeFooter:{
            [self createFooterWithImages:idleImages];
        }
            break;
            
        case WJRefreshViewTypeBoth:{
            [self createHeaderWithImages:idleImages];
            [self createFooterWithImages:idleImages];
        }
            break;
            
        default:
            break;
    }
    
    if (isRefresh && (type == WJRefreshViewTypeHeader || type == WJRefreshViewTypeBoth)) {
        [self startHeadRefresh];
    }
}

- (void)createHeaderWithImages:(NSArray *)idleImages{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeaderRefresh)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    // 设置header
    self.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
}

- (void)createFooterWithImages:(NSArray *)idleImages{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterRefresh)];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    self.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [self setView:WJRefreshViewTypeFooter text:@"加载中 ···" status:WJRefreshViewStatusRefreshing];
    footer.hidden = YES;
}


- (void)setRefreshingImages:(NSArray *)images
                  withState:(WJRefreshViewStatus)viewState
                   position:(WJRefreshViewType)position{
    if (position == WJRefreshViewTypeHeader && viewState < 3) {
        
    }else if(position == WJRefreshViewTypeFooter){
        
    }
    
    
    
}

- (void)loadHeaderRefresh{
    if ([self.delegate respondsToSelector:@selector(startHeadRefreshToDo:)]) {
        [self.delegate performSelector:@selector(startHeadRefreshToDo:) withObject:self];
    }else{
        [self.mj_header endRefreshing];
        NSLog(@"未实现下拉刷新事件");
    }
}

- (void)loadFooterRefresh{
    
    if ([self.delegate respondsToSelector:@selector(startFootRefreshToDo:)]) {
        [self.delegate performSelector:@selector(startFootRefreshToDo:) withObject:self];
    }else{
        [self.mj_footer endRefreshing];
        NSLog(@"未实现上拉加载事件");
    }
    
}


- (BOOL)automaticallyRefresh{
    return [(MJRefreshAutoFooter *)self.mj_footer isAutomaticallyRefresh];
}

- (void)setAutomaticallyRefresh:(BOOL)automaticallyRefresh{
    [(MJRefreshAutoFooter *)self.mj_footer setAutomaticallyRefresh:automaticallyRefresh];
}

- (void)hiddenHeader
{
    if (self.mj_header) {
        self.mj_header.hidden = YES;
    }
}

- (void)showHeader
{
    if (self.mj_header) {
        self.mj_header.hidden = NO;
    }
}

- (void)hiddenFooter{
    if (self.mj_footer) {
        self.mj_footer.hidden = YES;
    }
}

- (void)showFooter{
    if (self.mj_footer) {
        self.mj_footer.hidden = NO;
    }
}

- (void)startHeadRefresh{
    [self.mj_header beginRefreshing];
}

- (void)endHeadRefresh{
    [self.mj_header endRefreshing];
}


- (void)startFootRefresh{
    [self.mj_footer beginRefreshing];
}

- (void)endFootFefresh{
    [self.mj_footer endRefreshing];
}

- (void)setView:(WJRefreshViewType)type
           text:(NSString *)text
         status:(WJRefreshViewStatus)status{
    if (type == WJRefreshViewTypeHeader) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
        [header setTitle:text forState:(MJRefreshState)status];
        
    }else if (type == WJRefreshViewTypeFooter){
        
        MJRefreshAutoStateFooter * footer = (MJRefreshAutoStateFooter *)self.mj_footer;
        [footer setTitle:text forState:(MJRefreshState)status];
        footer.stateLabel.textColor = WJColorLightGray;
        footer.stateLabel.font = WJFont12;
        
    }
}

- (void)dealloc{
    NSLog(@"WJRefreshCollectionView dealloc");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
