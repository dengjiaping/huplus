//
//  WJInvoiceSelectCell.h
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJInvoiceSelectCell;
@protocol WJInvoiceSelectCellDelegate <NSObject>

-(void)clickNoInvoiceButton:(WJInvoiceSelectCell *)cell;
-(void)clickMakingInvoiceButton:(WJInvoiceSelectCell *)cell;



@end

@interface WJInvoiceSelectCell : UITableViewCell
@property(nonatomic, strong)UIButton *noInvoiceButton;
@property(nonatomic, strong)UIButton *makingInvoiceButton;

@property(nonatomic, weak)id <WJInvoiceSelectCellDelegate> delegate;
@end
