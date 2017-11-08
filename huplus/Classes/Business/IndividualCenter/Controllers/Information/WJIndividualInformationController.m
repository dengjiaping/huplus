//
//  WJIndividualInformationController.m
//  HuPlus
//
//  Created by reborn on 17/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIndividualInformationController.h"
#import "WJPhotoView.h"
#import "WJSelectPickerView.h"
#import "WJSelectDataPickerView.h"
#import "WJChangeNickNameViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>
#import "SecurityService.h"
#import <UIImageView+WebCache.h>
#import "APIModifyInformationManager.h"
#import "APIBaseService.h"
#import "APIServiceFactory.h"

@interface WJIndividualInformationController ()<UITableViewDelegate,UITableViewDataSource,WJSelectPickerViewDelegate,UITextFieldDelegate,WJSelectDataPickerViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,APIManagerCallBackDelegate>
{
    UITextField *regionTF;
    UITextField *birthTF;
    UITextField *genderTF;
    UITextField *userNameTF;
    NSData      *imgData;    //图片流
    
    UIImageView *avatarImageView;
    
    UIImage     *originalImage;
    UIImage     *lastImage;
}
@property(nonatomic,strong)UITableView                 *tableView;
@property(nonatomic,strong)NSArray                     *listArray;
@property(nonatomic,strong)UIView                      *maskView;
@property(nonatomic,strong)WJSelectPickerView          *selectPickerView;
@property(nonatomic,strong)WJSelectDataPickerView      *selectDataPickerView;
@property(nonatomic,strong)UIActionSheet               *genderSheet;
@property(nonatomic,strong)UIActionSheet               *photoSheet;

@property(nonatomic,strong)MBProgressHUD               *hud;
@property(nonatomic,strong)APIModifyInformationManager *modifyInformationManager;
@property(nonatomic, strong)AFHTTPSessionManager       *operationManager;

@property(nonatomic,strong)WJAreaModel                 *selectProvince;
@property(nonatomic,strong)WJAreaModel                 *selectCity;
@property(nonatomic,strong)WJAreaModel                 *selectDistrict;
@property(nonatomic,strong)NSString                    *gender;
@property(nonatomic,strong)NSString                    *headPortraitStr;

@end

