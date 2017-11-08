//
//  WJEditAddressViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJEditAddressViewController.h"
#import "WJSelectPickerView.h"
#import "APIAddDeliveryAddressManager.h"
#import "APIDeleteDeliveryAddressManager.h"
#define kEditAddressTableViewIdentifier     @"kEditAddressTableViewIdentifier"
#define spaceMargin                         (iPhone6OrThan?(ALD(0)):(ALD(15)))

@interface WJEditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WJSelectPickerViewDelegate>
{
    UITextField *receiverTF;
    UITextField *phoneTF;
    UITextField *regionTF;
    UITextField *detailAddressTF;
    UITextField *setDefaultTF;
    
    UIImageView *selectImageView;
    BOOL        isDefault;
    UIButton    *saveButton;

}
@property(nonatomic,strong)WJSelectPickerView              *selectPickerView;
@property(nonatomic,strong)UITableView                     *mTb;
@property(nonatomic,strong)APIAddDeliveryAddressManager    *addAddressManager; //新增
@property(nonatomic,strong)APIAddDeliveryAddressManager    *editAddressManager;//修改
@property(nonatomic,strong)APIDeleteDeliveryAddressManager *deleteAddressManager;

@property(nonatomic,strong)WJAreaModel                  *selectProvince;
@property(nonatomic,strong)WJAreaModel                  *selectCity;
@property(nonatomic,strong)WJAreaModel                  *selectDistrict;

@property(nonatomic,strong)NSArray                      *listArray;
@property(nonatomic,strong)UIView                       *maskView;

@end

@implementation WJEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHiddenTabBar = YES;
    
    if (self.addressViewType == AddressViewTypeNew) {
        self.title = @"我的收货地址";
        isDefault = NO;

    } else {
        self.title = @"编辑地址";
        isDefault = self.deliveryAddressModel.isDefaultAddress;
    }
    
    self.view.backgroundColor = WJColorViewBg;
    [self.view addSubview:self.mTb];
    
    [self UISetup];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
    
//    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self handletapPressGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UISetup
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(65))];
    footerView.backgroundColor = WJColorViewBg;
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(ALD(20), ALD(15), kScreenWidth - ALD(40), ALD(40));
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [saveButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 4;
    saveButton.layer.masksToBounds = YES;
    saveButton.titleLabel.font = WJFont14;
//    saveButton.enabled = NO;
    [saveButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [saveButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorMainRed] forState:UIControlStateNormal];
    
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
    
    self.mTb.tableFooterView = footerView;
    
    [self navigationSetup];

}

- (void)navigationSetup
{
    if (self.addressViewType == AddressViewTypeEdit) {
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 0, ALD(40), ALD(40));
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        deleteButton.titleLabel.font = WJFont14;
        [deleteButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    }
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIAddDeliveryAddressManager class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyDeliveryAddress" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }  else if ([manager isKindOfClass:[APIDeleteDeliveryAddressManager class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyDeliveryAddress" object:nil];
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}

