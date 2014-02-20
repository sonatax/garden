//
//  FTFoursquareCategory.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquareCategory.h"

@implementation FTFoursquareCategory

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *icon = dictionary[@"icon"];
        self.id            = dictionary[@"id"];
        self.name          = dictionary[@"name"];
        self.primary       = [dictionary[@"primary"] boolValue];
        self.iconPrefix    = icon[@"prefix"];
        self.iconSuffix    = icon[@"suffix"];
    }
    return self;
}

@end
