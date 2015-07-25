//
//  SearchResultViewController.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MGMapAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface SearchResultViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* _mapAnnotations;
    MGMapAnnotation* _currentAnnotation;
    CLLocation *_centerLocation;

    AppDelegate *_appDelegate;
}

@property (strong, nonatomic) NSDictionary *m_Results;
@property (strong, nonatomic) NSString *m_businessType;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBusinessType;
@property (weak, nonatomic) IBOutlet MKMapView *m_mapView;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

- (IBAction)actionBack:(id)sender;

@end
