//
//  APIRefundListManager.m
//  HuPlus
//
//  Created by reborn on 17/3/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIRefundListManager.h"

@interface APIRefundListManager ()
{
    NSInteger _pageNo;  //  分页:第几页 从1开始 默认1
}

@property (nonatomic, assign, readwrite) NSInteger callBackCount;    //  请求返回的个数
@end

@implementation APIRefundListManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
        self.currentPage = 1;
        self.pageSize = 10;
    }
    return self;
}

#pragma mark - APIManagerVaildator
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{    
    if(data == nil) {
        return NO;
    }
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        self.callBackCount = [data[@"total_page"] integerValue];
    }
    BOOL isCorrect = [data[@"result_code"] integerValue] == 0 && self.callBackCount > 0;
    if (isCorrect) {
        if (self.shouldCleanData) {
            _pageNo = _currentPage;
        }else {
            _pageNo++;
        }
    }
    return isCorrect;
}

/*
 当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 */

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

#pragma mark - APIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{
    NSInteger position = _pageNo;
    if (self.shouldCleanData) {
        position = _currentPage;
    }else {
        position = _pageNo + 1;
    }
    
    return @{@"user_id" :self.userId?:@"",
             @"current_page":NumberToString(position),
             @"page_size":NumberToString(self.pageSize)
             };
}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
    return @"queryRefundOrderList";
}

- (NSString *)serviceType
{
    return kAPIServiceWanJiKa;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

#pragma mark - setter
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    _pageNo = _currentPage;
}

@end
