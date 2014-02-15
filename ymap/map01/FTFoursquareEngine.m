//
//  FTFoursquareEngine.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquareEngine.h"
#import "FTFoursquareVenuesExplore.h"
//#import "FTFoursquareVenuesPhotos.h"

#define kFTFoursquareClientId     @"1YPFBZYCKOW525RK2NFW5LYSEB0RGP2ROOS4ENYMK0AVWSII"
#define kFTFoursquareClientSecret @"EOZYGZRYWOJW4J32QZUHPVJZ4G4Z00MIIY5WKU0TDYBETSGK"

@implementation FTFoursquareEngine

- (MKNetworkOperation *)venuesExploreWithCoordinate:(CLLocationCoordinate2D)coordinate
                                          andRadius:(NSInteger)radius
                                       onCompletion:(FTFoursquareVenuesExploreResponseBlock)completionBlock
                                            onError:(MKNKErrorBlock)errorBlock
{
    // midtown
//    coordinate = CLLocationCoordinate2DMake(35.6657248, 139.7310081);
    // sakou
//    coordinate = CLLocationCoordinate2DMake(35.6643283, 139.7285264);
    // gree
//    coordinate = CLLocationCoordinate2DMake(35.6603991, 139.7290403);
    // cookpad
//    coordinate = CLLocationCoordinate2DMake(35.639725, 139.72213);
    // newyork
//    coordinate = CLLocationCoordinate2DMake(40.7242309, -74.0014815);
    // manhattan
//    coordinate = CLLocationCoordinate2DMake(40.7590615, -73.969231);
    
    NSString *ll = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    NSDictionary *params;
    params = @{
               @"client_id"      : kFTFoursquareClientId,
               @"client_secret"  : kFTFoursquareClientSecret,
               @"v"              : @"20140215",
               @"ll"             : ll,
               @"radius"         : [NSString stringWithFormat:@"%ld", (long)radius],
               @"venuePhotos"    : @"1",
               @"sortByDistance" : @"1",
               @"limit"          : @"50",
            };
    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"v2/venues/explore"]
                                                            params:params
                                                        httpMethod:@"GET"];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseJSON = [completedOperation responseJSON];
        
        FTFoursquareVenuesExplore *venuesExplore = [[FTFoursquareVenuesExplore alloc] initWithDictionary:responseJSON];
        completionBlock(venuesExplore);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:networkOperation];
    
    return networkOperation;
}

- (MKNetworkOperation *)venuesWithVenueId:(NSString *)venueId
                             onCompletion:(FTFoursquareVenueResponseBlock)completionBlock
                                  onError:(MKNKErrorBlock)errorBlock
{
    NSDictionary *params;
    params = @{
               @"client_id"      : kFTFoursquareClientId,
               @"client_secret"  : kFTFoursquareClientSecret,
               @"v"              : @"20140215",
               };
    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"v2/venues/%@", venueId]
                                                            params:params
                                                        httpMethod:@"GET"];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseJSON = [completedOperation responseJSON];
        FTFoursquareVenue *venues = [[FTFoursquareVenue alloc] initWithDictionary:responseJSON];
        completionBlock(venues);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:networkOperation];
    
    return networkOperation;
}

//- (MKNetworkOperation *)venuesPhotosWithVenueId:(NSString *)venueId
//                                       andLimit:(NSInteger)limit
//                                   onCompletion:(FTArrayResponseBlock)completionBlock
//                                        onError:(MKNKErrorBlock)errorBlock
//{
//    NSDictionary *params;
//    params = @{
//               @"client_id"      : kFTFoursquareClientId,
//               @"client_secret"  : kFTFoursquareClientSecret,
//               @"v"              : @"20140215",
//               @"limit"          : [NSString stringWithFormat:@"%ld", (long)limit],
//               };
//    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"v2/venues/%@/photos", venueId]
//                                                            params:params
//                                                        httpMethod:@"GET"];
//    
//    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSDictionary *responseJSON = [completedOperation responseJSON];
//        FTFoursquareVenuesPhotos *venuesPhotos = [[FTFoursquareVenuesPhotos alloc] initWithDictionary:responseJSON];
//        
//        completionBlock(venuesPhotos.photos);
//        
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        errorBlock(error);
//        
//    }];
//    
//    [self enqueueOperation:networkOperation];
//    
//    return networkOperation;
//}

@end
