//
//  MapAnnotation.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) Business *business;

- (id)initWithLocation:(Business*)business;
@end
