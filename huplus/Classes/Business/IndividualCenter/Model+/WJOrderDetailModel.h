//
//  WJOrderDetailModel.h
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJOrderModel.h"
@interface WJOrderDetailModel : NSObject

@property(nonatomic,strong)NSString     *orderNo;
@property(nonatomic,assign)OrderStatus  orderStatus;
@property(nonatomic,strong)NSString     *receiverName;
@property(nonatomic,strong)NSString     *phoneNumber;
@property(nonatomic,strong)NSString     *address;
@property(nonatomic,assign)NSInteger    countDown;
@property(nonatomic,strong)NSString     *createTime;

@property(nonatomic,strong)NSString     *amount;             //商品金额
@property(nonatomic,strong)NSString     *specialAmount;      //优惠金额
@property(nonatomic,strong)NSString     *freightAmount;      //运费
@property(nonatomic,strong)NSString     *PayAmount;          //实付款

@property(nonatomic,strong)NSMutableArray   *orderStoreListArray;


- (id)initWithDic:(NSDictionary *)dic;

@end
