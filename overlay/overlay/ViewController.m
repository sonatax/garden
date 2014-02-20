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
#import "FTFoursquareVenuesExplore.h"
#import "FTFoursquareVenue.h"


@interface ViewController () <MCSenderDelegate, MKMapViewDelegate>

@property MCSender *sender;
@property NSTimer  *timer;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet MKMapView *subMapView;
@property (strong, nonatomic) IBOutlet UIView *connectionStatusView;
@property (strong, nonatomic) UILabel *infoView;
@property (assign, nonatomic) BOOL displayInfoView;
@property (assign, nonatomic) BOOL connected;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayInfoView = YES;
    
    // 送信役の起動
    _sender = [MCSender new];
    _sender.delegate = self;
    [_sender start];
    
    // 中心座標を指定
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35.6325893, 139.8820391); // ディズニーランド
//    center = CLLocationCoordinate2DMake(35.6316323, 139.7132926); // 目黒
    [_mapView setCenterCoordinate:center animated:NO];
    // 縮尺指定 (数が小さいほうが拡大)
    MKCoordinateRegion region = _mapView.region;
    region.center = center;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [_mapView setRegion:region animated:NO];
    // 地図表示
    _mapView.delegate = self;
    [_mapView setRotateEnabled:NO]; // 回転抑制
    [_mapView setPitchEnabled:NO];  // バードビュー抑制
    
    // 独自タイルレイヤーかぶせる
