//
//  DetailViewController.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/19/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import <UIImageView+AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
#import <UIColor+FlatUI.h>
#import <FUIButton.h>
#import <UIFont+FlatUI.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DetailViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapview;
@property (weak, nonatomic) IBOutlet UIImageView *BGImg;
@property (weak, nonatomic) IBOutlet UIImageView *RatingImg;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet FUIButton *NavigationButton;
- (IBAction)NavigationPress:(FUIButton *)sender;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation DetailViewController
@synthesize business;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.title = business.name;
    [self setUIData];
}

- (void)setUIData{
    
    [self.BGImg setImageWithURL:[NSURL URLWithString:business.thumbimg]];
    [self.RatingImg setImageWithURL:[NSURL URLWithString:business.ratingimg]];
    
    //add google map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:business.latitude longitude:business.longitude zoom:13];
    GMSMapView *map = [GMSMapView mapWithFrame:self.mapview.bounds camera:camera];
    map.myLocationEnabled = YES;
    map.settings.myLocationButton = YES;
    map.settings.compassButton = YES;
    [self.mapview addSubview:map];
    
    // create a marker 
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(business.latitude, business.longitude);
    marker.title = business.name;
    marker.snippet = business.address;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = map;
    
    self.TitleLabel.text = business.name;
    self.ReviewLabel.text = [NSString stringWithFormat:@"%d Reviews",business.reviews];
    self.CategoryLabel.text = business.categories;
    self.AddressLabel.text = business.address;
    
    self.NavigationButton.buttonColor = [UIColor turquoiseColor];
    self.NavigationButton.shadowColor = [UIColor greenSeaColor];
    self.NavigationButton.shadowHeight = 3.0f;
    self.NavigationButton.cornerRadius = 6.0f;
    self.NavigationButton.titleLabel.font = [UIFont boldFlatFontOfSize:20];
    [self.NavigationButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.NavigationButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)NavigationPress:(FUIButton *)sender {
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(business.latitude, business.longitude) addressDictionary:nil];
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:place];
    [toLocation setName:business.name];
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:launchOptions];
}
@end
