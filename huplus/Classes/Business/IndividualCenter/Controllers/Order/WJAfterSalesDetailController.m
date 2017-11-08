//
//  WJAfterSalesDetailController.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJAfterSalesDetailController.h"
#import "WJAfterSalesCell.h"
#import "WJServiceTypeView.h"
#import "WJAfterSalesResultController.h"
#import "WJAfterSaleUploadPhotoView.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>
#import "SecurityService.h"
#import "APIOrderDetailRefundManager.h"
#import "WJExpressView.h"
#import "WJRefundPickerView.h"
#import "WJLogisticsCompanyModel.h"

#define kAfterSalesDetailCellIdentifier      @"kAfterSalesDetailCellIdentifier"
@interface WJAfterSalesDetailController ()<UITableViewDelegate, UITableViewDataSource,WJServiceTypeViewDelegate,UITextViewDelegate,WJAfterSaleUploadPhotoViewDelegate,WJAfterSaleUploadPhotoViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,APIManagerCallBackDelegate,WJExpressViewDelegate,WJRefundPickerViewDelegate>
{
    WJAfterSaleUploadPhotoView *afterSaleUploadPhotoView;

    NSInteger                  currentTapButtonIndex;
    UITextView                 *questionTextView;
}
@property(nonatomic,strong)APIOrderDetailRefundManager  *refundManager;  //退货
@property(nonatomic,strong)UITableView                  *tableView;
@property(nonatomic,strong)NSMutableArray               *photoListArray; //上传图片数组
@property(nonatomic,strong)NSMutableArray               *photoViewArray;
@property(nonatomic,strong)MBProgressHUD                *hud;
@property(nonatomic,strong)WJExpressView                *refundExpressView;
@property(nonatomic,strong)WJExpressView                *amountExpressView;
@property(nonatomic,strong)WJRefundPickerView           *refundPickerView;

@property(nonatomic,strong)UIView                       *maskView;

@end

@implementation WJAfterSalesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后申请";
    self.isHiddenTabBar = YES;

    currentTapButtonIndex = 0;
    [self.view addSubview:self.tableView];
    [self initBottomView];
}

-(void)initBottomView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(65))];
    footerView.backgroundColor = WJColorViewBg;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(ALD(20), ALD(10), kScreenWidth - ALD(40), ALD(40));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    nextButton.backgroundColor = WJColorMainRed;
    nextButton.layer.cornerRadius = 4;
    nextButton.layer.borderColor = WJColorMainRed.CGColor;
    nextButton.layer.borderWidth = 0.5;
    nextButton.titleLabel.font = WJFont14;
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIOrderDetailRefundManager class]]) {
        
        WJAfterSalesResultController *afterSalesResultVC = [[WJAfterSalesResultController alloc] init];
        afterSalesResultVC.serviceType = 1;
        [self.navigationController pushViewController:afterSalesResultVC animated:YES whetherJump:YES];
        
    }

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section>0?ALD(15):0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return ALD(150);
    } else if (section == 1) {
        return ALD(80);
    } else if (section == 2) {
        return ALD(80);
    } else if (section == 3) {
        return ALD(80);
    } else if (section == 4) {
        return ALD(175);
    } else {
        return ALD(188);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        WJAfterSalesCell *afterSalesCell = [[WJAfterSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAfterSalesDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell  = afterSalesCell;
        
        [afterSalesCell configDataWithModel:self.productModel isDetail:YES];
    
        
    } else if (section == 1) {
        
        WJServiceTypeView *serviceTypeView = [[WJServiceTypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(90))];
        serviceTypeView.serviceType = 1;
        serviceTypeView.delegate = self;
        [cell.contentView addSubview:serviceTypeView];
   
        
    } else if (section == 2) {
        
        _refundExpressView = [[WJExpressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(80))];
        _refundExpressView.delegate = self;
        [_refundExpressView configDataWithTitle:@"退款原因" placeholder:@"请选择退货原因" isShowArrowIV:YES];
        [cell.contentView addSubview:_refundExpressView];
        
        
    } else if (section == 3) {
        
        _amountExpressView = [[WJExpressView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, ALD(80))];
        _amountExpressView.delegate = self;
        [_amountExpressView configDataWithTitle:@"退款金额" placeholder:nil isShowArrowIV:NO];
        
        NSString *amount = [NSString stringWithFormat:@"%.2f",[self.productModel.refundPrice floatValue]];
        NSString *refundAmountStr =  [NSString stringWithFormat:@"¥%@(最多可退商品原价¥%@)",amount,amount];

        _amountExpressView.expressTF.attributedText = [self attributedText:refundAmountStr firstLength:amount.length + 1];
        _amountExpressView.expressTF.enabled = NO;
        [cell.contentView addSubview:_amountExpressView];
        
        
    } else if (section == 4) {

        UILabel *questionL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), kScreenWidth, ALD(20))];
        questionL.textColor = WJColorNavigationBar;
        questionL.font = WJFont13;
        questionL.text = @"问题描述";
        [cell.contentView addSubview:questionL];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), questionL.bottom + ALD(5), kScreenWidth - ALD(24), 0.5)];
        lineView.backgroundColor = WJColorSeparatorLine;
        [cell.contentView addSubview:lineView];
        
        questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(ALD(12), lineView.bottom, kScreenWidth - ALD(24), ALD(115))];
        questionTextView.scrollEnabled = NO;
        questionTextView.delegate = self;
        questionTextView.text = @"请您在此描述详细问题(不少于10个字)";
        questionTextView.font = WJFont12;
        questionTextView.textColor = WJColorLightGray;
        [cell.contentView addSubview:questionTextView];
        
        UILabel*maxFontL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(40),questionTextView.bottom , ALD(40), ALD(20))];
        maxFontL.textColor = WJColorDardGray9;
        maxFontL.text = @"10-200";
        maxFontL.font = WJFont12;
        [cell.contentView addSubview:maxFontL];
        
        
    } else {
        
        afterSaleUploadPhotoView = [[WJAfterSaleUploadPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(188))];
        afterSaleUploadPhotoView.delegate = self;
        [cell.contentView addSubview:afterSaleUploadPhotoView];
        
    }
    
    return cell;
}

- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont12,
                                             NSForegroundColorAttributeName : WJColorMainRed,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont12,
                                              NSForegroundColorAttributeName : WJColorDardGray9,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    
    
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma mark - WJRefundPickerView
-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
    
}

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel
{
    [_maskView removeFromSuperview];
    self.refundExpressView.expressTF.text = logisticsCompanyModel.logisticsCompanyName;
}

#pragma mark - WJExpressViewDelegate
-(void)startEditExpressView:(UITextField *)textField
{
    if (textField == _refundExpressView.expressTF) {
        
        [_refundExpressView.expressTF resignFirstResponder];
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.refundPickerView];
    }
}

-(void)endEditExpressView:(UITextField *)textField
{
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text length] > 200) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Action

-(void)nextButtonAction
{
    if (questionTextView.text.length > 0 && self.refundExpressView.expressTF.text.length > 0) {
        
        [self showLoadingView];
        [self.refundManager loadData];
    }
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //照片原图
        UIImage* orImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        if (orImage) {
            
            
            if (currentTapButtonIndex == 0) {
                
                if (self.photoViewArray.count == 0) {
                    [self.photoViewArray addObject:orImage];
                    
                } else {
                    
                    [self.photoViewArray replaceObjectAtIndex:0 withObject:orImage];
                }
                

                if (self.photoViewArray.count == 1) {
                    [self.photoViewArray addObject:@"2"];
                }
                
            } else if (currentTapButtonIndex == 1) {
                
                [self.photoViewArray replaceObjectAtIndex:1 withObject:orImage];
                
                if (self.photoViewArray.count == 2) {
                    [self.photoViewArray addObject:@"3"];
                }

            } else if (currentTapButtonIndex == 2) {
                
                [self.photoViewArray replaceObjectAtIndex:2 withObject:orImage];
                
                if (self.photoViewArray.count == 3) {
                    [self.photoViewArray addObject:@"4"];
                }


            } else if (currentTapButtonIndex == 3) {
                
                [self.photoViewArray replaceObjectAtIndex:3 withObject:orImage];
                
            }
            [afterSaleUploadPhotoView refreshViewWithArray:self.photoViewArray];
            
            UIImage *image = [self scaleImage:orImage toScale:0.3];
            [_photoListArray addObject:image];
            [self upLoadHeadPortrait];
                        
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"图片无效"];
        }
        
    }
    
}



