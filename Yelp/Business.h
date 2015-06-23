//
//  Business.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/18/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject
@property (nonatomic,strong) NSString *thumbimg;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ratingimg;
@property (nonatomic,assign) int reviews;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *categories;
@property (nonatomic,assign) float distance;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

+ (NSMutableArray*)businessWithDict:(NSArray*)array;

@end
