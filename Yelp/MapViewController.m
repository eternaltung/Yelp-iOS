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

@interface MapViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MapViewController
@synthesize businessdatas;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //start tracking location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    NSLog(@"%lf %lf",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}

/*- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 CLLocation *currentLocation = newLocation;
 [manager stopUpdatingLocation];
 self.userLocationCoordinate2D = currentLocation.coordinate;
 [self fetchBusinessesWithQuery:self.queryTerm params:self.searchFilters];
 }*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
