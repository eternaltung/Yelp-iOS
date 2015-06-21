//
//  YelpTableController.m
//  Yelp
//
//  Created by Shih-Ming Tung on 6/18/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "YelpTableController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import <MBProgressHUD.h>
#import "MapViewController.h"
#import "DetailViewController.h"
#import "FilterViewController.h"

@interface YelpTableController () <UISearchBarDelegate,FilterViewControllerDelegate>
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) NSArray *businessdatas;
@property (nonatomic,strong) NSDictionary *region;
@property (nonatomic,strong) UISearchBar *searchbar;
@property(nonatomic, strong) UIBarButtonItem *filtersbutton;
@property NSUserDefaults *defaults;
@end

@implementation YelpTableController
NSString * const reuseridentifier = @"Cell";
NSString * const consumerkey = @"";
NSString * const consumersecret = @"";
NSString * const token = @"";
NSString * const tokensecret = @"";

@synthesize client;
@synthesize businessdatas;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    client = [[YelpClient alloc] initWithConsumerKey:consumerkey consumerSecret:consumersecret accessToken:token accessSecret:tokensecret];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    //tableview row autoheight
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:reuseridentifier];
    
    [self addNavigationBarUI];
    [self searchForData];
    self.searchbar.text = @"buffet";
}

- (void)searchForData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self.defaults objectForKey:@"category_filter"] forKey:@"category_filter"];
    [params setValue:[self.defaults objectForKey:@"deals_filter"] forKey:@"deals_filter"];
    [params setValue:[self.defaults objectForKey:@"sort"] forKey:@"sort"];
    [params setValue:[self.defaults objectForKey:@"radius_filter"] forKey:@"radius_filter"];
    NSLog(@"%@",params);
    if (params)
    {
        [client searchWithTerm:[self.searchbar.text isEqualToString:@""] ? @"buffet" : self.searchbar.text ll:@"25.033493,121.564101" params:params success:^(AFHTTPRequestOperation *operation, id response)
         {
             [self successFetchData:response];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
}

-(void)successFetchData:(id)response{
    businessdatas = [Business businessWithDict:response[@"businesses"]];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.region = response[@"region"];
}

- (void)addNavigationBarUI{
    //add searchbar
    self.searchbar = [[UISearchBar alloc] init];
    [self.searchbar setPlaceholder:@"search"];
    self.searchbar.delegate = self;
    self.searchbar.showsCancelButton = YES;
    self.navigationItem.titleView = self.searchbar;
    
    //add map button
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map.png"] style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonTap)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    //add filter button
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTap)];
    self.navigationItem.leftBarButtonItem = filtersButton;
}

//filter button tap
- (void)filterButtonTap{
    FilterViewController *filterview = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterView"];
    filterview.delegate = self;
    
    [UIView transitionFromView:self.view toView:filterview.view duration:0.8 options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished) {
        [self showViewController:filterview sender:self];
    }];
}

//map button tap
- (void)mapButtonTap{
    MapViewController *mapview = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    mapview.businessdatas = businessdatas;
    mapview.region = self.region;
    [self showViewController:mapview sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//filter view delegate
-(void)filterViewController:(FilterViewController *)filterViewController changedFilter:(NSDictionary *)filters{
    [self searchForData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return businessdatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseridentifier];
    cell.business = businessdatas[indexPath.row];
    
    return cell;
}

//select row and segue to detailview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.business = businessdatas[indexPath.row];
    [self showViewController:detailview sender:self];
}

#pragma mark - searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchbar resignFirstResponder];
    
    //scroll to top and then search
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self searchForData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchbar resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
