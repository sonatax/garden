//
//  FTFoursquarePhoto.h
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTFoursquarePhoto : NSObject

@property (nonatomic, copy)   NSString *id;      // "51aab5dc498e9833ee0a2ec9"
@property (nonatomic, strong) NSDate *createdAt; // 1370142172
@property (nonatomic, copy)   NSString *prefix;  // "https://irs1.4sqi.net/img/general/"
@property (nonatomic, copy)   NSString *suffix;  // "/29893864_Td7BiIn1BNt2bRweBfpd4S4ZFKI0ON3Z9CR1Stjx0M8.jpg"
@property (nonatomic, assign) NSInteger width;   // 720
@property (nonatomic, assign) NSInteger height;  // 960

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)photoUrlWithWidth:(NSInteger)width andHeight:(NSInteger)height;

@end
