//
//  FTFoursquareVenue.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquareVenue.h"

@implementation FTFoursquareVenue

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id            = dictionary[@"id"];
        self.name          = dictionary[@"name"];
        self.checkinsCount = [dictionary[@"stats"][@"checkinsCount"] integerValue];
        self.foursquareLocation = [[FTFoursquareLocation alloc] initWithDictionary:dictionary[@"location"]];
        self.photosCount = [dictionary[@"photos"][@"count"] integerValue];
        
        if ([dictionary[@"categories"] count] > 0) {
            self.foursquareCategory = [[FTFoursquareCategory alloc] initWithDictionary:dictionary[@"categories"][0]];
        }
        if (self.photosCount > 0
            && [dictionary[@"photos"][@"groups"] count] > 0
            && [dictionary[@"photos"][@"groups"][0][@"items"] count] > 0) {
            
            self.foursquarePhoto = [[FTFoursquarePhoto alloc] initWithDictionary:dictionary[@"photos"][@"groups"][0][@"items"][0]];
            self.photos          = [NSMutableArray arrayWithObject:self.foursquarePhoto];
        }
        
    }
    return self;
}

@end
