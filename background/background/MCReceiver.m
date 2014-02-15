//
//  MCReceive.m
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//
// コネクション確立まで：　通知だけする。見つけてもらう。(MCNearbyServiceAdvertiser)
// コネクション確立後：　データ受け取るだけの役目
//

#import "MCReceiver.h"

@implementation MCReceiver

- (void)start {
    NSString *serviceName = @"ofuton";
    NSString *displayName = [UIDevice currentDevice].name;

    // セッションIDとセッションを作成（ポイント:起動のたびに作りなおす）
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _mcSession = [[MCSession alloc] initWithPeer:myPeerID];
    _mcSession.delegate = self;
    
    // 配信開始
    _mcAdvertiser = [[MCNearbyServiceAdvertiser alloc]
                     initWithPeer:myPeerID
                     discoveryInfo:nil
                     serviceType:serviceName];
    _mcAdvertiser.delegate = self;
    [_mcAdvertiser startAdvertisingPeer];
    
    // delegateに、起動したよ通知
    if ([self.delegate respondsToSelector:@selector(didStart)]) {
        [self.delegate didStart];
    }
}

- (void)stop {
    [_mcAdvertiser stopAdvertisingPeer];
    [_mcSession disconnect];
    _mcAdvertiser = nil;
    _mcSession    = nil;
    
    // delegateに、終了したよ通知
    if ([self.delegate respondsToSelector:@selector(didStop)]) {
        [self.delegate didStop];
    }
}

#pragma mark - MCNearbyServiceAdvertiser（他者から見つけてもらうための道具）

// 相手のBrowserから接続要求が来たとき
- (void)           advertiser:(MCNearbyServiceAdvertiser *)advertiser
 didReceiveInvitationFromPeer:(MCPeerID *)peerID
                  withContext:(NSData *)context
            invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    // あとはsessionにおまかせ。接続要求を受け入れる
    invitationHandler(YES, _mcSession);
    NSLog(@"接続要求がきたので受け入れます : %@", peerID);
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
            // delegateに、つながったよ通知
            if ([self.delegate respondsToSelector:@selector(didConnected)]) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.delegate didConnected];
                });
            }
			break;
        case MCSessionStateNotConnected:
            NSLog(@"切断完了 : %@", peerID.displayName);
            // delegateに、切れちゃったよ通知
            if ([self.delegate respondsToSelector:@selector(didLostConnection)]) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.delegate didLostConnection];
                });
            }
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
    NSMutableDictionary *params = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%s %@から受信 : %@", __PRETTY_FUNCTION__, peerID.displayName, params); 

    // delegateに、なんかデータが届いたよ通知
    // ここのコール元が別スレッドのようで、通知先でのUI更新などに数秒規模のタイムラグが発生する。回避策として、メインスレッドに対して通知。
    if ([self.delegate respondsToSelector:@selector(didReceive:)]) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.delegate didReceive:params];
        });

    }
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
