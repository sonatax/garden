//
//  FTFoursquareEngine.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MKNetworkEngine.h"
#import <CoreLocation/CoreLocation.h>
#import "FTFoursquareVenuesExplore.h"
#import "FTFoursquareVenue.h"

typedef void (^FTArrayResponseBlock)(NSArray *array);
typedef void (^FTFoursquareVenuesExploreResponseBlock)(FTFoursquareVenuesExplore *foursquareVenuesExplore);
typedef void (^FTFoursquareVenueResponseBlock)(FTFoursquareVenue *foursquareVenue);

@interface FTFoursquareEngine : MKNetworkEngine

- (MKNetworkOperation *)venuesExploreWithCoordinate:(CLLocationCoordinate2D)coordinate
                                          andRadius:(NSInteger)radius
                                       onCompletion:(FTFoursquareVenuesExploreResponseBlock)completionBlock
                                            onError:(MKNKErrorBlock)errorBlock;
- (MKNetworkOperation *)venuesWithVenueId:(NSString *)venueId
                             onCompletion:(FTFoursquareVenueResponseBlock)completionBlock
                                  onError:(MKNKErrorBlock)errorBlock;
//- (MKNetworkOperation *)venuesPhotosWithVenueId:(NSString *)venueId
//                                       andLimit:(NSInteger)limit
//                                   onCompletion:(FTArrayResponseBlock)completionBlock
//                                        onError:(MKNKErrorBlock)errorBlock;

@end