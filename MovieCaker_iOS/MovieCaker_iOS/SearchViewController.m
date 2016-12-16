//
//  SearchViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 12/16/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "SearchViewController.h"
#import "AustinApi.h"

@interface SearchViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property NSArray *data;
@property BOOL simplified;
@property BOOL lock;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate =self;
    self.view.backgroundColor =[UIColor colorWithWhite:0.8 alpha:1];
    self.data = [[NSArray alloc]init];
    self.simplified = [[[NSUserDefaults standardUserDefaults] objectForKey:@"simplified"] boolValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    if(self.simplified){
        cell.textLabel.text= [[self.data objectAtIndex:indexPath.row]objectForKey:@"lableCn"];
    }else{
        cell.textLabel.text= [[self.data objectAtIndex:indexPath.row]objectForKey:@"label"];
    }
    return cell;
}
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [self search];
}
-(void)search{
    [[AustinApi sharedInstance] searchMovie:self.searchBar.text completion:^(NSArray *returnData) {
        NSLog(@"%@",returnData);
        self.data = returnData;
        [self.searchController.searchResultsTableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    if([self.searchBar.text length]==0){
        self.data = [[NSArray alloc]init];
        [self.searchController.searchResultsTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.data = [[NSArray alloc]init];
    [self.searchController.searchResultsTableView reloadData];
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
