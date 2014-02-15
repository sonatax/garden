//
//  FTFoursquareVenuesExplore.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTFoursquareVenuesExplore : NSObject

// /
@property (nonatomic, copy)   NSString  *code;               // "200" https://developer.foursquare.com/overview/responses
@property (nonatomic, assign) NSInteger numResults;          // 50

// /response/
@property (nonatomic, copy)   NSString  *headerLocation;     // "Nakano"
@property (nonatomic, copy)   NSString  *headerFullLocation; // "Nakano, Tokyo"
@property (nonatomic, assign) NSInteger totalResults;        // 135
@property (nonatomic, copy)   NSArray   *venues;             // FTFoursquareVenue
// /response/warning
@property (nonatomic, copy)   NSString *warningText;         // "There aren't a lot of results near you. Try something more general, reset your filters, or expand the search area."

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
