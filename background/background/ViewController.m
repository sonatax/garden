//
//  ViewController.m
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "ViewController.h"
#import "MCReceiver.h"
#import <YMapKit/YMapKit.h>

@interface ViewController () <MCReceiverDelegate, YMKMapViewDelegate>
@property MCReceiver *receiver;

@property (weak, nonatomic) IBOutlet UILabel *labelLat;
@property (weak, nonatomic) IBOutlet UILabel *labelLon;
@property (weak, nonatomic) IBOutlet UILabel *labelSpan;
@property (strong, nonatomic) YMKMapView *yMapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // 受信役の起動
    _receiver = [MCReceiver new];
    _receiver.delegate = self;
    [_receiver start];
    
    
    // 地図の追加
    //YMKMapViewのインスタンスを作成
    self.yMapView = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) appid:@"dj0zaiZpPTIzMVdVRExhZVl5NCZzPWNvbnN1bWVyc2VjcmV0Jng9NDY-" ];
    //地図のタイプを指定
    [self.yMapView setMapType:YMKMapTypeStyle MapStyle:@"midnight" MapStyleParam:nil];
    //YMKMapViewを追加
    [self.view addSubview:self.yMapView];
    //YMKMapViewDelegateを登録
    self.yMapView.delegate = self;
    //地図の位置と縮尺を設定
    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(35.6657214, 139.7310058);
    self.yMapView.region = YMKCoordinateRegionMake(currentCoordinate, YMKCoordinateSpanMake(0.01, 0.01));
    //地図の反転
    self.yMapView.transform = CGAffineTransformScale(self.yMapView.transform, -1, 1);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// <MCReceiverDelegate> 接続できた時に呼ばれる
- (void)didConnected
{
    NSLog(@"接続成功!");
}

// <MCReceiverDelegate> 接続切れちゃった時に呼ばれる
- (void)didLostConnection
{
    NSLog(@"切れちゃった!");
}

// <MCReceiverDelegate> データが送られてきた時に呼ばれる
- (void)didReceive:(NSDictionary *)data
{
    NSLog(@"データ受信: %@", data);
    _labelLat.text  = data[@"lat"];
    _labelLon.text  = data[@"lon"];
    _labelSpan.text = data[@"span"];
 
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([data[@"lat"] floatValue], [data[@"lon"] floatValue]);
    [self.yMapView setCenterCoordinate:coordinate animated:YES];
}

@end
