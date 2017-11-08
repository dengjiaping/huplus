//
//  WJRefundPickerView.m
//  HuPlus
//
//  Created by reborn on 17/3/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundPickerView.h"
#import "WJLogisticsCompanyModel.h"
@interface WJRefundPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView       *grayView;
    UIButton     *cancelButton;
    UIButton     *confirmButton;
    UIPickerView *mPickerView;
}
@property(nonatomic,strong)WJLogisticsCompanyModel *logisticsCompanyModel;

@end

@implementation WJRefundPickerView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.expressListArray = [NSMutableArray array];
        grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40))];
        grayView.backgroundColor = WJColorViewBg;
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, ALD(60), ALD(40));
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = WJFont15;
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(kScreenWidth - ALD(60), 0, ALD(60), ALD(40));
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = WJFont15;
        [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        mPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, grayView.bottom,kScreenWidth, ALD(200))];
        mPickerView.backgroundColor = [UIColor whiteColor];
        mPickerView.delegate = self;
        mPickerView.dataSource = self;
        mPickerView.showsSelectionIndicator = YES;
        
        [grayView addSubview:cancelButton];
        [grayView addSubview:confirmButton];
        
        [self addSubview:grayView];
        [self addSubview:mPickerView];
        
    }
    return self;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.expressListArray == nil || self.expressListArray.count == 0) {
        return 0;
    } else {
        return self.expressListArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return ALD(44);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.expressListArray == nil || self.expressListArray.count == 0) {
        return @"";
    } else {
        return [self.expressListArray[row] logisticsCompanyName];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadComponent:0];
    
    self.logisticsCompanyModel = self.expressListArray[row];
}

#pragma mark - Action
-(void)cancelButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(refundPickerView:clickCancelButton:)]) {
        [self.delegate refundPickerView:self clickCancelButton:button];
    }
}

-(void)confirmButtonAction
{
    if (self.logisticsCompanyModel == nil) {
        self.logisticsCompanyModel = [self.expressListArray firstObject];
    }
    
    if ([self.delegate respondsToSelector:@selector(refundPickerView:clickConfirmButtonWithLogisticsCompanyModel:)]) {
        [self.delegate refundPickerView:self clickConfirmButtonWithLogisticsCompanyModel:self.logisticsCompanyModel];
    }
}

@end
