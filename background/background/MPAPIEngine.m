//
//  MPAPIEngine.m
//  ymap
//
//  Created by mee on 2/16/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

#import "MPAPIEngine.h"
#import "XMLReader.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation MPAPIEngine

- (MKNetworkOperation *)vacancyWithCoordinate:(CLLocationCoordinate2D)coordinate
                                 onCompletion:(MPArrayResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock
{
    NSDictionary *jCoordinate = [self convertLocationGlobalToJapan:coordinate];
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSString *stayDate = [dateFormatter stringFromDate:todayDate];
    
    NSDictionary *params;
    params = @{
               @"key"        : @"ari14435603f57",
               @"x"          : jCoordinate[@"jLat"],
               @"y"          : jCoordinate[@"jLng"],
               @"range"      : @"1",
               @"order"      : @"4",
               @"stay_date"  : stayDate,
               @"stay_count" : @"1",
               @"count"      : @"50",
               };

    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"APIAdvance/StockSearch/V1/"]
                                                            params:params
                                                        httpMethod:@"GET"];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSLog(@"url:%@", [completedOperation url]);
        
        NSError *error = nil;
        NSDictionary *responseXML = [XMLReader dictionaryForXMLData:[completedOperation responseData] error:&error];
        NSInteger numberOfResults = [responseXML[@"Results"][@"NumberOfResults"][@"text"] integerValue];
        NSLog(@"numberOfResults:%ld", (long)numberOfResults);
        NSArray *results;
        if (numberOfResults > 0) {
            results = [self parseVacancyResponse:responseXML[@"Results"][@"Plan"]];
        } else {
            results = @[];
        }
        completionBlock(results);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:networkOperation];
    
    return networkOperation;
}

//- (MKNetworkOperation *)photoOnCompletion:(MPArrayResponseBlock)completionBlock
//                                  onError:(MKNKErrorBlock)errorBlock
//{
//    MKNetworkOperation *networkOperation = [self operationWithPath:[NSString stringWithFormat:@"api_photo.php"]
//                                                            params:nil
//                                                        httpMethod:@"GET"];
//    
//    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSArray *responseJSON = [completedOperation responseJSON];
//        completionBlock(responseJSON);
//        
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        errorBlock(error);
//        
//    }];
//    
//    [self enqueueOperation:networkOperation];
//    
//    return networkOperation;
//
//}

#pragma mark - Private methods

- (NSDictionary *)convertLocationGlobalToJapan:(CLLocationCoordinate2D)coordinate
{
    double jLat = coordinate.longitude * 1.000106961 - coordinate.latitude * 0.000017467 - 0.004602017;
    double jLng = coordinate.latitude * 1.000083049 + coordinate.longitude * 0.000046047 - 0.010041046;
    NSInteger jLatMs = jLat * 3600 * 1000;
    NSInteger jLngMs = jLng * 3600 * 1000;
    NSDictionary *japanCoordinate = @{
                                      @"jLat": [NSString stringWithFormat:@"%ld", (long)jLatMs],
                                      @"jLng": [NSString stringWithFormat:@"%ld", (long)jLngMs],
                                      };
    return japanCoordinate;
}

- (CLLocationCoordinate2D)convertLocationJapanToGlobal:(NSDictionary *)japanCoordinate
{
    double jLat = [japanCoordinate[@"jLat"] doubleValue] / 3600 / 1000;
    double jLng = [japanCoordinate[@"jLng"] doubleValue] / 3600 / 1000;
    double lat = jLng - jLng * 0.00010695 + jLat * 0.000017464 + 0.0046017;
    double lng = jLat - jLng * 0.000046038 - jLat * 0.000083043 + 0.010040;
    return CLLocationCoordinate2DMake(lat, lng);
}

- (NSArray *)parseVacancyResponse:(NSArray *)plans
{
    // APIのレスポンスによって落ちる時があるので保留..
    if ([plans count] == 0) {
        return @[];
    }
    NSMutableArray *parsedPlans = [@[] mutableCopy];
    for (NSDictionary *plan in plans) {
        NSDictionary *jCoordinate = @{
                                      @"jLat" : plan[@"Hotel"][@"X"][@"text"],
                                      @"jLng" : plan[@"Hotel"][@"Y"][@"text"],
                                      };
        CLLocationCoordinate2D coordinate = [self convertLocationJapanToGlobal:jCoordinate];
        if (plan[@"Hotel"][@"HotelName"][@"text"] == nil
            || plan[@"Stay"][@"Date"][@"Stock"][@"text"] == nil) {
            continue;
        }
        [parsedPlans addObject:@{
                                 @"Name"  : plan[@"Hotel"][@"HotelName"][@"text"],
                                 @"Stock" : plan[@"Stay"][@"Date"][@"Stock"][@"text"],
                                 @"Lat"   : [NSString stringWithFormat:@"%f", coordinate.latitude],
                                 @"Lon"   : [NSString stringWithFormat:@"%f", coordinate.longitude],
                                 }];
    }
    return parsedPlans;

}

@end
