//
//  ComboBoxCell.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/21/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComboBoxCell : UITableViewCell

-(void) setData:(NSString*)title
       selected:(BOOL)selected;

@end
