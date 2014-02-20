//
//  FTFoursquareLocation.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquareLocation.h"

@implementation FTFoursquareLocation

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.lat        = [dictionary[@"lat"] doubleValue];
        self.lng        = [dictionary[@"lng"] doubleValue];
        self.distance   = [dictionary[@"distance"] integerValue];
        self.postalCode = dictionary[@"postalCode"];
        self.country    = dictionary[@"country"];
        self.city       = dictionary[@"city"];
        self.state      = dictionary[@"state"];
        self.address    = dictionary[@"address"];
    }
    return self;
}

@end
