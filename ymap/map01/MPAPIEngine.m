//
//  MPAPIEngine.m
//  ymap
//
//  Created by mee on 2/16/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MPAPIEngine.h"

@implementation MPAPIEngine

- (MKNetworkOperation *)vacancyWithCoordinate:(CLLocationCoordinate2D)coordinate
                                 onCompletion:(MPArrayResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock
{
    NSDictionary *params;
    params = @{
               @"lat" : [NSString stringWithFormat:@"%f", coordinate.latitude],
               @"lon" : [NSString stringWithFormat:@"%f", coordinate.longitude],
               };
    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"api_empty.php"]
                                                            params:params
                                                        httpMethod:@"GET"];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *responseJSON = [completedOperation responseJSON];
        completionBlock(responseJSON);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:networkOperation];
    
    return networkOperation;
}

@end
