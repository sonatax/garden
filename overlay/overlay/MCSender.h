//
//  MCSend.h
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

// 利用元に用意してもらうDelegate
@protocol MCSenderDelegate <NSObject>
@optional
- (void)didStart;
- (void)didStop;
- (void)didConnected;
- (void)didLostConnection;
//- (void)didChangeConnectedPeers:(NSArray *)peers;
@end

@interface MCSender : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate>
@property id <MCSenderDelegate> delegate;
@property MCSession                 *mcSession;    // セッション管理
@property MCNearbyServiceBrowser    *mcBrowser;    // 周辺を探すための道具
- (void)start;
- (void)stop;
- (void)send:(NSDictionary *)params;
@end
