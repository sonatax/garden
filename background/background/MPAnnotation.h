//
//  MPAnnotation.h
//  ymap
//
//  Created by mee on 2/15/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <YMapKit/YMapKit.h>
#import <Foundation/Foundation.h>

@interface MPAnnotation : NSObject <YMKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubtitle;
@property (nonatomic, retain) NSString *imageUrl;

- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord
                           title:(NSString *)annTitle subtitle:(NSString *)annSubtitle;
- (NSString *)title;
- (NSString *)subtitle;

@end
