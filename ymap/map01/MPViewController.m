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
#import "FTFoursquareEngine.h"

@interface MPViewController ()

@property (nonatomic, strong) YMKMapView *yMapView;

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // [Map]
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
    // [地図の反転]
    self.yMapView.transform = CGAffineTransformScale(self.yMapView.transform, -1, 1);

    
    
    // スポット
//    [AppDelegate.foursquareEngine venuesExploreWithCoordinate:currentCoordinate
//                                                    andRadius:2000
//                                                 onCompletion:^(FTFoursquareVenuesExplore *foursquareVenuesExplore) {
//                                                     [self addAnnotationsWithVenues:foursquareVenuesExplore.venues];
//                                                 } onError:^(NSError *error) {
//                                                 }];
    // 空き室
    [AppDelegate.apiEngine vacancyWithCoordinate:currentCoordinate
                                    onCompletion:^(NSArray *array) {
                                        [self addAnnotationsWithVacancies:array];
                                    } onError:^(NSError *error) {
                                    }];
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
        pin.image=[UIImage imageNamed:@"pin"];
//        NSString *imageUrl = [annotation.foursquareVenue.foursquarePhoto photoUrlWithWidth:30 andHeight:30];
//        [AppDelegate.imageEngine imageAtURL:[NSURL URLWithString:imageUrl]
//                          completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//                              pin.image = fetchedImage;
//                          } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//                          }];
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
        [pin.layer addAnimation:[self makeAnimation] forKey:@"blinkAnimation"];
        
        // 丸に切りぬく
//        pin.layer.cornerRadius = 10;
//        pin.layer.masksToBounds = YES;
        
        return pin;
    }
    return nil;
}


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

- (void)addAnnotationsWithVenues:(NSArray *)venues
{
    for (FTFoursquareVenue *venue in venues) {
        // [Pin]
        //アイコンの緯度経度を設定
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(venue.foursquareLocation.lat, venue.foursquareLocation.lng);
        //MyAnnotationの初期化
        MPAnnotation *myAnnotation = [[MPAnnotation alloc] initWithLocationCoordinate:coordinate title:venue.name subtitle:venue.foursquareLocation.address];
        myAnnotation.foursquareVenue = venue;
        //AnnotationをYMKMapViewに追加
        [self.yMapView addAnnotation:myAnnotation];

    }
    

}

- (void)addAnnotationsWithVacancies:(NSArray *)vacancies
{
    NSMutableArray *annotations = [@[] mutableCopy];
    for (NSDictionary *vacancy in vacancies) {
        //アイコンの緯度経度を設定
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([vacancy[@"Lat"] floatValue], [vacancy[@"Lon"] floatValue]);
        //MyAnnotationの初期化
        MPAnnotation *myAnnotation = [[MPAnnotation alloc] initWithLocationCoordinate:coordinate title:vacancy[@"Stock"] subtitle:nil];
        [annotations addObject:myAnnotation];
    }
    [self.yMapView addAnnotations:annotations];
}


@end
