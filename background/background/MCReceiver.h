//
//  MCReceive.h
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCReceiver : NSObject  <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>
@property MCSession                 *mcSession;    // セッション管理
@property MCNearbyServiceAdvertiser *mcAdvertiser; // 発見してもらうための道具
- (void)start;
- (void)stop;
@end
