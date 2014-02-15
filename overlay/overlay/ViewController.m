//
//  ViewController.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "ViewController.h"
#import "MCSender.h"

@interface ViewController ()
@property MCSender *sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _sender = [MCSender new];
//    _sender.delegate = self;
    [_sender start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
