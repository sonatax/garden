//
//  TileView.m
//  overlay
//
//  Created by nori on 2014/02/15.
//  Copyright (c) 2014年 -. All rights reserved.
//

#import "TileView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSString *fileName = @"200.png";
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
	[image drawInRect:rect];
}


+ (Class)layerClass {
    return [CATiledLayer class];
}

- (CATiledLayer *)tiledLayer {
    return (CATiledLayer *)self.layer;
}

- (void)layoutSubviews {
    if ([self respondsToSelector:@selector(contentScaleFactor)]) {
        self.contentScaleFactor = 1.0f;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self setNeedsDisplay];
    return NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self;
}


@end
