//
//  FTFoursquareCategory.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTFoursquareCategory : NSObject

@property (nonatomic, copy)   NSString *id;         // "4d954b0ea243a5684a65b473"
@property (nonatomic, copy)   NSString *name;       // "Convenience Store"
@property (nonatomic, assign) BOOL primary;         // true
// icon/
@property (nonatomic, copy)   NSString *iconPrefix; // "https://ss1.4sqi.net/img/categories_v2/shops/conveniencestore_"
@property (nonatomic, copy)   NSString *iconSuffix; // ".png"

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
