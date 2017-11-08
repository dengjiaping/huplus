//
//  WJWJChooseGoodsColorCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChooseGoodsColorCell.h"
#import "WJAttributeDetailModel.h"
@implementation WJChooseGoodsColorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
    }
    return self;
}


- (void)addButtonNameList:(NSMutableArray *)nameList
{
    self.buttonList = [NSMutableArray array];
    for (int i = 0; i < nameList.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 1, 1);
        
        WJAttributeDetailModel *attributeDetailModel = nameList[i];
        [button setTitle:attributeDetailModel.valueName forState:UIControlStateNormal];
        
        button.tag = 2001 + i;
        button.titleLabel.font = WJFont14;
        [button setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [button setTitleColor:WJColorWhite forState:UIControlStateSelected];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 35/2;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [WJBtnBorderColor CGColor];
        [button sizeToFit];
        button.height = 35;
        button.width += 30;
        [_buttonList addObject:button];
        
    }
    for (UIButton *button in self.buttonList) {
        [self.contentView addSubview:button];
        [self buttonlayout];
        
    }
}


-(void)buttonlayout
{
    CGFloat margin = 10;
    
    // 存放每行的第一个Button
    NSMutableArray *rowFirstButtons = [NSMutableArray array];
    
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    button0.x = margin;
    button0.y = margin;
    [rowFirstButtons addObject:self.buttonList[0]];
    
    // 对其他Button进行设置
    int row = 0;
    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        
        int sumWidth = 0;
        int start = (int)[self.buttonList indexOfObject:rowFirstButtons[row]];
        for (int j = start; j <= i; j++) {
            UIButton *button = self.buttonList[j];
            sumWidth += (button.width + margin);
        }
        sumWidth += 10;
        
        UIButton *lastButton = self.buttonList[i - 1];
        if (sumWidth >= self.width) {
            button.x = margin;
            button.y = lastButton.y + margin + button.height;
            [rowFirstButtons addObject:button];
            row ++;
        } else {
            button.x = sumWidth - margin - button.width;
            button.y = lastButton.y;
        }
    }
    
    UIButton *lastButton = self.buttonList.lastObject;
    self.height = CGRectGetMaxY(lastButton.frame) + 10;
    NSLog(@"height%f,width%f",self.height,self.width);
}


@end
