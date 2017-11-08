//
//  WJSelectPickerView.m
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJSelectPickerView.h"
#import "WJDBAreaManager.h"
#import "WJAreaModel.h"

@interface WJSelectPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView       *grayView;
    UIButton     *cancelButton;
    UIButton     *confirmButton;
    UIPickerView *mPickerView;
}
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSMutableArray *districtArray;

@property(nonatomic,strong)WJAreaModel    *selectedProvinceModel; //选定的省
@property(strong,nonatomic)WJAreaModel    *selectedCityModel;     //选定的市
@property(strong,nonatomic)WJAreaModel    *selectedDistrictModel; //选定的区


@property(nonatomic,assign)NSInteger      rowInProvince;
@property(nonatomic,assign)NSInteger      rowInCity;
@property(nonatomic,assign)NSInteger      rowInDistrict;


@end

@implementation WJSelectPickerView

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

        
        mPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, grayView.bottom,kScreenWidth, ALD(200))];
        mPickerView.backgroundColor = [UIColor whiteColor];
        mPickerView.delegate = self;
        mPickerView.dataSource = self;
        mPickerView.showsSelectionIndicator = YES;
        [mPickerView selectRow:0 inComponent:0 animated:YES];
        
        if (self.selectedProvinceModel == nil && self.selectedCityModel == nil && self.selectedDistrictModel == nil) {
            self.selectedProvinceModel = [self.provinceArray objectAtIndex:0];
            
            NSArray *citys = [[WJDBAreaManager new] getSubAreaByParentId:self.selectedProvinceModel.areaNo];
            self.selectedCityModel = [citys objectAtIndex:0];
            
            NSArray *districts = [[WJDBAreaManager new] getSubAreaByParentId:self.selectedCityModel.areaNo];
            self.selectedDistrictModel = [districts objectAtIndex:0];
        }


        [grayView addSubview:cancelButton];
        [grayView addSubview:confirmButton];
        
        [self addSubview:grayView];
        [self addSubview:mPickerView];
        
    }
    return self;
}

#pragma mark - Action
-(void)cancelButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selectPickerView:clickCancelButton:)]) {
        [self.delegate selectPickerView:self clickCancelButton:button];
    }
}

-(void)confirmButtonAction
{
    if ([self.delegate respondsToSelector:@selector(selectPickerView:clickConfirmButtonWithProvince:city:district:)]) {
        [self.delegate selectPickerView:self clickConfirmButtonWithProvince:self.selectedProvinceModel city:self.selectedCityModel district:self.selectedDistrictModel];
    }
}

#pragma mark- pickview delegate &source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (0 == component) {
        
        if (self.provinceArray.count > 0) {
            return [self.provinceArray count];
            
        } else {
            return 0;
        }
        
    } else if (1 == component) {
        
        if (self.cityArray.count > 0) {
            return [self.cityArray count];
        } else {
            return 0;
        }
        
    } else {
        
        if (self.districtArray.count > 0) {
            return [self.districtArray count];
        } else {
            return 0;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (0 == component) {
        
        if (self.provinceArray.count > 0) {
            
            return [[self.provinceArray objectAtIndex:row] areaName];
        }
        
    } else if (1 == component) {
        
        if (self.cityArray.count > 0) {
            
            return [[self.cityArray objectAtIndex:row] areaName];
        }
        
    } else {
        
        if (self.districtArray.count > 0) {
            
            return [[self.districtArray objectAtIndex:row] areaName];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (0 == component) {
        
        if (self.provinceArray.count != 0) {
            
            WJAreaModel *province = self.provinceArray[row];
            self.rowInProvince = row;
            self.rowInCity = 0;
            
            // 最终选择的省
            self.selectedProvinceModel = province;

            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.selectedCityModel = [self.cityArray objectAtIndex:0];
            
        }
        
    } else if (1 == component) {
        
        if (self.cityArray.count != 0) {
            
            WJAreaModel *seletedCity = self.cityArray[row];
            self.rowInCity = row;
            self.rowInDistrict = 0;
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            // 最终选择的市
            self.selectedCityModel = seletedCity;
            
        }
        
    } else {
        
        if (self.districtArray.count != 0) {
         
            WJAreaModel *seletedDistrict = self.districtArray[row];
            self.rowInDistrict = row;
            
            // 最终选择的区
            self.selectedDistrictModel = seletedDistrict;

        }
    }
 
}

#pragma mark - setter&getter
-(NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
        NSMutableArray *allArray = [[WJDBAreaManager new] getAllAreasByLevel:1];
        
        for (WJAreaModel *area in allArray) {
            
            [_provinceArray addObject:area];
        }
    }
    return _provinceArray;
}

-(NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    [_cityArray removeAllObjects];
    WJAreaModel *province = [self.provinceArray objectAtIndex:_rowInProvince];
    NSArray *citys = [[WJDBAreaManager new] getSubAreaByParentId:province.areaNo];
    
    for (WJAreaModel *area in citys) {
        
        [_cityArray addObject:area];
    }
    return _cityArray;
}

-(NSMutableArray *)districtArray
{
    if (!_districtArray) {
        _districtArray = [NSMutableArray array];
    }
    [_districtArray removeAllObjects];
    WJAreaModel *city = [self.cityArray objectAtIndex:_rowInCity];
    NSArray *districts = [[WJDBAreaManager new] getSubAreaByParentId:city.areaNo];
    
    for (WJAreaModel *area in districts) {
        
        [_districtArray addObject:area];
    }
    
    return _districtArray;
}
@end
