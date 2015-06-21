//
//  FilterCell.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "FilterCell.h"
#import <FUISwitch.h>
#import <UIColor+FlatUI.h>
#import <UIFont+FlatUI.h>

@interface FilterCell()
@property (weak, nonatomic) IBOutlet FUISwitch *ToggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
- (IBAction)SwitchChange:(FUISwitch *)sender;

@end

@implementation FilterCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //set custom switch style
    self.ToggleSwitch.offLabel.text = @"off";
    self.ToggleSwitch.onLabel.text = @"on";
    self.ToggleSwitch.offBackgroundColor = [UIColor silverColor];
    self.ToggleSwitch.onBackgroundColor = [UIColor alizarinColor];
    self.ToggleSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    self.ToggleSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    self.ToggleSwitch.onColor = [UIColor turquoiseColor];
    self.ToggleSwitch.offColor = [UIColor cloudsColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(NSString*)title seton:(BOOL)on{
    [self.ToggleSwitch setOn:on animated:NO];
    self.TitleLabel.text = title;
}

- (IBAction)SwitchChange:(UISwitch *)sender {
    [self.delegate filtercell:self isUpdate:self.ToggleSwitch.on];
}
@end