@implementation WJIndividualInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资料";
    self.isHiddenTabBar = YES;
    
    [self.view addSubview:self.tableView];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    lastImage = originalImage;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handletapPressGesture
{
    [regionTF resignFirstResponder];
    [userNameTF resignFirstResponder];
    [birthTF resignFirstResponder];
    [genderTF resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIModifyInformationManager class]]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[manager fetchDataWithReformer:nil]];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KUserInformation];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSDictionary  *userInformation = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation]];
        
        NSLog(@"新的数据%@",userInformation);

        if (self.modifyInformationManager.headPic && ![originalImage isEqual:lastImage]) {
            
            avatarImageView.image = originalImage;
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
        }
        
        UIImage *headImage = originalImage ? : BitmapHeaderImg;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHeadPortrait" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys: headImage ,@"head_portrait" ,userNameTF.text,@"nick_name",userInformation[@"login_name"],@"login_name",nil]];

    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(66);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndividualInformationCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndividualInformationCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(110), ALD(66))];
        nameL.textColor = WJColorNavigationBar;
        nameL.font = WJFont14;
        nameL.tag = 3001;
        [cell.contentView addSubview:nameL];
        
        UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
        UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - image.size.width, (ALD(66) - image.size.height)/2, image.size.width, image.size.height)];
        rightArrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        [cell.contentView addSubview:rightArrowImageView];
    
        
        UITextField *contentTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(34) - ALD(220), 0, ALD(220), ALD(66))];
        contentTF.textColor = WJColorDardGray9;
        contentTF.font = WJFont14;
        contentTF.tag = 3002;
        contentTF.delegate = self;
        contentTF.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:contentTF];
        
    }

    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:3001];
    UITextField *contentTF = (UITextField *)[cell.contentView viewWithTag:3002];

    NSDictionary *dic = self.listArray[indexPath.row];
    nameL.text = dic[@"text"];
    
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation];

    
    if (indexPath.row == 0) {
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(34) - ALD(44), (ALD(66) - ALD(44))/2, ALD(44), ALD(44))];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        avatarImageView.layer.cornerRadius = ALD(22);
        avatarImageView.layer.masksToBounds = YES;
        [avatarImageView sd_setImageWithURL:USER_headPortrait placeholderImage:BitmapHeaderImg];
        [cell.contentView addSubview:avatarImageView];
        
        contentTF.userInteractionEnabled = NO;
        
        
    } else if (indexPath.row == 1) {
        
        userNameTF = contentTF;
        userNameTF.text  =  infoDic[@"nick_name"];
        
    } else if (indexPath.row == 2) {
        
        genderTF = contentTF;
        
        if (infoDic[@"sex"]) {
            
            NSInteger sex =  [infoDic[@"sex"] integerValue];
            if (sex == 0) {
                genderTF.text = @"男";
            } else if (sex == 1)   {
                genderTF.text = @"女";
            }

        } else {
            genderTF.text = @"未设置";
        }

        
    } else if (indexPath.row == 3) {
        
        birthTF = contentTF;
        birthTF.text = infoDic[@"birthday"];
        
    } else if (indexPath.row == 4) {
        
        regionTF = contentTF;
        regionTF.text = [NSString stringWithFormat:@"%@%@%@",infoDic[@"province"],infoDic[@"city"],infoDic[@"district"]];

    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if (self.selectPickerView) {
            [self.selectPickerView removeFromSuperview];
        }
        
        [self.photoSheet showInView:self.view];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == regionTF) {
        
        [regionTF resignFirstResponder];
        
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.selectPickerView];
        
    } else if (textField == genderTF) {
        
        [genderTF resignFirstResponder];
        [self.genderSheet showInView:self.view];
        
        
    } else if (textField == birthTF) {
        
        [birthTF resignFirstResponder];

        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.selectDataPickerView];
        
    } else if (textField == userNameTF) {
        
        [userNameTF resignFirstResponder];
        
        WJChangeNickNameViewController *changeNickNameVC = [[WJChangeNickNameViewController alloc] init];
        NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation];
        changeNickNameVC.nickName = infoDic[@"nick_name"];
        [self.navigationController pushViewController:changeNickNameVC animated:YES];
        
        changeNickNameVC.nickNameBlock = ^(NSString *name){
            
            userNameTF.text = name;
            [self.modifyInformationManager loadData];

        };
    }
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet == _genderSheet) {
        
        if (buttonIndex == 0) {
            genderTF.text = @"男";
            self.gender = NumberToString(0);
            
        } else if (buttonIndex == 1) {
            genderTF.text = @"女";
            self.gender = NumberToString(1);
        }
        
        [self.modifyInformationManager loadData];
        
    } else {
        
        if (buttonIndex == 0) {
            
            [_maskView removeFromSuperview];
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //设置选择后的图片可被编辑
            //picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:NO completion:nil];
            
        } else if (buttonIndex == 1) {
            
            [_maskView removeFromSuperview];
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //设置选择后的图片可被编辑
            //picker.allowsEditing = YES;
            [self presentViewController:picker animated:NO completion:nil];
        }
    }
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
    
    [self.modifyInformationManager loadData];
}

#pragma mark - WJSelectDataPickerViewDelegate
-(void)selectDataPickerView:(WJSelectDataPickerView *)dataPickerViewView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
}

-(void)selectDataPickerView:(WJSelectDataPickerView *)dataPickerViewView clickConfirmButtonWithSelectBirthDay:(NSString *)string
{
    [_maskView removeFromSuperview];
    birthTF.text = [NSString stringWithFormat:@"%@",string];
    [self.modifyInformationManager loadData];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //照片原图
        UIImage  *orImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (orImage) {

            originalImage = orImage;
            UIImage *image =   [self scaleImage:originalImage toScale:0.3];
            
            [self upLoadHeadPortrait:image];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"图片无效"];
        }
        
    }
    
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

-(void)upLoadHeadPortrait:(UIImage *)img
{
    NSString *dataStr = nil;
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    dataStr = [data base64EncodedStringWithOptions:0];

    self.headPortraitStr = dataStr;
    [self.modifyInformationManager loadData];
}


