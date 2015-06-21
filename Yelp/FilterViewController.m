//
//  FilterViewController.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/20/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCell.h"
#import "ComboBoxCell.h"
#import <UIColor+FlatUI.h>

typedef NS_ENUM(NSInteger, SectionIndex) {
    Deal = 0,
    Distance    = 1,
    Sort        = 2,
    Categories    = 3
};

@interface FilterViewController () <FilterCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property NSUserDefaults *defaults;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableSet *selectCategories;   //record selected category
@property (nonatomic, assign) BOOL showMoreCategory; //category tableview cell show more or less

@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, assign) BOOL showMoreDistance;    //distance cell show more or not
@property (nonatomic, assign) int distanceIndex;    //index of selected distance

@property (nonatomic, strong) NSArray *sortModes;
@property (nonatomic, assign) BOOL showMoreSort;  //sort mode cell show more or not
@property (nonatomic, assign) int sortIndex; //index of selected sort

@property (nonatomic, assign) BOOL isDealOn;  //whether deal filter is on
@end

@implementation FilterViewController
NSString * const identifier = @"Cell";
NSString * const comboBoxidentifier = @"ComboBox";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectCategories = [NSMutableSet set];
    [self initFilteringData];
    [self restoreFilter];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(ApplyTap)];
    self.title = @"Filter";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ComboBoxCell" bundle:nil] forCellReuseIdentifier:comboBoxidentifier];
    
    [self.tableView reloadData];
}

-(void)restoreFilter{
    self.defaults = [NSUserDefaults standardUserDefaults];
    //restore category
    NSArray *categoriesArray = [[self.defaults objectForKey:@"category_filter"] componentsSeparatedByString:@","];
    for (NSString *codename in categoriesArray) {
        for (NSDictionary *dict in self.categories) {
            if ([codename isEqualToString:dict[@"code"]])
                [self.selectCategories addObject:dict];
        }
    }
    
    //restore sort
    self.sortIndex = (int)[self.defaults integerForKey:@"sort"];
    //restore distance
    int defualtDistance = (int)[self.defaults integerForKey:@"radius_filter"];
    for (int a = 0; a < self.distances.count; a++) {
        if ([self.distances[a][@"code"] intValue] == defualtDistance) {
            self.distanceIndex = a;
            break;
        }
    }
    //restore deal
    self.isDealOn = [self.defaults boolForKey:@"deals_filter"];
}

- (void)ApplyTap{
    //save sort
    [self.defaults setInteger:self.sortIndex forKey:@"sort"];
    //save distance
    [self.defaults setInteger:[self.distances[self.distanceIndex][@"code"] intValue] forKey:@"radius_filter"];
    [self.navigationController popViewControllerAnimated:YES];
    //save isdeal
    [self.defaults setBool:self.isDealOn forKey:@"deals_filter"];
    
    //get all selected filters and save
    if (self.selectCategories.count > 0) {
        NSMutableArray *filterCodeName = [NSMutableArray array];
        for (NSDictionary *dict in self.selectCategories) {
            [filterCodeName addObject:dict[@"code"]];
        }
        NSMutableDictionary *changedFilter = [NSMutableDictionary dictionary];
        [changedFilter setValue:[filterCodeName componentsJoinedByString:@","] forKey:@"category_filter"];
        [self.defaults setObject:[filterCodeName componentsJoinedByString:@","] forKey:@"category_filter"];
        [self.delegate filterViewController:self changedFilter:changedFilter];
    }
    else
    {
        [self.defaults setObject:nil forKey:@"category_filter"];
        [self.delegate filterViewController:self changedFilter:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComboBoxCell *cell;
    FilterCell *filtercell;
    switch (indexPath.section) {
        case Deal:
            filtercell = [tableView dequeueReusableCellWithIdentifier:identifier];
            filtercell.delegate = self;
            [filtercell setData:@"Offering a Deal" seton:self.isDealOn];
            return filtercell;
        case Distance:
            cell = [tableView dequeueReusableCellWithIdentifier:comboBoxidentifier];
            if (self.showMoreDistance)
            {
                [cell setData:self.distances[self.distanceIndex][@"name"] selected:YES];
            }
            else
            {   //expand mode
                indexPath.row == self.distanceIndex ? [cell setData:self.distances[indexPath.row][@"name"] selected:YES] : [cell setData:self.distances[indexPath.row][@"name"] selected:NO];
            }
            return cell;
        case Sort:
            cell = [tableView dequeueReusableCellWithIdentifier:comboBoxidentifier];
            if (self.showMoreSort)
            {
                [cell setData:self.sortModes[self.sortIndex][@"name"] selected:YES];
            }
            else
            {   //expand mode
                indexPath.row == self.sortIndex ? [cell setData:self.sortModes[indexPath.row][@"name"] selected:YES] : [cell setData:self.sortModes[indexPath.row][@"name"] selected:NO];
            }
            return cell;
        case Categories:
            if (self.showMoreCategory && indexPath.row == 5)
            {   //show all cell
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"More"];
                cell.textLabel.text = @"Show All";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                return cell;
            }
            else if (!self.showMoreCategory && indexPath.row == self.categories.count)
            {   //show less cell
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"More"];
                
                cell.textLabel.text = @"Show Less";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                return cell;
            }
            else
            {
                filtercell = [tableView dequeueReusableCellWithIdentifier:identifier];
                filtercell.delegate = self;
                [filtercell setData:self.categories[indexPath.row][@"name"] seton:[self.selectCategories containsObject:self.categories[indexPath.row]]];
                return filtercell;
            }
        default:
            return nil;
    }
}

