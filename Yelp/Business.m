//
//  Business.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/18/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "Business.h"

@implementation Business

+ (NSArray*)businessWithDict:(NSArray*)array{
    NSMutableArray *returnarray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        Business *data = [[Business alloc] init];
        data.name = dict[@"name"];
        data.thumbimg = dict[@"image_url"];
        data.ratingimg = dict[@"rating_img_url"];
        data.reviews = [dict[@"review_count"] intValue];
        NSString *street;
        if (((NSArray*)[dict valueForKeyPath:@"location.address"]).count) {
            street = [dict valueForKeyPath:@"location.address"][0];
        }
        else{
            street = [dict valueForKeyPath:@"location.city"];
        }
            
        data.address = [dict valueForKeyPath:@"location.neighborhoods"][0] ?
            [NSString stringWithFormat:@"%@ , %@", street, [dict valueForKeyPath:@"location.neighborhoods"][0]] :
            [NSString stringWithFormat:@"%@", street];
        
        NSMutableArray *categorynames = [NSMutableArray array];
        [dict[@"categories"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categorynames addObject:obj[0]];
        }];
        data.categories = [categorynames componentsJoinedByString:@","];
        float milespermeter = 0.000621371;
        data.distance = [dict[@"distance"] integerValue] * milespermeter;
        data.longitude = [[dict valueForKeyPath:@"location.coordinate.longitude"] floatValue];
        data.latitude = [[dict valueForKeyPath:@"location.coordinate.latitude"] floatValue];
        [returnarray addObject:data];
    }
    return returnarray;
}

@end
