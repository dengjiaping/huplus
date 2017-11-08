//
//  WJEnumType.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJEnumType_h
#define WanJiCard_WJEnumType_h

typedef NS_ENUM(NSInteger, PushType) {
    PushTypeSystem = 1,      //系统
    PushTypeProduct,         //商品
    PushTypeShop,            //店铺
    PushTypeActivity,        //H5
    PushTypeLogistics,       //物流
    PushTypeLogout,          //token过期
    PushTypeKickedOut,       //拉黑
    
};


/**
 *  订单类型
 */
typedef enum
{
    OrderTypeAll      = 0,            //全部
    OrderTypeBuyCard  = 1,            //商品卡购卡
    OrderTypeCharge   = 2,            //商品卡充值
    OrderTypeBaoZiCharge = 3,         //包子充值
    OrderTypeElectronicCard = 4,      //电子卡

}OrderType;

/**
 *  电子卡支付类型
 */
typedef NS_ENUM(NSInteger, ElectronicCardPayType){
    
    ElectronicCardPayTypeYiLian = 0,         // 易联
    ElectronicCardPayTypePingAdds = 1,       // ping++
    ElectronicCardPayTypeBaoZi   = 2         // 包子支付
};

typedef enum
{
    DefautType = 40
}PayType;


/**
 支付类型
 */
typedef enum
{
    ChargeTypeConsume = -1,
    ChargeTypeYiBao_ = 5,        //易宝
    ChargeTypePingAdds = 40,     //ping++
    ChargeTypeYiLian = 55        //易联
   
}ChargeType;

/**
 活动提示
 */
typedef NS_ENUM(NSInteger, ActivityStatus){
    
    ActivityPause = 50008056,                     //活动暂停，显示为活动结束
    ActivityEnd = 50008057,                      //活动结束
    ActivityNoQualification = 50008058,          //不满足条件
    ActivityNoStock = 50008059,                  //库存已售尽
    
};

typedef enum
{
    TopicTypeNoAction = 0,
    TopicTypeSomeThingActionj = 5,//要改
    TopicTypeWebViewAction = 10,
}TopicType;

typedef enum
{
    ColorTypeRed = 1,
    ColorTypeOrigne = 2,
    ColorTypeBlueColor = 3,
    ColorTypeGreenColor = 4
}ColorType;


/**************************************V+**********************************/
/**
 *  首页类型
 */
typedef NS_ENUM(NSInteger, HomeType){
    
    CoSeTypeBanner = 0,        //banner
    CoSeTypeShopCategory = 1,  //分类
    CoSeTypeShopBrand = 2,     //品牌
    CoSeTypeShopRecommend = 3, //推荐
};

/**
 *  订单状态   1，待支付；2，待发货；3，待收货；4已完成；9取消；10全部 
 */
typedef NS_ENUM(NSInteger, OrderStatus){
    
    OrderStatusSuccess = 4,        // 已完成
    OrderStatusClose = 9,          // 已关闭订单
    OrderStatusUnfinished = 1,     // 待支付订单
    OrderStatusAll = 10,             // 全部
    OrderStatusWaitReceive = 3,     // 待收货
    OrderStatusWaitDeliver  = 2,     // 待发货

};

typedef NS_ENUM(NSInteger, ProductStatus){
    
    //退货退款
    ProductStatusNormal = 20,             //正常
    ProductStatusWaitSellerConfirm = 21,  //等待商家确认
    ProductStatusWaitBuyerSend = 22,      //等待买家邮寄
    ProductStatusWaitSellerReceive = 23,  //等待商家收货
    ProductStatusWaitSellerRefund = 24,   //等待商家退款
    ProductStatusRefundFinish = 25,       //退款完成
    ProductStatusRefundRefuse = 26,        //拒绝退款
    ProductStatusRefundClose = 27,        //退款关闭

    
    //仅退款
    OnlyRefundStatusNormal = 30,             //正常
    OnlyRefundStatusWaitSellerConfirm = 31,  //等待商家确认
    OnlyRefundStatusRefundFinish = 32,       //已退款
    OnlyRefundStatusRefundRefuse = 33,       //拒绝退款
    OnlyRefundStatusRefundClose = 34,        //退款关闭
    OnlyRefundStatusRefunding = 35,        //退款中


};

typedef NS_ENUM(NSInteger, ServiceType){
    
    serviceByRefundOnly = 0,               // 仅退款
    serviceByReturnProductAndRefund = 1,   // 退货退款
};

/**
 *  优惠券单选框状态
 */
//typedef NS_ENUM(NSInteger, CouponSingleSelectBoxStatus){
//    
//    CouponBoxStatusNo = 0,        // 不显示单选框
//    CouponBoxStatusSelect = 1,    // 单选框为选中状态
//    CouponBoxStatusInactive = 2,  // 单选框为未选中
//};

/**
 *  优惠券使用状态
 */
typedef NS_ENUM(NSInteger, CouponCurrentStatus){
    
    CouponStatusNoUse = 1,          // 未使用
    CouponStatusAlreadyUsed = 2,    // 已使用
    CouponStatusExpired = 3,        // 已过期
};

/**
 *  优惠券类型
 */
typedef NS_ENUM(NSInteger, CouponType){
    
    CouponTypeCommon = 1,         //通用券
    CouponTypeFullReduction = 2,  //满减券
};

/**
 *  第三方店铺商品类型
 */
typedef NS_ENUM(NSInteger, ThirdShopType){
    
    ThirdShopTypeRecommend = 1,  // 推荐商品
    ThirdShopTypeHotSale = 2,    // 热销商品
    ThirdShopTypeAll = 3,        // 全部商品
};

/**
 数据库排序
 */
typedef NS_ENUM(NSInteger, TS_ORDER_E) {
    ORDER_BY_NONE = 0,
    ORDER_BY_DESC,
    ORDER_BY_ASC
} ;



#endif
