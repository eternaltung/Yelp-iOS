//
//  FilterViewController.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController*)filterViewController changedFilter:(NSDictionary*)filters;

@end

@interface FilterViewController : UIViewController

@property (nonatomic,weak) id<FilterViewControllerDelegate> delegate;

@end
