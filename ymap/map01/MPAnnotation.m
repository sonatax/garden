//
//  MPAnnotation.m
//  ymap
//
//  Created by mee on 2/15/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MPAnnotation.h"
#import <YMapKit/YMapKit.h>

@implementation MPAnnotation

//初期化処理
- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord
                           title:(NSString *)annTitle subtitle:(NSString *)annSubtitle {
    if (self=[super init]) {
        _coordinate.latitude = coord.latitude;
        _coordinate.longitude = coord.longitude;
        _annotationTitle = annTitle;
        _annotationSubtitle = annSubtitle;
    }
    return self;
}

//タイトル
- (NSString *)title
{
    return _annotationTitle;
}

//サブタイトル
- (NSString *)subtitle
{
    return _annotationSubtitle;
}

@end
