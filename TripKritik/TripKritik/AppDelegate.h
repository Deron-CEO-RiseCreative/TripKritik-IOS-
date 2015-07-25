//
//  AppDelegate.h
//  TripKritik
//
//  Created by youandme on 11/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    CLLocationManager* _myLocationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation* m_myLocation;

@end

