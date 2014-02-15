//
//  ViewController.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

//  六本木 35.666 139.731


#import "ViewController.h"
#import "MCSender.h"
#import <MapKit/MapKit.h>



@interface ViewController () <MCSenderDelegate, MKMapViewDelegate>

@property MCSender *sender;
@property NSTimer  *timer;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 送信役の起動
    _sender = [MCSender new];
    _sender.delegate = self;
    [_sender start];
    
    // 中心座標を指定
    CLLocationCoordinate2D center;
    center.latitude  =  35.666;
    center.longitude = 139.731;
    [_mapView setCenterCoordinate:center animated:NO];
    // 縮尺指定 (数が小さいほうが拡大)
    MKCoordinateRegion region = _mapView.region;
    region.center = center;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    // 地図表示
    _mapView.delegate = self;
    [_mapView setRegion:region animated:NO];
    [_mapView setBackgroundColor:[UIColor blackColor]];
    [_mapView setRotateEnabled:NO]; // 回転抑制
    [_mapView setPitchEnabled:NO]; // バードビュー抑制
    
    // 独自タイルレイヤーかぶせる
    NSString *template = @"http://i.yimg.jp/images/hackday/ohd2/img/ylogo.png?{z}/{x}/{y}";
    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [_mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)getCurrentCenter:(NSTimer*)timer
-(void)getCurrentCenter
{
    CLLocationCoordinate2D center;
    center = _mapView.centerCoordinate;
    NSLog(@"regionDidChangeAnimated %f %f", _mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);
    
    [_sender send:@{
                    @"lat": [NSString stringWithFormat:@"%f", _mapView.centerCoordinate.latitude],
                    @"lon": [NSString stringWithFormat:@"%f", _mapView.centerCoordinate.longitude],
                    @"span": @"",
                    }];
}



#pragma mark - MCSenderDelegate

// <MCSenderDelegate> 接続できた時に呼ばれる
- (void)didConnected
{
    NSLog(@"接続成功!");
}

// <MCSenderDelegate> 接続切れちゃった時に呼ばれる
- (void)didLostConnection
{
    NSLog(@"切れちゃった!");
}


#pragma mark - YMKMapViewDelegate

// タイルオーバーレイに必要
-(MKTileOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
}

// 地図のスクロール開始時
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
    
    // メインスレッドで監視をループさせる
    _timer = [NSTimer timerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(getCurrentCenter)
                                userInfo:nil
                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
 
// 地図のスクロール終了時
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    [_timer invalidate]; // 監視止める
//    [self getCurrentCenter];
}



@end
