//
//  YelpClient.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/18/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import <UIKit/UIKit.h>

@interface YelpClient : BDBOAuth1RequestOperationManager
- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
             accessSecret:(NSString *)accessSecret;

/*- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
    ll:(NSString*)ll
    success:(void (^)(AFHTTPRequestOperation *operation, id response))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;*/

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                        ll:(NSString*)ll
                                    params:(NSDictionary*)params
                                   success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
