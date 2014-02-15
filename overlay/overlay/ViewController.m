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
#import "TileView.h"
#import <YMapKit/YMapKit.h>

@interface ViewController () <MCSenderDelegate, YMKMapViewDelegate>

@property MCSender *sender;
@property (nonatomic, strong) YMKMapView *yMapView;
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
    
    // 地図の追加
    self.yMapView = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) appid:@"dj0zaiZpPTIzMVdVRExhZVl5NCZzPWNvbnN1bWVyc2VjcmV0Jng9NDY-" ];
//    [self.yMapView setMapType:YMKMapTypeStyle MapStyle:@"midnight" MapStyleParam:nil];
    self.yMapView.delegate = self;
    [self.view addSubview:self.yMapView];
    // 初期座標と縮尺
    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(35.666, 139.731);
    self.yMapView.region = YMKCoordinateRegionMake(currentCoordinate, YMKCoordinateSpanMake(0.01, 0.01));
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
    center = _yMapView.centerCoordinate;
    NSLog(@"regionDidChangeAnimated %f %f", _yMapView.centerCoordinate.latitude, _yMapView.centerCoordinate.longitude);
    
    [_sender send:@{
                    @"lat": [NSString stringWithFormat:@"%f", _yMapView.centerCoordinate.latitude],
                    @"lon": [NSString stringWithFormat:@"%f", _yMapView.centerCoordinate.longitude],
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



- (IBAction)testButton:(id)sender {
    // 相手に何か送るのは、sendに投げるだけ
    [_sender send:@{
                    @"lat":@"latです",
                    @"lon":@"lonです",
                    @"span":@"spanです",
                    }];
}


#pragma mark - YMKMapViewDelegate

// 地図のスワイプ開始時
-(void)mapView:(YMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
    // メインスレッドで監視をループさせる
    _timer = [NSTimer timerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(getCurrentCenter)
                                userInfo:nil
                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
 
// 地図のスワイプ終了時
-(void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    [_timer invalidate]; // 監視止める
    [self getCurrentCenter];
}



@end
