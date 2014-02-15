//
//  MPViewController.m
//  ymap
//
//  Created by mee on 2/15/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MPViewController.h"
#import "MPAnnotation.h"
#import "UIImage+GIF.h"
#import "UIImage+animatedGIF.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // [Map]
    //YMKMapViewのインスタンスを作成
    YMKMapView *map = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) appid:@"dj0zaiZpPTIzMVdVRExhZVl5NCZzPWNvbnN1bWVyc2VjcmV0Jng9NDY-" ];
    //地図のタイプを指定
    [map setMapType:YMKMapTypeStyle MapStyle:@"midnight" MapStyleParam:nil];
    //YMKMapViewを追加
    [self.view addSubview:map];
    //YMKMapViewDelegateを登録
    map.delegate = self;
    //地図の位置と縮尺を設定
    CLLocationCoordinate2D center;
    center.latitude = 35.6657214;
    center.longitude = 139.7310058;
    map.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.01, 0.01));
    
    
    // [Pin]
    //アイコンの緯度経度を設定
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 35.665818701569016;
    coordinate.longitude = 139.73087297164147;
    //MyAnnotationの初期化
    MPAnnotation *myAnnotation = [[MPAnnotation alloc] initWithLocationCoordinate:coordinate title:@"ミッドタウン" subtitle:@"ミッドタウンです。"];
    //AnnotationをYMKMapViewに追加
    [map addAnnotation:myAnnotation];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



//Annotation追加イベント
- (YMKAnnotationView*)mapView:(YMKMapView *)mapView viewForAnnotation:(MPAnnotation*)annotation
{
    //追加されたAnnotationがMyAnnotationか確認
    if( [annotation isKindOfClass:[MPAnnotation class]] ){
        //YMKPinAnnotationViewを作成
        YMKPinAnnotationView *pin = [[YMKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"Pin"];
        
        //アイコンイメージの変更
        pin.image=[UIImage imageNamed:@"point01"];
        //アイコンのイメージのどこを基準点にするか設定
        CGPoint centerOffset;
        centerOffset.x=15;
        centerOffset.y=15;
        [pin setCenterOffset:centerOffset];
        
        
        // [回転アニメーション]
        // y軸に対して回転．（z軸を指定するとUIViewのアニメーションのように回転）
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        // アニメーションのオプションを設定
        animation.duration = 2.5; // アニメーション速度
        animation.repeatCount = 100; // 繰り返し回数
        // 回転角度を設定
        animation.fromValue = [NSNumber numberWithFloat:0.0]; // 開始時の角度
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 終了時の角度
        // アニメーションを追加
//        [pin.layer addAnimation:animation forKey:@"rotate-layer"];
        
        
        // [拡大縮小アニメーション]
        CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // アニメーションのオプションを設定
        animationScale.duration = 0.4; // アニメーション速度
        animationScale.repeatCount = HUGE_VALF; // 繰り返し回数
        animationScale.autoreverses = YES; // アニメーション終了時に逆アニメーション
        // 拡大・縮小倍率を設定
        animationScale.fromValue = [NSNumber numberWithFloat:0.2]; // 開始時の倍率
        animationScale.toValue = [NSNumber numberWithFloat:0.5]; // 終了時の倍率
        // アニメーションを追加
        [pin.layer addAnimation:animationScale forKey:@"scale-layer"];
        
        
        return pin;
    }
    return nil;
}

@end