#pragma mark - UITextFieldTextDidChangeNotification
//- (void)checkInputState:(NSNotification *)notification
//{
//    if (receiverTF.text.length != 0 && phoneTF.text.length != 0 && regionTF.text.length != 0 && detailAddressTF.text.length != 0) {
//        saveButton.enabled = YES;
//        
//    } else {
//        saveButton.enabled = NO;
//    }
//
//}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == regionTF) {
        
        [self handletapPressGesture];
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.selectPickerView];
        return NO;
        
    }
    else if (textField == setDefaultTF) {
        
        [setDefaultTF resignFirstResponder];
        
        if (isDefault) {
            
            isDefault = NO;
            selectImageView.image = [UIImage imageNamed:@"address_nor"];
            setDefaultTF.textColor = WJColorLightGray;
            
        } else {
            
            isDefault = YES;
            selectImageView.image = [UIImage imageNamed:@"address_sel"];
            setDefaultTF.textColor = WJColorNavigationBar;
        }
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == detailAddressTF) {
        [setDefaultTF resignFirstResponder];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(45);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"realCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"realCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = WJFont14;
        cell.backgroundColor = WJColorWhite;
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(110), ALD(45))];
        nameL.textColor = WJColorDardGray6;
        nameL.tag = 2001;
        [cell.contentView addSubview:nameL];
        
        UITextField *contentL = [[UITextField alloc] initWithFrame:CGRectMake(ALD(10), 0, kScreenWidth - ALD(115), ALD(45))];
        contentL.tag = 2002;
        contentL.textColor = WJColorDardGray6;
        contentL.delegate = self;
        [cell.contentView addSubview:contentL];
    }
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2001];
    UITextField *contentTF = (UITextField *)[cell.contentView viewWithTag:2002];
    
    NSDictionary * dic = [NSDictionary dictionary];
    
    NSInteger index = indexPath.row;
    
    if (index == 0) {
        
        contentTF.frame = CGRectMake(ALD(10), 0, kScreenWidth - ALD(10), ALD(45));
        contentTF.keyboardType = UIKeyboardTypeDefault;
        contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        receiverTF = contentTF;
        
        if (self.addressViewType == AddressViewTypeNew) {
            
            dic = [self.listArray objectAtIndex:0];
            contentTF.placeholder = dic[@"value"];
        } else {
            
            contentTF.text = self.deliveryAddressModel.name;
        }
        
    } else if (index == 1) {
        
        contentTF.keyboardType = UIKeyboardTypeNumberPad;
        contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneTF = contentTF;
        
        if (self.addressViewType == AddressViewTypeNew) {
            
            dic = [self.listArray objectAtIndex:1];
            contentTF.placeholder = dic[@"value"];
            
        } else {
            
            contentTF.text = self.deliveryAddressModel.phone;
        }
        
    } else if (index == 2) {
        
        regionTF = contentTF;
        
        contentTF.frame = CGRectMake(kScreenWidth - ALD(31) - ALD(160), 0, ALD(160), ALD(45));
        contentTF.textAlignment = NSTextAlignmentRight;
        
        UIImage *arrowImg = [UIImage imageNamed:@"icon_arrow_right"];
        UIImageView * arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(10) - arrowImg.size.width, (ALD(45) - arrowImg.size.height)/2,arrowImg.size.width, arrowImg.size.height)];
        arrowImageView.image = arrowImg;
        [cell.contentView addSubview:arrowImageView];

        dic = [self.listArray objectAtIndex:2];
        nameL.text = dic[@"key"];
        contentTF.text  = dic[@"value"];
        
        if (self.addressViewType == AddressViewTypeEdit) {
            contentTF.text = [NSString stringWithFormat:@"%@%@%@",self.deliveryAddressModel.provinceName,self.deliveryAddressModel.cityName,self.deliveryAddressModel.districtName];
        }
        

    } else if (index == 3) {
        
        detailAddressTF = contentTF;
        
        dic = [self.listArray objectAtIndex:3];
        contentTF.placeholder = dic[@"value"];
        
        if (self.addressViewType == AddressViewTypeEdit) {
            contentTF.text = self.deliveryAddressModel.detailAddress;
        }
 
    } else {
        
        setDefaultTF = contentTF;
        
        dic = [self.listArray objectAtIndex:4];
        contentTF.text =  dic[@"value"];
        contentTF.textColor = WJColorLightGray;
        
        selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(16),ALD(16), ALD(16))];
        selectImageView.image = [UIImage imageNamed:@"address_nor"];
        [cell.contentView addSubview:selectImageView];

        contentTF.frame = CGRectMake(selectImageView.right + ALD(5), 0, kScreenWidth - ALD(130), ALD(45));
        
        if (self.addressViewType == AddressViewTypeEdit) {
            
            if (isDefault) {
                
                selectImageView.image = [UIImage imageNamed:@"address_sel"];
                setDefaultTF.textColor = WJColorNavigationBar;

                
            } else {
                
                selectImageView.image = [UIImage imageNamed:@"address_nor"];
                setDefaultTF.textColor = WJColorLightGray;
                
            }
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - WJSelectPickerViewDelegate
-(void)selectPickerView:(WJSelectPickerView *)selectPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
}

-(void)selectPickerView:(WJSelectPickerView *)selectPickerView clickConfirmButtonWithProvince:(WJAreaModel *)selectProvince city:(WJAreaModel *)selectCity district:(WJAreaModel *)selectDistrict
{
    [_maskView removeFromSuperview];
    regionTF.text = [NSString stringWithFormat:@"%@%@%@",selectProvince.areaName,selectCity.areaName,selectDistrict.areaName];
    
    self.selectProvince = selectProvince;
    self.selectCity = selectCity;
    self.selectDistrict = selectDistrict;
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}

