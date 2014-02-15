//
//  FTFoursquareLocation.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTFoursquareLocation : NSObject

@property (nonatomic, assign) double lat;           // 35.69173646454567
@property (nonatomic, assign) double lng;           // 139.6781442324413
@property (nonatomic, assign) NSInteger distance;   // 141
@property (nonatomic, copy)   NSString *postalCode; // "164-0013"
@property (nonatomic, copy)   NSString *country;    // "Japan"
@property (nonatomic, copy)   NSString *city;       // "Nakano"
@property (nonatomic, copy)   NSString *state;      // "Tōkyō-to"
@property (nonatomic, copy)   NSString *address;    // "弥生町1-28-8"

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
