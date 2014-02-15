//
//  MCSend.h
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCSender : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>
@property MCSession                 *mcSession;    // セッション管理
@property MCNearbyServiceBrowser    *mcBrowser;    // 周辺を探すための道具
- (void)start;
- (void)stop;
- (void)send:(NSDictionary *)params;
@end
