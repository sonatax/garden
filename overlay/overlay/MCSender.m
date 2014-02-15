//
//  MCSend.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//
// コネクション確立まで：　探す側に徹する(MCNearbyServiceBrowser)
// コネクション確立後：　データ送るだけの役目
//

#import "MCSender.h"


@implementation MCSender

- (void)start {
    NSString *serviceName = @"ofuton";
    NSString *displayName = [UIDevice currentDevice].name;
    
    // セッションIDとセッションを作成（ポイント:起動のたびに作りなおす）
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _mcSession = [[MCSession alloc] initWithPeer:myPeerID];
    _mcSession.delegate = self;
    
    // 検索を開始
    _mcBrowser = [[MCNearbyServiceBrowser alloc]
                  initWithPeer:myPeerID
                  serviceType:serviceName];
    _mcBrowser.delegate = self;
    [_mcBrowser startBrowsingForPeers];
    
    // delegateに通知
//    if ([self.delegate respondsToSelector:@selector(didStart)]) {
//        [self.delegate didStart];
//    }
}

- (void)stop {
    [_mcBrowser stopBrowsingForPeers];
    [_mcSession disconnect];
    _mcBrowser    = nil;
    _mcSession    = nil;
    
    // delegateに通知
//    if ([self.delegate respondsToSelector:@selector(didStop)]) {
//        [self.delegate didStop];
//    }
}

- (void)send:(NSDictionary *)params;
{
    [_mcSession sendData:[NSKeyedArchiver archivedDataWithRootObject:params]
                 toPeers:_mcSession.connectedPeers    // 接続中の相手全てに対して送る
//              withMode:MCSessionSendDataReliable    // キューに登録し確実に届くモード
                withMode:MCSessionSendDataUnreliable  // 即時、ただし確実に届くとは限らないモード
                   error:nil];
}



#pragma mark - MCNearbyServiceBrowser（他者を探すための道具）

// スキャンの結果、発見したとき
- (void)   browser:(MCNearbyServiceBrowser *)browser
         foundPeer:(MCPeerID *)peerID
 withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"こちらから接続要求だします: %@", peerID);
    [_mcBrowser invitePeer:peerID
                 toSession:_mcSession
               withContext:nil
                   timeout:15];
    
}

// 切断後、さらに完全に見失ったと判断されたとき？(切断から数秒後に呼ばれる）
- (void)browser:(MCNearbyServiceBrowser *)browser
       lostPeer:(MCPeerID *)peerID
{
}

#pragma mark - MCSessionDelegate

// 接続状態に変化があったとき
- (void)session:(MCSession *)session
           peer:(MCPeerID *)peerID
 didChangeState:(MCSessionState)state
{
    switch ((int)state)
	{
        case MCSessionStateConnecting:
            break;
        case MCSessionStateConnected:
            NSLog(@"接続完了 : %@", peerID.displayName);
			break;
        case MCSessionStateNotConnected:
            NSLog(@"切断完了 : %@", peerID.displayName);
			break;
        default:
            NSLog(@"その他(state=%d) : %@", (int)state, peerID.displayName);
			break;
    }
}

// 接続相手からデータを受け取ったとき
- (void)session:(MCSession *)session
 didReceiveData:(NSData *)data
       fromPeer:(MCPeerID *)peerID
{
    // nothing to do
}

// 接続相手からデータを受け取ったとき
- (void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
       withName:(NSString *)streamName
       fromPeer:(MCPeerID *)peerID
{
    // nothing to do
}

// 接続相手からデータを受け取ったとき
- (void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
   withProgress:(NSProgress *)progress
{
    // nothing to do
}

// 接続相手からデータを受け取ったとき
- (void)session:(MCSession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
          atURL:(NSURL *)localURL
      withError:(NSError *)error
{
    // nothing to do
}





@end
