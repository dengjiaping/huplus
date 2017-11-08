//
//  WJCameraController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WJCustomOverlayView.h"
#import "WJSelectPhotoImageView.h"

#import "APIPictureUploadManager.h"

@interface WJCameraController ()<APIManagerCallBackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isUsingFrontFacingCamera; //前置摄像头
    BOOL isImageFormLibrary;       //是否来自相册

}

/** AVCaptureSession对象来执行输入设备和输出设备之间的数据传递 */
@property (nonatomic, strong) AVCaptureSession           * session;
/** 输入硬件 */
@property (nonatomic, strong) AVCaptureDeviceInput       * videoInput;
/**  照片输出流 */
@property (nonatomic, strong) AVCaptureStillImageOutput  * stillImageOutput;
/**  预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, strong) WJCustomOverlayView        * customOverlayView;
@property (nonatomic, strong) UIView                     * cameraView;
@property (nonatomic, strong) WJSelectPhotoImageView     * selectIV;

@property (nonatomic, strong) APIPictureUploadManager    * pictureUploadManager;


@end

@implementation WJCameraController


#pragma mark - Lift Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.session) {
        [self.session startRunning];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isPresentVC = YES;
    isUsingFrontFacingCamera = YES;
    isImageFormLibrary = NO;
    //创建相机图层
    [self.view addSubview:self.cameraView];
    [self initAVCaptureSession];
    [self.cameraView addSubview:self.customOverlayView];
    [self switchButtonAction];
    //创建选中图层
    [self.view addSubview:self.selectIV];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"图片上传成功");
    NSDictionary * dataDic = [manager fetchDataWithReformer:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.cameraControllerBlock(dataDic);
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    ALERT(manager.errorMessage);
}

#pragma mark - Button Action

- (void)sureButtonAction
{
    self.selectIV.hidden = YES;
    if (isImageFormLibrary) {
        
    }else{
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[self.selectIV.image CGImage] orientation:(ALAssetOrientation)[self.selectIV.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (!error) {
                NSLog(@"保存成功");
                NSString *dataStr = nil;
                NSData *data = UIImageJPEGRepresentation(self.selectIV.image, 0.5);
                dataStr = [data base64EncodedStringWithOptions:0];
                self.pictureUploadManager.headPortrait = dataStr;
                [self.pictureUploadManager loadData];
            } else {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

- (void)quitButtonAction
{
    self.selectIV.hidden = YES;
}

- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchButtonAction
{
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionFront;
    }else{
        desiredPosition = AVCaptureDevicePositionBack;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)shootButtonAction
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        //添加选择图层
        isImageFormLibrary = NO;
        self.selectIV.hidden = NO;
        self.selectIV.image = [UIImage imageWithData:jpegData];


    }];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationPortrait)
        result = AVCaptureVideoOrientationPortrait;
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        result = AVCaptureVideoOrientationPortraitUpsideDown;
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        result = AVCaptureVideoOrientationLandscapeRight;
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}


- (void)libraryButtonAction
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:NO completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //照片原图
        UIImage* orImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        if (orImage) {
            self.selectIV.image = orImage;
            self.selectIV.hidden = NO;
            isImageFormLibrary = YES;
            
            NSString *dataStr = nil;
            NSData *data = UIImageJPEGRepresentation(self.selectIV.image, 0.5);
            dataStr = [data base64EncodedStringWithOptions:0];
            self.pictureUploadManager.headPortrait = dataStr;
            [self.pictureUploadManager loadData];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"图片无效"];
        }
        
    }
    
}

#pragma mark - Setter And Getter

- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //闪光灯
    if ([device isFlashModeSupported:AVCaptureFlashModeOff]) {
        [device setFlashMode:AVCaptureFlashModeAuto];
    }
    //白平衡
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    //对焦
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 0,kScreenWidth, kScreenHeight);
    self.cameraView.layer.masksToBounds = YES;
    [self.cameraView.layer addSublayer:self.previewLayer];
    
}

- (UIView *)cameraView
{
    if (_cameraView == nil) {
        _cameraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _cameraView;
}

- (WJCustomOverlayView *)customOverlayView
{
    if (_customOverlayView == nil) {
        _customOverlayView = [[WJCustomOverlayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_customOverlayView.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_customOverlayView.switchButton addTarget:self action:@selector(switchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_customOverlayView.shootButton addTarget:self action:@selector(shootButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_customOverlayView.libraryButton addTarget:self action:@selector(libraryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customOverlayView;
}

- (WJSelectPhotoImageView *)selectIV
{
    if (_selectIV == nil) {
        _selectIV = [[WJSelectPhotoImageView alloc]initWithFrame:self.view.frame];
        _selectIV.userInteractionEnabled = YES;
        _selectIV.contentMode = UIViewContentModeScaleAspectFill;
        _selectIV.hidden = YES;
        [_selectIV.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectIV.quitButton addTarget:self action:@selector(quitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectIV.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _selectIV;
}

- (APIPictureUploadManager *)pictureUploadManager
{
    if (_pictureUploadManager == nil) {
        _pictureUploadManager = [[APIPictureUploadManager alloc]init];
        _pictureUploadManager.delegate = self;
        _pictureUploadManager.userId = USER_ID;
    }
    return _pictureUploadManager;
}

@end
