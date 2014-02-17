//
//  ViewController.m
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "ViewController.h"
#import "MCReceiver.h"
#import "MPAnnotation.h"
#import <YMapKit/YMapKit.h>

@interface ViewController () <MCReceiverDelegate, YMKMapViewDelegate>
@property MCReceiver *receiver;

@property (weak, nonatomic) IBOutlet UILabel *labelLat;
@property (weak, nonatomic) IBOutlet UILabel *labelLon;
@property (weak, nonatomic) IBOutlet UILabel *labelSpan;
@property (strong, nonatomic) YMKMapView *yMapView;
@property (strong, nonatomic) NSMutableArray *addedAnnotationLat;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.addedAnnotationLat = [@[] mutableCopy];

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
    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(35.6325893, 139.8820391);
    self.yMapView.region = YMKCoordinateRegionMake(currentCoordinate, YMKCoordinateSpanMake(0.01, 0.01));
    //地図の反転
    self.yMapView.transform = CGAffineTransformScale(self.yMapView.transform, -1, 1);
    
    // 写真
    [AppGlobal.apiEngine photoOnCompletion:^(NSArray *array) {
        [self addAnnotationsWithPhotos:array];
    } onError:^(NSError *error) {
    }];
    
    // 空き室
    [AppGlobal.apiEngine vacancyWithCoordinate:currentCoordinate
                                    onCompletion:^(NSArray *array) {
                                        [self addAnnotationsWithVacancies:array];
                                    } onError:^(NSError *error) {
                                    }];

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
 
    CGFloat lat  = [data[@"lat"] floatValue];
    CGFloat lon  = [data[@"lon"] floatValue];
    CGFloat span = [data[@"span"] floatValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    YMKCoordinateSpan coordinateSpan = YMKCoordinateSpanMake(span, span);
    YMKCoordinateRegion coordinateRegion = YMKCoordinateRegionMake(coordinate, coordinateSpan);
    [self.yMapView setRegion:coordinateRegion];
}

#pragma mark - Private methods

- (void)addAnnotationsWithVacancies:(NSArray *)vacancies
{
    NSMutableArray *annotations = [@[] mutableCopy];
    for (NSDictionary *vacancy in vacancies) {
        //アイコンの緯度経度を設定
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([vacancy[@"Lat"] floatValue], [vacancy[@"Lon"] floatValue]);
        //MyAnnotationの初期化
        MPAnnotation *myAnnotation = [[MPAnnotation alloc] initWithLocationCoordinate:coordinate title:vacancy[@"Stock"] subtitle:nil];
        if ( ! [self.addedAnnotationLat containsObject:vacancy[@"Lat"]]) {
            [annotations addObject:myAnnotation];
            [self.addedAnnotationLat addObject:vacancy[@"Lat"]];
        }
    }
    [self.yMapView addAnnotations:annotations];
}

- (void)addAnnotationsWithPhotos:(NSArray *)photos
{
    NSMutableArray *annotations = [@[] mutableCopy];
    for (NSDictionary *photo in photos) {
        //アイコンの緯度経度を設定
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([photo[@"Lat"] floatValue], [photo[@"Lon"] floatValue]);
        //MyAnnotationの初期化
        MPAnnotation *myAnnotation = [[MPAnnotation alloc] initWithLocationCoordinate:coordinate title:nil subtitle:nil];
        myAnnotation.imageUrl = photo[@"Image"];
        [annotations addObject:myAnnotation];
    }
    [self.yMapView addAnnotations:annotations];
}


#pragma mark - YMap Delegate

//Annotation追加イベント
- (YMKAnnotationView*)mapView:(YMKMapView *)mapView viewForAnnotation:(MPAnnotation*)annotation
{
    //追加されたAnnotationがMyAnnotationか確認
    if( [annotation isKindOfClass:[MPAnnotation class]] ){
        //YMKPinAnnotationViewを作成
        YMKPinAnnotationView *pin = [[YMKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"Pin"];
        
        //アイコンイメージの変更
        pin.image=[UIImage imageNamed:@"pin"];
//        if (annotation.imageUrl) {
//            [AppGlobal.imageEngine imageAtURL:[NSURL URLWithString:annotation.imageUrl]
//                            completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//                                pin.image = fetchedImage;
//                            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//                            }];
//        }
        //アイコンのイメージのどこを基準点にするか設定
        CGPoint centerOffset;
        centerOffset.x=40;
        centerOffset.y=35;
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
        animationScale.fromValue = [NSNumber numberWithFloat:0.7]; // 開始時の倍率
        animationScale.toValue = [NSNumber numberWithFloat:1.0]; // 終了時の倍率
        // アニメーションを追加
        //        [pin.layer addAnimation:animationScale forKey:@"scale-layer"];
        
        // [点滅アニメーション]
        if ( ! annotation.imageUrl) {
            [pin.layer addAnimation:[self makeAnimation] forKey:@"blinkAnimation"];
        }
        
        return pin;
    }
    return nil;
}

-(void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [AppGlobal.apiEngine vacancyWithCoordinate:self.yMapView.centerCoordinate
                                  onCompletion:^(NSArray *array) {
                                      [self addAnnotationsWithVacancies:array];
                                  } onError:^(NSError *error) {
                                  }];

}


#pragma mark - animation

- (CAAnimationGroup *)makeAnimation
{
    CABasicAnimation *fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.8;
    fadeAnim.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *resizeAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    resizeAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 0.0)];
    resizeAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(5.0, 5.0, 0.0)];
    resizeAnim1.duration = fadeAnim.duration;
    resizeAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    resizeAnim1.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.animations = @[fadeAnim, resizeAnim1];
    group.duration = fadeAnim.duration;
    group.delegate = self;
    group.repeatCount = HUGE_VALF;
    [group setValue:@"showThreadCreateButtonAnimation" forKey:@"animationName"];
    
    return group;
    
}


@end