//-(void)uploadToServer:(NSData *)imgdata
//{
//    
//    NSString *dataStr = [NSString stringWithFormat:@"%@", [imgdata base64EncodedDataWithOptions:0]];
//    
//    NSString * mobile = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation][@"login_name"];
//    if (!mobile) {
//        
//        mobile = [[[NSUserDefaults standardUserDefaults] objectForKey:KUserInformation] objectForKey:@"login_name"];
//    }
//    
//    NSMutableString *sign = (NSMutableString *)[[NSMutableString stringWithFormat:@"app_id=%@mobile=%@%@",@"10002",mobile,@"7r0Ed2ErDIxh9OOmzxlN"] lowercaseString];
//    
//    NSDictionary *params= @{
//                            @"app_id":@"10002",
//                            @"sign": (NSMutableString *)[SecurityService md5ForString:sign],
//                            @"token": USER_ID
//                            };
//    
//    APIBaseService *service = [[APIServiceFactory sharedInstance] serviceWithIdentifier:kAPIServiceWanJiKa];
//    NSString *baseImageUrl = service.apiBaseUrl;
//    
//    [_operationManager POST:baseImageUrl
//       parameters:nil
//    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//    
//        [formData appendPartWithFileData:imgdata name:@"1" fileName:@"1.png" mimeType:@"image/jpeg"];
//    
//        [self.view addSubview:self.hud];
//        self.hud.labelText = @"正在上传中...";
//        self.hud.mode = MBProgressHUDModeIndeterminate;
//    
//        [self.hud show:YES];
//    
//     } progress:nil
//     
//          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//              NSData *resp = responseObject;
//              NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:resp options:NSJSONReadingAllowFragments error:nil];
//              NSInteger result=[dataDic[@"Code"]integerValue];
//              
//              if (result ==0 )
//              {
//                  self.hud.mode = MBProgressHUDModeText;
//                  self.hud.labelText = @"上传成功";
//                  
//                  // 把已经上传的个人头像更新到本地
////                  WJModelPerson* defaultperson = [WJDBPersonManager getDefaultPerson];
////                  defaultperson.headImageUrl = dataDic[@"Val"]?:@"";
//                  
//                  //需要接口返回头像url
////                  avatarImageView.image = orImage;
//                  [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
//                  
//                  NSLog(@"服务器返回的val＝＝%@",dataDic[@"Val"]);
//                  
//              } else if (result==1) {
//                  self.hud.mode=MBProgressHUDModeText;
//                  self.hud.labelText=@"网络异常,请稍候再试";
//                  [[TKAlertCenter defaultCenter] postAlertWithMessage:@"网络异常，请稍候再试"];
//                  
//              } else {
//                  self.hud.mode=MBProgressHUDModeText;
//                  self.hud.labelText=@"请求超时,请不要选择太大的图片";
//                  [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请求超时"];
//                  
//              }
//              
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"fail");
//              [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传失败"];
//              
//          }];
//}


#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}

#pragma mark - 属性方法
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorColor = WJColorSeparatorLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


-(WJSelectPickerView *)selectPickerView
{
    if (nil == _selectPickerView) {
        _selectPickerView = [[WJSelectPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _selectPickerView.delegate = self;
        
    }
    return _selectPickerView;
}

-(WJSelectDataPickerView *)selectDataPickerView
{
    if (nil == _selectDataPickerView) {
        _selectDataPickerView = [[WJSelectDataPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _selectDataPickerView.delegate = self;
        
    }
    return _selectDataPickerView;
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

-(UIActionSheet *)genderSheet
{
    if (!_genderSheet) {
        _genderSheet = [[UIActionSheet alloc] initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        _genderSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        _genderSheet.destructiveButtonIndex = 2;

        _genderSheet.delegate = self;
        
    }
    return _genderSheet;
}

-(UIActionSheet *)photoSheet
{
    if (!_photoSheet) {
        
        _photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        _photoSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        _photoSheet.destructiveButtonIndex = 2;
        _photoSheet.delegate = self;
    }
    return _photoSheet;

}

-(NSArray *)listArray
{
    return @[
             @{@"image":@"defaultImage",@"text":@"我的头像"},
             @{@"text":@"用户名"},
             @{@"text":@"性别"},
             @{@"text":@"生日"},
             @{@"text":@"地区"}
             ];
}

-(APIModifyInformationManager *)modifyInformationManager
{
    if (_modifyInformationManager == nil) {
        _modifyInformationManager = [[APIModifyInformationManager alloc] init];
        _modifyInformationManager.delegate = self;
    }
    _modifyInformationManager.userId = USER_ID;
    _modifyInformationManager.headPic = self.headPortraitStr;
    _modifyInformationManager.userName = userNameTF.text;
    _modifyInformationManager.sex = self.gender;
    _modifyInformationManager.birthday = birthTF.text;
    _modifyInformationManager.provinceId = self.selectProvince.areaNo;
    _modifyInformationManager.cityId = self.selectCity.areaNo;
    _modifyInformationManager.districtId = self.selectDistrict.areaNo;

    return _modifyInformationManager;
}


@end