#pragma mark - Action
-(void)saveButtonAction
{
    if (receiverTF.text == nil || [receiverTF.text isEqualToString:@""]) {
        ALERT(@"请输入姓名");

    } else if (!(phoneTF.text.length == 11)) {
        
        ALERT(@"请输入正确手机号码");

    } else if (regionTF.text == nil || [regionTF.text isEqualToString:@""]) {
        
        ALERT(@"请选择地区");

    } else if (detailAddressTF.text == nil || [detailAddressTF.text isEqualToString:@""]) {
        ALERT(@"请输入详细地址");
 
    } else {
        
        if (self.deliveryAddressModel) {
            
            [self.editAddressManager loadData];
            
        } else {
            
            [self.addAddressManager loadData];
        }
    }
}

-(void)deleteButtonAction
{
    [self.deleteAddressManager loadData];
}

#pragma mark -event
-(void)handletapPressGesture
{
    [receiverTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [regionTF resignFirstResponder];
    [detailAddressTF resignFirstResponder];
    [setDefaultTF resignFirstResponder];

}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

-(WJSelectPickerView *)selectPickerView
{
    if (nil == _selectPickerView) {
        _selectPickerView = [[WJSelectPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _selectPickerView.delegate = self;
        
    }
    return _selectPickerView;
}

-(UIView *)maskView
{
    if (nil == _maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = WJColorBlack;
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        UITapGestureRecognizer *tapGestureAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewgesture:)];
        [_maskView addGestureRecognizer:tapGestureAddress];
        
    }
    return _maskView;
}

-(NSArray *)listArray
{
    if(nil==_listArray)
    {
        _listArray=@[@{@"key":@"",@"value":@"收货人"},
                     @{@"key":@"",@"value":@"联系方式"},
                     @{@"key":@"所在地区",@"value":@""},
                     @{@"key":@"",@"value":@"详细地址"},
                     @{@"key":@"",@"value":@"设为默认地址"}
                    ];
    }
    return _listArray;
}

-(APIAddDeliveryAddressManager *)addAddressManager
{
    if (_addAddressManager == nil) {
        _addAddressManager = [[APIAddDeliveryAddressManager alloc] init];
        _addAddressManager.delegate = self;
    }
    _addAddressManager.userId = USER_ID;
    _addAddressManager.receiveId = @"";
    _addAddressManager.receiveName = receiverTF.text;
    _addAddressManager.phone = phoneTF.text;
    _addAddressManager.provinceId = self.selectProvince.areaNo;
    _addAddressManager.cityId = self.selectCity.areaNo;
    _addAddressManager.districtId = self.selectDistrict.areaNo;
    _addAddressManager.detailAddress = detailAddressTF.text;
    _addAddressManager.isDefault = isDefault;
    _addAddressManager.operationType = 1;
    
    return _addAddressManager;
}

-(APIAddDeliveryAddressManager *)editAddressManager
{
    if (_editAddressManager == nil) {
        _editAddressManager = [[APIAddDeliveryAddressManager alloc] init];
        _editAddressManager.delegate = self;
    }
    _editAddressManager.userId = USER_ID;
    _editAddressManager.receiveId = self.deliveryAddressModel.receivingId;
    _editAddressManager.receiveName = receiverTF.text;
    _editAddressManager.phone = phoneTF.text;
    _editAddressManager.provinceId = self.selectProvince.areaNo?:self.deliveryAddressModel.provinceId;
    _editAddressManager.cityId = self.selectCity.areaNo?:self.deliveryAddressModel.cityId;
    _editAddressManager.districtId = self.selectDistrict.areaNo?:self.deliveryAddressModel.districtId;
    _editAddressManager.detailAddress = detailAddressTF.text;
    _editAddressManager.isDefault = isDefault;
    _editAddressManager.operationType = 2;
    
    return _editAddressManager;
}

-(APIDeleteDeliveryAddressManager *)deleteAddressManager
{
    if (_deleteAddressManager == nil) {
        _deleteAddressManager = [[APIDeleteDeliveryAddressManager alloc] init];
        _deleteAddressManager.delegate = self;
    }
    _deleteAddressManager.userId = USER_ID;
    _deleteAddressManager.receiveId = self.deliveryAddressModel.receivingId;
    return _deleteAddressManager;
}

@end
