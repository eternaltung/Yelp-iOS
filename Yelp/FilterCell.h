//
//  FilterCell.h
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterCell;

@protocol FilterCellDelegate <NSObject>

- (void)filtercell:(FilterCell*)filtercell isUpdate:(BOOL)value;

@end

@interface FilterCell : UITableViewCell

@property (nonatomic,weak) id<FilterCellDelegate> delegate;

-(void)setData:(NSString*)title
         seton:(BOOL)on;
@end
