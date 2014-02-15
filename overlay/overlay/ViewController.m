//
//  ViewController.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

//  六本木 35.666 139.731


#import "ViewController.h"
#import "MCSender.h"
#import "TileView.h"

@interface ViewController () <MCSenderDelegate, UIScrollViewDelegate>

@property MCSender *sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property TileView *tile;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 送信役の起動
    _sender = [MCSender new];
    _sender.delegate = self;
    [_sender start];

    // タイル生成 ここ参考にさせていただいた http://d.hatena.ne.jp/KishikawaKatsumi/20090429/1241020420
    _tile = [[TileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 3000.0f, 3000.0f)]; // 全体サイズ
	_tile.tiledLayer.tileSize = CGSizeMake(200.0f, 200.0f); // タイルサイズ
	_tile.tiledLayer.levelsOfDetail = 1;
	_tile.tiledLayer.levelsOfDetailBias = 0;

    _scrollView.delegate = self;
    [_scrollView addSubview:_tile];
    _scrollView.contentSize = _tile.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - MCSenderDelegate

// <MCSenderDelegate> 接続できた時に呼ばれる
- (void)didConnected
{
    NSLog(@"接続成功!");
}

// <MCSenderDelegate> 接続切れちゃった時に呼ばれる
- (void)didLostConnection
{
    NSLog(@"切れちゃった!");
}



- (IBAction)testButton:(id)sender {
    //NSDate *date = [NSDate date];
    //NSDateFormatter *formatter = [NSDateFormatter new];
    //formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //NSString *dateString = [formatter stringFromDate:date];
    
    // 相手に何か送るのは、sendに投げるだけ
    [_sender send:@{
                    @"lat":@"latです",
                    @"lon":@"lonです",
                    @"span":@"spanです",
                    }];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/*
 
 - (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
 - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2); // called before the scroll view begins zooming its content
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
 
 - (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
 - (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;      // called when scrolling animation finished. may be called immediately if already at top

 */

@end
