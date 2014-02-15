//
//  MPAPIEngine.h
//  ymap
//
//  Created by mee on 2/16/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^MPArrayResponseBlock)(NSArray *array);

@interface MPAPIEngine : MKNetworkEngine

- (MKNetworkOperation *)vacancyWithCoordinate:(CLLocationCoordinate2D)coordinate
                                 onCompletion:(MPArrayResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock;

@end
