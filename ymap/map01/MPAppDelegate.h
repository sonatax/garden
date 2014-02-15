//
//  MPAppDelegate.h
//  ymap
//
//  Created by mee on 2/15/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTFoursquareEngine.h"
#import "MPAPIEngine.h"

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

#define AppDelegate ((MPAppDelegate *)[UIApplication sharedApplication].delegate)

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FTFoursquareEngine *foursquareEngine;
@property (strong, nonatomic) MKNetworkEngine *imageEngine;
@property (strong, nonatomic) MPAPIEngine *apiEngine;

@end
