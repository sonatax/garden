//
//  FTFoursquareVenue.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTFoursquareLocation.h"
#import "FTFoursquareCategory.h"
#import "FTFoursquarePhoto.h"

@interface FTFoursquareVenue : NSObject

// /
@property (nonatomic, copy) NSString *id; // "4c917e8651d9b1f7b3578146"
@property (nonatomic, copy) NSString *name; // "サンクス 中野弥生町店"
// stats/
@property (nonatomic, assign) NSInteger checkinsCount; // 220
// location/
@property (nonatomic, strong) FTFoursquareLocation *foursquareLocation;
// categories/
@property (nonatomic, strong) FTFoursquareCategory *foursquareCategory;
// photos/count/
@property (nonatomic, assign) NSInteger photosCount;
// photos/groups/0/items/0/
@property (nonatomic, strong) FTFoursquarePhoto *foursquarePhoto;
// photos by /venues/VENUE_ID/photos API
@property (nonatomic, retain) NSMutableArray *photos;

@property (nonatomic, assign) BOOL isLoaded;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
