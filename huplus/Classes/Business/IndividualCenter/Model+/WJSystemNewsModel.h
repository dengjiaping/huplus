//
//  WJSystemNewsModel.h
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSystemNewsModel : NSObject
@property(nonatomic,strong)NSString     *messageId;
@property(nonatomic,strong)NSString     *title;
@property(nonatomic,strong)NSString     *content;
@property(nonatomic,strong)NSString     *date;
@property(nonatomic,strong)NSString     *assetData;
@property(nonatomic,strong)NSString     *orderNo;
@property(nonatomic,strong)NSString     *productImgUrl;
@property(nonatomic,assign)NSInteger    messageType;
@property(nonatomic,strong)NSString     *messageContent;
@property(nonatomic,strong)NSString     *goodsName;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
