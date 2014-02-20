//
//  FTFoursquareVenuesExplore.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquareVenuesExplore.h"
#import "FTFoursquareVenue.h"

@implementation FTFoursquareVenuesExplore

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *response  = dictionary[@"response"];
        self.code               = dictionary[@"meta"][@"code"];
        self.numResults         = [dictionary[@"numResults"] integerValue];
        self.headerLocation     = response[@"headerLocation"];
        self.headerFullLocation = response[@"headerFullLocation"];
        self.totalResults       = [response[@"totalResults"] integerValue];
        self.warningText        = response[@"warning"][@"text"];
        if ([response[@"groups"] count] > 0) {
            self.venues         = [self parseVenuesResponse:response[@"groups"][0][@"items"]];
        }
    }
    return self;
}

#pragma mark - Private methods

- (NSArray *)parseVenuesResponse:(NSArray *)array
{
    NSMutableArray *venuesArray = [@[] mutableCopy];
    for (NSDictionary *dictionary in array) {
        FTFoursquareVenue *foursquareVenue = [[FTFoursquareVenue alloc] initWithDictionary:dictionary[@"venue"]];
        [venuesArray addObject:foursquareVenue];
    }
    return venuesArray;
}

@end
