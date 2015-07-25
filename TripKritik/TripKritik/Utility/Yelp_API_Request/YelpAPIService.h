//
//  YelpAPIService.h
//  YelpNearby
//
//  Created by Behera, Subhransu on 8/14/13.
//  Copyright (c) 2013 Behera, Subhransu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import <CoreLocation/CoreLocation.h>

@protocol YelpAPIServiceDelegate <NSObject>
- (void)loadResultWithDataDictionary:(NSDictionary *)resultDictionary;
- (void)failedConnection;
@end

@interface YelpAPIService : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *urlRespondData;
@property(nonatomic, strong) NSString *responseString;
@property(nonatomic, strong) NSMutableDictionary *resultDictionary;

@property (weak, nonatomic) id <YelpAPIServiceDelegate> delegate;

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude;
- (void)searchNearbyBusinessesFromLocationByTerm:(NSString *)term category:(NSString *)category radius:(double)radius atLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
- (void)searchNearbyBusinessesByTerm:(NSString *)term category:(NSString *)category radius:(double)radius location:(NSString *)location;
-(void)fetchBusinessInfo:(NSString *)businessID;

@end
