//
//  TileView.h
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView <UIScrollViewDelegate> {
	CATiledLayer *tiledLayer;
}

@property (nonatomic, readonly) CATiledLayer *tiledLayer;

@end


