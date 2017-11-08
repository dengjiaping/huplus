//
//  WJSelectDataPickerView.m
//  HuPlus
//
//  Created by reborn on 17/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSelectDataPickerView.h"

@interface WJSelectDataPickerView ()
{
    UIView       *grayView;
    UIButton     *cancelButton;
    UIButton     *confirmButton;
    UIDatePicker *dataPickerView;
}
@property(nonatomic,strong)NSString *selectBirthDay;
@end

@implementation WJSelectDataPickerView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40))];
        grayView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"aeaeae"];
        
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, ALD(60), ALD(40));
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        cancelButton.titleLabel.font = WJFont15;
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(kScreenWidth - ALD(60), 0, ALD(60), ALD(40));
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        confirmButton.titleLabel.font = WJFont15;
        [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        dataPickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, grayView.bottom,kScreenWidth, ALD(200))];
        dataPickerView.backgroundColor = [UIColor whiteColor];
        dataPickerView.datePickerMode = UIDatePickerModeDate;
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *maxDate = [NSDate date];
        NSDate *minDate = [dateFormater dateFromString:@"1949-10-01"];
        
        dataPickerView.minimumDate = minDate;
        dataPickerView.maximumDate = maxDate;
        
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        dataPickerView.locale=locale;
        [dataPickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        [grayView addSubview:cancelButton];
        [grayView addSubview:confirmButton];
        
        [self addSubview:grayView];
        [self addSubview:dataPickerView];
        
    }
    return self;
}

-(void)dateChanged:(id)sender
{
    dataPickerView= (UIDatePicker*)sender;
    NSDate* date = dataPickerView.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    
    _selectBirthDay = string;
}

#pragma mark - Action
-(void)cancelButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selectDataPickerView:clickCancelButton:)]) {
        [self.delegate selectDataPickerView:self clickCancelButton:button];
    }
}

-(void)confirmButtonAction
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    if (self.selectBirthDay.length == 0) {
        self.selectBirthDay = currentTime;
    }
    if ([self.delegate respondsToSelector:@selector(selectDataPickerView:clickConfirmButtonWithSelectBirthDay:)]) {
        [self.delegate selectDataPickerView:self clickConfirmButtonWithSelectBirthDay:_selectBirthDay];
    }
}

@end
