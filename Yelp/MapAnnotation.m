//
//  MapAnnotation.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MapAnnotation.h"
#import <MapKit/MapKit.h>
#import "Business.h"

@implementation MapAnnotation

- (id)initWithLocation:(Business *)business{
    self = [super init];
    if (self != nil) {
        _coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
        _title = business.name;
        _subtitle = business.address;
        _business = business;
    }
    return self;
}

/*- (id)initWithLocation:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle{
    self = [super init];
    if (self != nil) {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
    }
    return (self);
}*/

@end
