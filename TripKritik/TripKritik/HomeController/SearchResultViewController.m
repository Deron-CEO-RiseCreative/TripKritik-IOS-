//
//  SearchResultViewController.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Define.h"
#import "SearchResultCell.h"
#import "ReviewsViewController.h"

static CGFloat kLeftMargin = 0;
static CGFloat kRightMargin = 0;

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadPlacesToMap];
    self.m_lblBusinessType.text = self.m_businessType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.m_Results objectForKey:@"businesses"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.m_lblNumber.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row + 1)];
    cell.m_lblName.text = [[[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row] objectForKey:@"name"];

    NSString *address = @"";
    for (NSString *addr in [[[[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"display_address"]) {
        address = [NSString stringWithFormat:@"%@ %@", address, addr];
    }
    cell.m_lblStreet.text = address;
    
    cell.m_lblPhoneNumber.text = [[[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row] objectForKey:@"display_phone"];
    cell.m_lblWebsite.text = @"";
    
    double longi = [[[[[[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
    double lati = [[[[[[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
    CLLocation *businessLocation = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    CLLocationDistance distance = [_centerLocation distanceFromLocation:businessLocation] * 0.000621371;
    cell.m_lblMileFrom.text = [NSString stringWithFormat:@"%.2f miles", distance];
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - MKMapView Delegate
-(MKAnnotationView*) mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MGMapAnnotation class]]) {
        
        static NSString* identifier = @"MapAnnotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //annotationView.pinColor = MKPinAnnotationColorRed;
        //annotationView.animatesDrop = YES;
        
        annotationView.image = [UIImage imageNamed:@"annotation.png"];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage* imageAnnotation = [UIImage imageNamed:@"map_arrow_right.png"];
        [imageView setImage:imageAnnotation];
        
        imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
        annotationView.rightCalloutAccessoryView = imageView;
        
        UITapGestureRecognizer* tap = nil;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(didTapRightAccesoryButton:)];
        tap.numberOfTapsRequired = 1;
        tap.cancelsTouchesInView = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [annotationView.rightCalloutAccessoryView addGestureRecognizer:tap];
        [annotationView addSubview:[self makeiOSLabel:[NSString stringWithFormat:@"%d", (int)((MGMapAnnotation *)annotation).index] annoFrame:annotationView.frame]];
        
        return annotationView;
    }
    
    return nil;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MGMapAnnotation* mapAnnotation = view.annotation;
    
    _currentAnnotation = mapAnnotation;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
}

-(void)didTapAccesoryButton:(UITapGestureRecognizer *)gesture {
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor colorWithRed:14.0f/255.0f green:115.0f/255.0f blue:51.0f/255.0f alpha:0.6];
    circleView.lineWidth = 15.0;
    //    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
    return circleView;
}

- (UILabel *)makeiOSLabel:(NSString *)placeLabel annoFrame:(CGRect)annoFrame {
    // add the annotation's label
    UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    annotationLabel.font = [UIFont systemFontOfSize:12.0];
    annotationLabel.textColor = [UIColor blackColor];
    annotationLabel.backgroundColor = [UIColor redColor];
    annotationLabel.text = placeLabel;
    [annotationLabel sizeToFit];   // get the right vertical size
    
    annotationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    annotationLabel.backgroundColor = [UIColor clearColor];
    [annotationLabel setCenter:(CGPointMake(0.5, 0.5))];
    CGRect newFrame = annotationLabel.frame;
    newFrame.origin.x = newFrame.origin.x + annoFrame.size.width/2;
    newFrame.origin.y = newFrame.origin.y + annoFrame.size.height/3;
    newFrame.size.width = annoFrame.size.width - kRightMargin - kLeftMargin;
    annotationLabel.frame = newFrame;
    
    return annotationLabel;
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueReviews"]) {
        NSIndexPath *indexPath = [self.m_tableView indexPathForSelectedRow];
        ReviewsViewController *target = (ReviewsViewController *)segue.destinationViewController;
        target.m_BusinessSummary = [[self.m_Results objectForKey:@"businesses"] objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"segueReviewsFromAnnotation"]) {
        ReviewsViewController *target = (ReviewsViewController *)segue.destinationViewController;
        target.m_BusinessSummary = _currentAnnotation.object;
    }
}

#pragma mark - Common
- (void)loadPlacesToMap {
    self.m_mapView.delegate = self;
    CLLocationCoordinate2D addressCoordinate;
    addressCoordinate.latitude = [[[[self.m_Results objectForKey:@"region"] objectForKey:@"center"] objectForKey:@"latitude"] doubleValue];
    addressCoordinate.longitude = [[[[self.m_Results objectForKey:@"region"] objectForKey:@"center"] objectForKey:@"longitude"] doubleValue];
    
    _centerLocation = [[CLLocation alloc] initWithLatitude:addressCoordinate.latitude longitude:addressCoordinate.longitude];

    [self.m_mapView setShowsUserLocation:YES];
    [self.m_mapView setCenterCoordinate:addressCoordinate animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(addressCoordinate, 1.0 * METES_PER_MILE, 1.0 * METES_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.m_mapView regionThatFits:viewRegion];
    [self.m_mapView setRegion:adjustedRegion animated:YES];
    
    _mapAnnotations = [[NSMutableArray alloc] init];
    NSInteger index = 1;
    for(NSDictionary* item in [self.m_Results objectForKey:@"businesses"]) {
        double longi = [[[[item objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
        double lati = [[[[item objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
        NSString *name = [item objectForKey:@"name"];
        NSString *address = [[item objectForKey:@"location"] objectForKey:@"cross_streets"];
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lati, longi);
        MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords name:name description:address];
        ann.object = item;
        ann.index = index;
        [_mapAnnotations addObject:ann];
        index++;
    }
    [self.m_mapView addAnnotations:_mapAnnotations];
}

-(void)didTapRightAccesoryButton:(id)sender {
    
    [self performSegueWithIdentifier:@"segueReviewsFromAnnotation" sender:self];
}

@end
