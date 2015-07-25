//
//  YelpAPIService.m
//  YelpNearby
//
//  Created by Behera, Subhransu on 8/14/13.
//  Copyright (c) 2013 Behera, Subhransu. All rights reserved.
//

#import "YelpAPIService.h"
#import "OAuthAPIConstants.h"
#import "Restaurant.h"
#import <UIKit/UIKit.h>

#define SEARCH_RESULT_LIMIT 10

@implementation YelpAPIService

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&ll=%f,%f",
                           YELP_SEARCH_URL,
                           @"restaurants",
                           categoryFilter,
                           latitude, longitude];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

- (void)searchNearbyBusinessesFromLocationByTerm:(NSString *)term category:(NSString *)category radius:(double)radius atLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&radius_filter=%@&ll=%f,%f",
                           YELP_SEARCH_URL,
                           @"",
                           category,
                           [NSString stringWithFormat:@"%f", radius],
                           latitude, longitude];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

- (void)searchNearbyBusinessesByTerm:(NSString *)term category:(NSString *)category radius:(double)radius location:(NSString *)location {

    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&radius_filter=%@&location=%@",
                           YELP_SEARCH_URL,
                           @"",
                           category,
                           [NSString stringWithFormat:@"%f", radius],
                           location];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

-(void)fetchBusinessInfo:(NSString *)businessID {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",
                           YELP_BUSINESS_URL,
                           businessID];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.urlRespondData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.urlRespondData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Failed to connect to Yelp server"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    [self.delegate failedConnection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    
    NSDictionary *resultResponseDict = [NSJSONSerialization JSONObjectWithData:self.urlRespondData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&e];
    if (self.resultDictionary) {
        [self.resultDictionary removeAllObjects];
    }
    
    if (!self.resultDictionary) {
        self.resultDictionary = [[NSMutableDictionary alloc] init];
    }
    
    self.resultDictionary = [resultResponseDict mutableCopy];
    [self.delegate loadResultWithDataDictionary:self.resultDictionary];
}



@end
