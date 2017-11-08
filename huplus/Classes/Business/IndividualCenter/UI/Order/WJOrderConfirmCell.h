//
//  WJOrderConfirmCell.h
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJOrderConfirmCell : UITableViewCell

@property(nonatomic,strong)UILabel *contentL;
@property(nonatomic,assign)BOOL isShowRightArrow;

-(void)configDataWithName:(NSString *)name Content:(NSString *)content;

@end
