//
//  DetailViewController.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/19/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface DetailViewController : UIViewController
@property (nonatomic,strong) Business *business;
@end
