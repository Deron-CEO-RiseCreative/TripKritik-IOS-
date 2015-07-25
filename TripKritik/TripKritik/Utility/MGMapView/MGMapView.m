

#import "MGMapView.h"

@implementation MGMapView

@synthesize mapView;
@synthesize delegate = _delegate;
@synthesize currentAnnotation = _currentAnnotation;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MGMapView"
                                                             owner:self
                                                           options:nil];
        
        self = [nibContents objectAtIndex:0];
        [self baseInit];
        
        if(frame.size.height > 0 && frame.size.width > 0) {
            self.frame = frame;
        }
    }
    
    return self;
}

-(void) baseInit {
    mapView.delegate = self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView * view in [self subviews]) {
        
        if (view.userInteractionEnabled &&
            [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            
            return YES;
        }
    }
    return NO;
}

-(void) setMapData:(NSMutableArray*)mutableArray {
    _mapAnnotations = mutableArray;
    [mapView addAnnotations:_mapAnnotations];
}


-(void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated {
    [mapView setRegion:region animated:animated];
}

-(MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region {
    return [mapView regionThatFits:region];
}

-(void) setSelectedAnnotation:(CLLocationCoordinate2D)coordinate {

    for(MGMapAnnotation* annotation in _mapAnnotations) {
        
        if (annotation.coordinate.latitude == coordinate.latitude &&
            annotation.coordinate.longitude == coordinate.longitude) {
            
            [mapView setCenterCoordinate:annotation.coordinate animated:YES];
            [mapView selectAnnotation:annotation animated:YES];
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate,
                                                                               0.5*METES_PER_MILE,
                                                                               0.5*METES_PER_MILE);
            
            MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
            [mapView setRegion:adjustedRegion animated:YES];
            break;
        }
    }
}


#pragma mark - Map View

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
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.animatesDrop = YES;
        
        [self.delegate MGMapView:self didCreateMKPinAnnotationView:annotationView viewForAnnotation:annotation];
        
        return annotationView;
    }
    
    return nil;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MGMapAnnotation* mapAnnotation = view.annotation;
    
    [self.delegate MGMapView:self didSelectMapAnnotation:mapAnnotation];
    _currentAnnotation = mapAnnotation;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.delegate MGMapView:mapView didUpdateUserLocation:userLocation];
}

-(void)didTapAccesoryButton:(UITapGestureRecognizer *)gesture {
    [self.delegate MGMapView:self didAccessoryTapped:_currentAnnotation];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    return [self.delegate MGMapView:self viewForOverlay:overlay];
}
//
//-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//    return [self.delegate MGMapView:self rendererForOverlay:overlay];
//}

-(void)removeAllAnnotations {
    NSMutableArray *locs = [[NSMutableArray alloc] init];
    
    for (id <MKAnnotation> annot in [mapView annotations]) {
        if ( ![annot isKindOfClass:[MKUserLocation class]] ) {
            [locs addObject:annot];
        }
    }
    [mapView removeAnnotations:locs];
}

-(void)showsUserLocation:(BOOL)willShow {
    [mapView setShowsUserLocation:willShow];
}

-(void)zoomAndFitAnnotations {
    [mapView showAnnotations:_mapAnnotations animated:YES];
}

@end