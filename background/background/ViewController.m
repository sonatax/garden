//
//  ViewController.m
//  background
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "ViewController.h"
#import "MCReceiver.h"

@interface ViewController () <MCReceiverDelegate>
@property MCReceiver *receiver;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // 受信役の起動
    _receiver = [MCReceiver new];
    _receiver.delegate = self;
    [_receiver start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// <MCReceiverDelegate> 接続できた時に呼ばれる
- (void)didConnected
{
    NSLog(@"接続成功!");
}

// <MCReceiverDelegate> 接続切れちゃった時に呼ばれる
- (void)didLostConnection
{
    NSLog(@"切れちゃった!");
}

// <MCReceiverDelegate> データが送られてきた時に呼ばれる
- (void)didReceive:(NSDictionary *)data
{
    NSLog(@"データ受信: %@", data);
    _testLabel.text = data[@"time"];
}

@end
