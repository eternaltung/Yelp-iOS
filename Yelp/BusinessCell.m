//
//  BusinessCell.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/19/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "BusinessCell.h"
#import "Business.h"
#import <UIImageView+AFNetworking.h>

@interface BusinessCell()
@property (weak, nonatomic) IBOutlet UIImageView *ThumbImg;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RatingImg;
@property (weak, nonatomic) IBOutlet UILabel *ReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    self.ThumbImg.clipsToBounds = YES;
    self.ThumbImg.layer.cornerRadius = 5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.NameLabel.preferredMaxLayoutWidth = self.NameLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business{
    _business = business;
    self.ThumbImg.image = nil;
    [self.ThumbImg setImageWithURL:[NSURL URLWithString:business.thumbimg]];
    self.NameLabel.text = business.name;
    [self.RatingImg setImageWithURL:[NSURL URLWithString:business.ratingimg]];
    self.DistanceLabel.text = [NSString stringWithFormat:@"%f",business.distance];
    self.ReviewLabel.text = [NSString stringWithFormat:@"%d Reviews",business.reviews];
    self.AddressLabel.text = business.address;
    self.CategoryLabel.text = business.categories;
}

@end
