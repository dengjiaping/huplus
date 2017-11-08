//
//  WJShopMapView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/18.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJShopMapView.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
//#import <MapKit/MKAnnotationView.h>

#define beijing            CLLocationCoordinate2DMake(39.9589890000,116.4136120000);
#define beijing1            CLLocationCoordinate2DMake(39.9689990000,116.4236220000);

@interface WJShopMapView()<BMKMapViewDelegate>
{
    UIImageView    * shopIV;
    UILabel        * titleLabel;
    UILabel        * addressLabel;
}

@property(nonatomic,strong)BMKMapView             * mapView;
@property(nonatomic,strong)BMKLocationService     * locService;

@end

@implementation WJShopMapView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMapUI];
    }
    return self;
}

- (void)addMapUI
{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kAllBarHeight)];
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:15];
    [self addSubview:self.mapView];
    //添加大头针
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor = beijing;
//    coor.latitude = [self.merchantLatitude floatValue];
//    coor.longitude = [self.merchantLongitude floatValue];
    annotation.coordinate = coor;
    annotation.title = @"京宝大厦";
    [self.mapView addAnnotation:annotation];
    
    BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor1 = beijing1;
    annotation1.coordinate = coor1;
    annotation1.title = @"京宝";
    [self.mapView addAnnotation:annotation1];
    
    self.mapView.centerCoordinate = coor;
    [self.mapView selectAnnotation:annotation animated:YES];

}

#pragma mark 设置大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKAnnotationView * newAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"xiong"];
    // 设置可拖拽
    newAnnotation.draggable = YES;
    //设置大头针图标
    newAnnotation.image = [UIImage imageNamed:@"map_annotation"];
    
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(53, 15, 166, 83)];
    //设置弹出气泡图片
    UIImageView *backgroundIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map_paopao"]];
    backgroundIV.frame = popView.frame;
    [popView addSubview:backgroundIV];
    
    
    shopIV = [[UIImageView alloc]initForAutoLayout];
    shopIV.image = [WJUtilityMethod createImageWithColor:WJColorCardRed];
    [backgroundIV addSubview:shopIV];
    [backgroundIV addConstraints:[shopIV constraintsSize:CGSizeMake(54, 54)]];
    [backgroundIV addConstraints:[shopIV constraintsTopInContainer:10]];
    [backgroundIV addConstraints:[shopIV constraintsLeftInContainer:9]];

    
    titleLabel = [[UILabel alloc]initForAutoLayout];
    titleLabel.font = WJFont12;
    titleLabel.textColor = WJColorNavigationBar;
    titleLabel.text = @"万达广场";
    [backgroundIV addSubview:titleLabel];
    [backgroundIV addConstraints:[titleLabel constraintsTopInContainer:15]];
    [backgroundIV addConstraints:[titleLabel constraintsLeft:8 FromView:shopIV]];
    
    addressLabel = [[UILabel alloc]initForAutoLayout];
    addressLabel.font = WJFont10;
    addressLabel.textColor = WJColorDardGray9;
    addressLabel.numberOfLines = 2;
    addressLabel.text = @"地址：北京市西城区大木仓胡同33号";
    [backgroundIV addSubview:addressLabel];
    [backgroundIV addConstraints:[addressLabel constraintsTop:4 FromView:titleLabel]];
    [backgroundIV addConstraints:[addressLabel constraintsLeft:8 FromView:shopIV]];
    [backgroundIV addConstraints:[addressLabel constraintsRightInContainer:9]];
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = popView.frame;
    newAnnotation.paopaoView = pView;
    return newAnnotation;
}

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
    }
    return _mapView;
}

@end
