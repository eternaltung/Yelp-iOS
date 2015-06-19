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

@interface YelpTableController () <UISearchBarDelegate>
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) NSArray *businessdatas;
@property (nonatomic,strong) UISearchBar *searchbar;
@property(nonatomic, strong) UIBarButtonItem *filtersbutton;
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
    [client searchWithTerm:[self.searchbar.text isEqualToString:@""] ? @"buffet" : self.searchbar.text ll:@"25.033493,121.564101" success:^(AFHTTPRequestOperation *operation, id response)
     {
         businessdatas = [Business businessWithDict:response[@"businesses"]];
         [self.tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
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
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"filter" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = filtersButton;
}

//map button tap
- (void)mapButtonTap{
    MapViewController *mapview = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    mapview.businessdatas = businessdatas;
    [self showViewController:mapview sender:self];
    /*[UIView transitionWithView:self.view
                      duration:1.0
                       options:self.isMapView ? UIViewAnimationOptionTransitionFlipFromTop :UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        self.tableView.hidden = !self.isMapView;
                        self.mapView.hidden = self.isMapView;
                    } completion:nil
     ];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.business = businessdatas[indexPath.row];
    [self showViewController:detailview sender:self];
}

//searchbar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
