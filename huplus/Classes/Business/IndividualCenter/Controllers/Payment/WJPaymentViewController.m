//
//  WJPaymentViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/26.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJPaymentViewController.h"
#import "WJPaymentView.h"
#import "SM3Generation.h"
#import <ZXingObjC/ZXingObjC.h>
#import "CreatQRCodeAndBarCodeFromLeon.h"
#import "UINavigationBar+Awesome.h"

@interface WJPaymentViewController ()<WJPaymentViewDelegate>
{
    UIColor         *color;
    CGFloat         alpha;
}
@property(nonatomic,strong)WJPaymentView *paymentView;
@end

@implementation WJPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"付款";
    color = WJColorMainRed;
    alpha = 0;
    [self gradientLayerWithView:self.view];
    self.isHiddenTabBar = YES;
    [self navigationSetup];
    [self.view addSubview:self.paymentView];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (void)navigationSetup
{
    UIButton *explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    explainButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [explainButton setImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
    [explainButton addTarget:self action:@selector(explainButtonButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:explainButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)explainButtonButtonAction
{
    
}

#pragma mark - WJPaymentViewDelegate
-(void)refreshPayCodeButtonClick
{
    NSLog(@"刷新付款码");
    //刷新付款码
    [self requestPayCode];

}

-(void)requestPayCode
{
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    
//    if (person.token.length == 32 && person.payPassword.length > 18) {
//        
//        NSString *key = [person.token stringByAppendingString:person.payPassword];
//        
//        NSTimeInterval serverTimeSubLocal = [[[NSUserDefaults standardUserDefaults] objectForKey:kServerTimeSubLocal] doubleValue];
//        
//        int time = [[NSDate date] timeIntervalSince1970] + serverTimeSubLocal;
//        
//        NSString *qrToken = [SM3Generation getTokenWithSM3TOTP:time tokenChangeDuring:5 priKey:[key substringWithRange:NSMakeRange(18, 32)] tokenLength:6];
//        
//        NSString *qrString = [NSString stringWithFormat:@"86%@%@", [person.phone substringFromIndex:1], qrToken];
//        
//        [self generatedQR:qrString];
//    }else{
//        if (person.payPassword.length<=18) {
//            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误18，请重新设置支付密码"];
//        }else {
//            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误32，请重新登录"];
//        }
//    }
    
}

#pragma mark - generatedQR

- (void)generatedQR:(NSString *)qrCode{
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:qrCode
                                  format:kBarcodeFormatCode128
                                   width:300
                                  height:70
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        self.paymentView.barCodeImageView.image = [UIImage imageWithCGImage:image];
    }
    
    self.paymentView.barCodeLabel.text = [qrCode macCodeFormaterWithString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.paymentView.barCodeLabel.text attributes:@{NSKernAttributeName : @(2.0f)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.paymentView.barCodeLabel.text.length)];
    self.paymentView.barCodeLabel.attributedText = attributedString;
    self.paymentView.barCodeLabel.textAlignment = NSTextAlignmentCenter;
    self.paymentView.qrCodeImageView.image = [CreatQRCodeAndBarCodeFromLeon qrImageWithString:qrCode size:self.paymentView.qrCodeImageView.size color:WJColorBlack backGroundColor:WJColorWhite correctionLevel:ErrorCorrectionLevelMedium];
}

#pragma mark - Custom Function
- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [WJUtilityMethod colorWithHexColorString:@"#f11c61"];
    UIColor *color2 = [WJUtilityMethod colorWithHexColorString:@"#fb551b"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    
}

-(WJPaymentView *)paymentView
{
    if (!_paymentView) {
        _paymentView = [[WJPaymentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _paymentView.delegate = self;
    }
    return _paymentView;
}


@end