//each section row num
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case Deal:
            return 1;
        case Distance:
            return self.showMoreDistance ? 1 :self.distances.count;
        case Sort:
            return self.showMoreSort ? 1 : self.sortModes.count;
        case Categories:
            return self.showMoreCategory ? 6 : self.categories.count + 1;
        default:
            return 0;
    }
}

//tableview row selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL needReload = NO;
    switch (indexPath.section) {
        case Deal:
            break;
        case Distance:
            if (!self.showMoreDistance)
            {   //in expand mode
                self.distanceIndex = (int)indexPath.row;
            }
            self.showMoreDistance = !self.showMoreDistance;
            needReload = true;
            break;
        case Sort:
            if (!self.showMoreSort)
            {   //in expand mode 
                self.sortIndex = (int)indexPath.row;
            }
            self.showMoreSort = !self.showMoreSort;
            needReload = true;
            break;
        case Categories:
            if ((self.showMoreCategory && indexPath.row == 5) || (!self.showMoreCategory && indexPath.row == self.categories.count))
            {   //select show more or less
                self.showMoreCategory = !self.showMoreCategory;
                needReload = YES;
            }
            break;
        default:
            break;
    }
    
    if (needReload) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitles.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 35 : 20;
}

//filter cell delegate
-(void)filtercell:(FilterCell *)filtercell isUpdate:(BOOL)value{
    NSIndexPath *index = [self.tableView indexPathForCell:filtercell];
    if (index.section != Deal)
    {   //category section
        value ? [self.selectCategories addObject:self.categories[index.row]] : [self.selectCategories removeObject:self.categories[index.row]];
    }
    else
    {
        self.isDealOn = value;
    }
}

- (void)initFilteringData {
    self.showMoreCategory = YES;
    self.showMoreSort = YES;
    self.showMoreDistance = YES;
    self.isDealOn = NO;
    self.sortIndex = 0;
    self.distanceIndex = 0;
    self.sectionTitles = [NSArray arrayWithObjects:@"Deals", @"Distance", @"Sort by", @"Category", nil];
    
    self.distances = @[@{@"name" : @"Auto", @"code": @(40000)},
                             @{@"name" : @"0.3 miles", @"code": @(483)},
                             @{@"name" : @"1 mile", @"code": @(1609)},
                             @{@"name" : @"5 miles", @"code": @(8047)}];
    
    self.sortModes = @[@{@"name" : @"Best matched", @"code": @(0)},
                       @{@"name" : @"Distance", @"code": @(1)},
                       @{@"name" : @"Highest Rated", @"code": @(2)}];
    
    self.categories = @[@{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                        @{@"name" : @"Barbeque", @"code": @"bbq" },
                        @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                        @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                        @{@"name" : @"Buffets", @"code": @"buffets" },
                        @{@"name" : @"Burgers", @"code": @"burgers" },
                        @{@"name" : @"Cafes", @"code": @"cafes" },
                        @{@"name" : @"Chinese", @"code": @"chinese" },
                        @{@"name" : @"Diners", @"code": @"diners" },
                        @{@"name" : @"Fast Food", @"code": @"hotdogs" },
                        @{@"name" : @"French", @"code": @"french" },
                        @{@"name" : @"Hot Pot", @"code": @"hotpot" },
                        @{@"name" : @"Indian", @"code": @"indpak" },
                        @{@"name" : @"Italian", @"code": @"italian" },
                        @{@"name" : @"Japanese", @"code": @"japanese" },
                        @{@"name" : @"Korean", @"code": @"korean" },
                        @{@"name" : @"Mexican", @"code": @"mexican" },
                        @{@"name" : @"Night Food", @"code": @"nightfood" },
                        @{@"name" : @"Pizza", @"code": @"pizza" },
                        @{@"name" : @"Pub Food", @"code": @"pubfood" },
                        @{@"name" : @"Rice", @"code": @"riceshop" },
                        @{@"name" : @"Salad", @"code": @"salad" },
                        @{@"name" : @"Seafood", @"code": @"seafood" },
                        @{@"name" : @"Soup", @"code": @"soup" },
                        @{@"name" : @"Spanish", @"code": @"spanish" },
                        @{@"name" : @"Steakhouses", @"code": @"steak" },
                        @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                        @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                        @{@"name" : @"Thai", @"code": @"thai" },
                        @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                        @{@"name" : @"Vietnamese", @"code": @"vietnamese" }];
}

@end