//    NSString *template = @"http://210.140.146.93/grid.jpg";
    NSString *template = [[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grid.jpg"]] absoluteString];

    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [_mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];

    
    
    // サブマップ
    [_subMapView setCenterCoordinate:center animated:NO];
    [_mapView setRegion:region animated:NO];
    [_subMapView setRotateEnabled:NO]; // 回転抑制
    [_subMapView setPitchEnabled:NO];  // バードビュー抑制
    [_subMapView setScrollEnabled:NO]; // スクロール抑制
    _subMapView.mapType = MKMapTypeSatellite;
    _subMapView.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

//-(void)getCurrentCenter:(NSTimer*)timer
-(void)getCurrentCenter
{
    CLLocationCoordinate2D center;
    center = _mapView.centerCoordinate;
    NSLog(@"latlon: %f %f", _mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);
    NSLog(@" %f %f", (float)_mapView.region.span.latitudeDelta, (float)_mapView.region.span.longitudeDelta);
    
    [_sender send:@{
                    @"lat": [NSString stringWithFormat:@"%f", _mapView.centerCoordinate.latitude],
                    @"lon": [NSString stringWithFormat:@"%f", _mapView.centerCoordinate.longitude],
                    @"span": [NSString stringWithFormat:@"%f", (float)_mapView.region.span.longitudeDelta],
                    }];
    
    MKCoordinateRegion region = _mapView.region;
    region.center = center;
    region.span.latitudeDelta  = _mapView.region.span.latitudeDelta / 15;
    region.span.longitudeDelta = _mapView.region.span.longitudeDelta / 15;
    [_subMapView setRegion:region animated:YES];
}



#pragma mark - MCSenderDelegate

// <MCSenderDelegate> 接続できた時に呼ばれる
- (void)didConnected
{
    NSLog(@"接続成功!");
    self.connected = YES;
    self.connectionStatusView.backgroundColor = [UIColor greenColor];
}

// <MCReceiverDelegate> 接続が切れた状態から再度接続できた時に呼ばれる
- (void)didRecoverConnection
{
    NSLog(@"接続復帰!");
    self.connected = YES;
    self.connectionStatusView.backgroundColor = [UIColor greenColor];
}

// <MCSenderDelegate> 接続切れちゃった時に呼ばれる
- (void)didLostConnection
{
    NSLog(@"切れちゃった!");
    self.connected = NO;
    self.connectionStatusView.backgroundColor = [UIColor redColor];
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
    
    // Bluetooth接続が切れていたら再度繋ぎにいく
    if ( ! self.connected) {
        [_sender start];
    }
    
    // メインスレッドで監視をループさせる
    _timer = [NSTimer timerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(getCurrentCenter)
                                userInfo:nil
                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    _subMapView.alpha = 0;
}

// 地図のスクロール終了時
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    [_timer invalidate]; // 監視止める
//    [self getCurrentCenter];

    _subMapView.alpha = 0.8;
    
    
    if (self.displayInfoView) {
        [self addInfoView];
    }
}


- (void)addInfoView
{
    if ( ! self.displayInfoView) {
        return;
    }
    if (self.infoView != nil) {
        return;
    }
    
    self.displayInfoView = NO;
    // スポット
    [AppGlobal.foursquareEngine venuesExploreWithCoordinate:_mapView.centerCoordinate
                                                  andRadius:5000
                                               onCompletion:^(FTFoursquareVenuesExplore *foursquareVenuesExplore) {
                                                   NSArray *array = foursquareVenuesExplore.venues;
                                                   
                                                   if ([array count] == 0) {
                                                       return;
                                                   }
                                                   
                                                   NSUInteger randomIndex = arc4random() % [array count];
                                                   FTFoursquareVenue *venue = array[randomIndex];
                                                   
                                                   self.infoView = [[UILabel alloc] initWithFrame:CGRectMake(300, 200, 250, 100)];
                                                   self.infoView.backgroundColor = [UIColor clearColor];
                                                   self.infoView.textColor = [UIColor orangeColor];
                                                   self.infoView.font = [UIFont systemFontOfSize:12];
                                                   self.infoView.textAlignment = NSTextAlignmentCenter;
                                                   self.infoView.layer.borderColor = [UIColor orangeColor].CGColor;
                                                   self.infoView.layer.borderWidth = 3.0;
                                                   self.infoView.numberOfLines = 0;
                                                   
                                                   NSString *address = (venue.foursquareLocation.address == nil) ? @"" : venue.foursquareLocation.address;
                                                   self.infoView.text = [NSString stringWithFormat:@"%@\n%@", venue.name, address];
                                                   
                                                   [self.view addSubview:self.infoView];
                                                   [self.infoView.layer addAnimation:[self makeAnimation] forKey:@"openAnimation"];
                                                   
                                                   [UIView animateWithDuration:0.2 delay:3.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                                                       self.infoView.frame = CGRectMake(-300, self.infoView.frame.origin.y, self.infoView.frame.size.width, self.infoView.frame.size.height);
                                                   } completion:^(BOOL finished) {
                                                       [self.infoView removeFromSuperview];
                                                       self.infoView = nil;
                                                       self.displayInfoView = YES;
                                                   }];
                                               } onError:^(NSError *error) {
                                               }];

}


- (CAAnimationGroup *)makeAnimation
{
    CABasicAnimation *fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.4;
    fadeAnim.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *resizeAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    resizeAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.0)];
    resizeAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)];
    resizeAnim1.duration = fadeAnim.duration;
    resizeAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    resizeAnim1.fillMode = kCAFillModeForwards;
    
    // y軸に対して回転．（z軸を指定するとUIViewのアニメーションのように回転）
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    // アニメーションのオプションを設定
    rotateAnimation.duration = fadeAnim.duration; // アニメーション速度
    // 回転角度を設定
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 開始時の角度
    rotateAnimation.toValue = [NSNumber numberWithFloat:5 * M_PI]; // 終了時の角度
    
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 始点と終点を設定
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 50)]; // 始点
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 200)]; // 終点

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.animations = @[fadeAnim, resizeAnim1];
    group.duration = fadeAnim.duration;
    group.delegate = self;
    group.repeatCount = 1;
    [group setValue:@"showThreadCreateButtonAnimation" forKey:@"animationName"];
    
    return group;
    
}

@end
