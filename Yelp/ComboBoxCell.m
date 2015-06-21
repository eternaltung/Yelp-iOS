//
//  ComboBoxCell.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/21/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "ComboBoxCell.h"
#import <UITableViewCell+FlatUI.h>
#import <UIColor+FlatUI.h>

@interface ComboBoxCell()
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SelectedLabel;

@end

@implementation ComboBoxCell

- (void)awakeFromNib {
    self.backgroundView = nil;
    self.backgroundColor = nil;
    UIRectCorner corners = UIRectCornerAllCorners;
    [self configureFlatCellWithColor:[UIColor whiteColor]
                       selectedColor:[UIColor cloudsColor]
                     roundingCorners:corners];
    self.cornerRadius = 15.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(NSString *)title selected:(BOOL)selected{
    self.TitleLabel.text = title;
    self.SelectedLabel.hidden = !selected;
}

@end
