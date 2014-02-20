//
//  AppDelegate.h
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTFoursquareEngine.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define AppGlobal ((AppDelegate *)[UIApplication sharedApplication].delegate)

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FTFoursquareEngine *foursquareEngine;

@end
