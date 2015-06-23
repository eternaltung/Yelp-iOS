//
//  MapViewController.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/19/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"

@interface MapViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MapViewController
@synthesize businessdatas;
@synthesize region;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.delegate = self;
    [self addMapAnnotation];
    
    //start tracking location
    /*self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];*/
    
    [self setMapRegion];
}

- (void)addMapAnnotation{
    for (Business *data in businessdatas) {
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithLocation:data];
        [self.map addAnnotation:annotation];
    }
}

- (void)setMapRegion{
    MKCoordinateRegion mkregion;
    mkregion.center.latitude = [[region valueForKeyPath:@"center.latitude"] floatValue];
    mkregion.center.longitude = [[region valueForKeyPath:@"center.longitude"] floatValue];
    mkregion.span.latitudeDelta = [[region valueForKeyPath:@"span.latitude_delta"] floatValue];
    mkregion.span.longitudeDelta = [[region valueForKeyPath:@"span.longitude_delta"] floatValue];
    [self.map setRegion:[self.map regionThatFits:mkregion] animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation *currentLocation = [locations lastObject];
    //[manager stopUpdatingLocation];
    
    //[self.map setCenterCoordinate:currentLocation.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation*)annotation{
    //user location return
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *const identifier = @"CustomPin";
    MKAnnotationView *pinview = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinview == nil){
        pinview = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pinview.enabled = YES;
        pinview.canShowCallout = YES;
        [pinview setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [imageView setImageWithURL:[NSURL URLWithString:annotation.business.thumbimg]];
        pinview.leftCalloutAccessoryView = imageView;
    }
    return pinview;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.business = ((MapAnnotation*)[view annotation]).business;
    [self showViewController:detailview sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
