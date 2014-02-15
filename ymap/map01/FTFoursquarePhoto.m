//
//  FTFoursquarePhoto.m
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "FTFoursquarePhoto.h"

@implementation FTFoursquarePhoto

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id             = dictionary[@"id"];
        self.createdAt      = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"createdAt"] integerValue]];
        self.prefix         = dictionary[@"prefix"];
        self.suffix         = dictionary[@"suffix"];
        self.width          = [dictionary[@"width"] integerValue];
        self.height         = [dictionary[@"height"] integerValue];
    }
    return self;
}

- (NSString *)photoUrlWithWidth:(NSInteger)width andHeight:(NSInteger)height
{
    return [NSString stringWithFormat:@"%@%ldx%ld%@", self.prefix, (long)width, (long)height, self.suffix];
}

@end
