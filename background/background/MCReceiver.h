//
//  MCReceive.h
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol MCReceiverDelegate <NSObject>
@optional
- (void)didStart;
- (void)didStop;
- (void)didConnected;
- (void)didLostConnection;
- (void)didReceive:(NSDictionary *)data;
//- (void)didChangeConnectedPeers:(NSArray *)peers;
@end


@interface MCReceiver : NSObject  <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>
@property id <MCReceiverDelegate> delegate;
@property MCSession                 *mcSession;    // セッション管理
@property MCNearbyServiceAdvertiser *mcAdvertiser; // 発見してもらうための道具
- (void)start;
- (void)stop;
@end