-(void)upLoadHeadPortrait
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIImage *headImg in self.photoListArray) {
        
        NSString *dataStr = nil;
        NSData *data = UIImageJPEGRepresentation(headImg, 1.0);
        
        dataStr = [data base64EncodedStringWithOptions:0];
        
        [array addObject:dataStr];
    }
    
    self.refundManager.picListString = [array componentsJoinedByString:@","];
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0,0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}

#pragma mark - WJAfterSaleUploadPhotoViewDelegate
-(void)clickAddPhotoWithIndex:(NSInteger)index
{
    currentTapButtonIndex = index;
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为Camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        
        //设置选择后的图片可被编辑
        //picker.allowsEditing = YES;
        [self presentViewController:picker animated:NO completion:nil];

        
    } else if (buttonIndex == 1) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        //设置选择后的图片可被编辑
        //picker.allowsEditing = YES;
        [self presentViewController:picker animated:NO completion:nil];

    }
}

#pragma mark - WJServiceTypeViewDelegate
//-(void)maintainButtonClick
//{
//    NSLog(@"维修");
//}

//-(void)returnedProductButtonClick
//{
//    NSLog(@"退货");
//
//}

//-(void)refundButtonClick
//{
//    NSLog(@"退款");
//
//}

#pragma mark - setter& getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableView;
}


-(WJRefundPickerView *)refundPickerView
{
    if (nil == _refundPickerView) {
        _refundPickerView = [[WJRefundPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _refundPickerView.delegate = self;
        
        WJLogisticsCompanyModel *model1 = [[WJLogisticsCompanyModel alloc] init];
        model1.logisticsCompanyName = @"质量问题";
        
        WJLogisticsCompanyModel *model2 = [[WJLogisticsCompanyModel alloc] init];
        model2.logisticsCompanyName = @"质量商品成分描述不符";
        
        WJLogisticsCompanyModel *model3 = [[WJLogisticsCompanyModel alloc] init];
        model3.logisticsCompanyName = @"收到商品少件/破损";
        
        WJLogisticsCompanyModel *model4 = [[WJLogisticsCompanyModel alloc] init];
        model4.logisticsCompanyName = @"产地/批号/等描述不符";
        
        WJLogisticsCompanyModel *model5 = [[WJLogisticsCompanyModel alloc] init];
        model5.logisticsCompanyName = @"假冒产品";
        
        WJLogisticsCompanyModel *model6 = [[WJLogisticsCompanyModel alloc] init];
        model6.logisticsCompanyName = @"卖家发错货";
        
        WJLogisticsCompanyModel *model7 = [[WJLogisticsCompanyModel alloc] init];
        model7.logisticsCompanyName = @"拍错/多拍/不喜欢";
        
        WJLogisticsCompanyModel *model8 = [[WJLogisticsCompanyModel alloc] init];
        model8.logisticsCompanyName = @"三无产品";
        
        WJLogisticsCompanyModel *model9 = [[WJLogisticsCompanyModel alloc] init];
        model9.logisticsCompanyName = @"其他";
        
        _refundPickerView.expressListArray = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5,model6,model7,model8,model9 ,nil];
    }
    return _refundPickerView;
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

-(NSMutableArray *)photoListArray
{
    if (!_photoListArray) {
        _photoListArray = [NSMutableArray array];
    }
    return _photoListArray;
}

-(NSMutableArray *)photoViewArray
{
    if (!_photoViewArray) {
        _photoViewArray = [NSMutableArray array];
    }
    return _photoViewArray;
}

-(MBProgressHUD *)hud{
    if (nil==_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}

-(APIOrderDetailRefundManager *)refundManager
{
    if (_refundManager == nil) {
        _refundManager = [[APIOrderDetailRefundManager alloc] init];
        _refundManager.delegate = self;
    }
    _refundManager.userId = USER_ID;
    _refundManager.orderId = self.orderId;
    _refundManager.skuId = self.productModel.skuId;
    _refundManager.reason = questionTextView.text;
    _refundManager.refundReason = self.refundExpressView.expressTF.text;
    return _refundManager;
}

@end
