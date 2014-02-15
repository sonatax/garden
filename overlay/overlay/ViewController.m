//
//  ViewController.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "ViewController.h"
#import "MCSender.h"
#import <YMapKit/YMapKit.h>

@interface ViewController () <MCSenderDelegate, YMKMapViewDelegate>

@property MCSender *sender;
@property YMKMapView *mapView;
@property NSTimer  *timer;
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

    // 初期位置指定(六本木)
    CLLocationCoordinate2D center;
    center.latitude  = 35.666;
    center.longitude = 139.731;

/*
    // スクロール＆座標決定のためだけに地図つかう
    _mapView = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) appid:@"dj0zaiZpPTIzMVdVRExhZVl5NCZzPWNvbnN1bWVyc2VjcmV0Jng9NDY-" ];
    _mapView.delegate = self;
    _mapView.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.01, 0.01));

    [self.view addSubview:_mapView];
//    _mapView.alpha = 0.5;  // viewとしては見えなくていい :)
 */
    
    //YMKMapViewのインスタンスを作成
    YMKMapView* map = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) appid:@"dj0zaiZpPTIzMVdVRExhZVl5NCZzPWNvbnN1bWVyc2VjcmV0Jng9NDY-" ];
    
    //地図のタイプを指定 標準の地図を指定
    map.mapType = YMKMapTypeStandard;
    
    //YMKMapViewを追加
    [self.view addSubview:map];
    
    //YMKMapViewDelegateを登録
    map.delegate = self;
    
    //地図の位置と縮尺を設定
    map.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.002, 0.002));
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getCurrentCenter:(NSTimer*)timer
{
//    YMKMapView *mapView = [timer userInfo];
    
    CLLocationCoordinate2D center;
    center = _mapView.centerCoordinate;
    NSLog(@"regionDidChangeAnimated %f %f", _mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);
    
    
    [_sender send:@{
                    @"time": [NSString stringWithFormat:@"%f", _mapView.centerCoordinate.latitude]
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
/*

// 地図のスワイプ開始時
-(void)mapView:(YMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
    // メインスレッドで監視をループさせる
    _timer = [NSTimer timerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(getCurrentCenter:)
//                                        userInfo:mapView
                                        userInfo:nil
                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


// 地図のスワイプ終了時
-(void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    [_timer invalidate]; // 監視止める

//    [self getCurrentCenter];
}
 
 */


- (IBAction)testButton:(id)sender {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    // 相手に何か送るのはsendに投げるだけ
    [_sender send:@{
                    @"time":dateString,
                    @"hello":@"Hello World!",
                    }];
}




@end
