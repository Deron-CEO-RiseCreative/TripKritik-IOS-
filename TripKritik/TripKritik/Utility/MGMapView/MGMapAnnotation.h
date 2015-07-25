

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MGMapAnnotation : NSObject < MKAnnotation> {
    
    NSString *_name;
    NSString *_description;
    NSString *_info;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic) NSInteger index;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* info;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) id object;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate name:(NSString*)name description:(NSString*)description;

@end
