//
//  WJMessageCell.h
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSystemNewsModel.h"
@interface WJMessageCell : UITableViewCell

-(void)configDataWith:(WJSystemNewsModel *)model Icon:(NSString *)icon;

@end
