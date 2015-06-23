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
#import <MapKit/MapKit.h>

@interface YelpTableController () <UISearchBarDelegate,FilterViewControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) NSMutableArray *businessdatas;
@property (nonatomic,strong) NSDictionary *region;
@property (nonatomic,strong) UISearchBar *searchbar;
@property(nonatomic, strong) UIBarButtonItem *filtersbutton;
@property NSUserDefaults *defaults;
@property (nonatomic, assign) BOOL isFetchingData;      //prevent for multiple call for data
@property (nonatomic, assign) BOOL isInfiniteScroll;
@property (nonatomic, assign) BOOL isEndofData;     //can get more data or not
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation YelpTableController
NSString * const reuseridentifier = @"Cell";
NSString * const consumerkey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const consumersecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const token = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const tokensecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@synthesize client;
@synthesize businessdatas;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    client = [[YelpClient alloc] initWithConsumerKey:consumerkey consumerSecret:consumersecret accessToken:token accessSecret:tokensecret];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.isFetchingData = NO;
    self.isInfiniteScroll = NO;
    self.isEndofData = NO;
    
    //tableview row autoheight
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:reuseridentifier];
    
    [self addNavigationBarUI];
    [self addRefreshViewController];
    [self getUserLocation];
}

- (void)getUserLocation{
    //start tracking location
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

//location update
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.userLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    [self searchForData:0];
}

- (void)addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshAction{
    [self searchForData:0];
}

- (void)searchForData:(int)offset{
    if (self.isFetchingData)
        return;
    
    //update refresh control last update time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last update: %@",[formatter stringFromDate:[NSDate date]]]];
    
    //prepare all query param
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self.defaults objectForKey:@"category_filter"] forKey:@"category_filter"];
    [params setValue:[self.defaults objectForKey:@"deals_filter"] forKey:@"deals_filter"];
    [params setValue:[self.defaults objectForKey:@"sort"] forKey:@"sort"];
    [params setValue:[self.defaults objectForKey:@"radius_filter"] forKey:@"radius_filter"];
    [params setValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    
    self.isFetchingData = YES;
    self.tableView.tableHeaderView = nil;
    [client searchWithTerm:[self.searchbar.text isEqualToString:@""] ? @"buffet" : self.searchbar.text ll:[NSString stringWithFormat:@"%f,%f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude] params:params success:^(AFHTTPRequestOperation *operation, id response)
     {
         [self successFetchData:response];
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.refreshControl endRefreshing];
         self.isFetchingData = NO;
     }];
}

//get data successful
-(void)successFetchData:(id)response{
    [self.refreshControl endRefreshing];
    NSMutableArray *newBusiness = [Business businessWithDict:response[@"businesses"]];
    if (self.isInfiniteScroll)
    {
        [businessdatas addObjectsFromArray:newBusiness];
    }
    else
        businessdatas = newBusiness;
    
    [self.tableView reloadData];
    
    //if category is not null create categories header
    if ([self.defaults objectForKey:@"category_filter"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.8 blue:0.8 alpha:0.3];
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
        categoryLabel.text = [NSString stringWithFormat:@"Category: %@",[self.defaults objectForKey:@"category_filter"]];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:categoryLabel];
        self.tableView.tableHeaderView = view;
    }
    
    self.isEndofData = newBusiness.count < 20 ? true : false;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.region = response[@"region"];
    self.isFetchingData = NO;
    self.isInfiniteScroll = NO;
}

- (void)addNavigationBarUI{
    //add searchbar
    self.searchbar = [[UISearchBar alloc] init];
    [self.searchbar setPlaceholder:@"search"];
    self.searchbar.text = @"buffet";
    self.searchbar.delegate = self;
    self.navigationItem.titleView = self.searchbar;
    
    //add map button
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map.png"] style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonTap)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    //add filter button
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter.png"] style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTap)];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self searchForData:0];
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
    
    if ((indexPath.row + 1) == businessdatas.count && !self.isEndofData)
    {   //infinte loading
        self.isInfiniteScroll = YES;
        [self searchForData:(int)businessdatas.count];
    }
    return cell;
}

//select row and segue to detailview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.business = businessdatas[indexPath.row];
    [self showViewController:detailview sender:self];
}

#pragma mark - searchbar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchbar setShowsCancelButton:YES animated:NO];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
    //scroll to top and then search
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self searchForData:0];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
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
