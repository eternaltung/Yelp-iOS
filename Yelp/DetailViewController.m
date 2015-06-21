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

@interface DetailViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
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
    self.map.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.title = business.name;
    [self setUIData];
}

- (void)setUIData{
    
    [self.BGImg setImageWithURL:[NSURL URLWithString:business.thumbimg]];
    [self.RatingImg setImageWithURL:[NSURL URLWithString:business.ratingimg]];
    
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithLocation:business];
    [self.map addAnnotation:annotation];
    [self.map setCenterCoordinate:CLLocationCoordinate2DMake(business.latitude, business.longitude) animated:YES];
    [self.map setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(business.latitude, business.longitude), MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    
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
