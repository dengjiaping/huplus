//
//  WJChooseGoodsSizeCell.h
//  HuPlus
//
//  Created by XT Xiong on 2017/1/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJChooseGoodsSizeCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray     * buttonList;

- (void)addButtonNameList:(NSMutableArray *)nameList;

@end
