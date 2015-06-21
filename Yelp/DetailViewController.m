//
//  DetailViewController.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/19/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize business;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = business.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
