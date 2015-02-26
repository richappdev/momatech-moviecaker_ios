//
//  FriendSearchViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/3/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "FriendSearchViewController.h"
#import "MyViewController.h"
#import "SearchObj.h"

@interface FriendSearchViewController ()
    @property(nonatomic,strong) NSNumber *page;
    @property(nonatomic,strong) NSMutableArray *listArray;
    @property(nonatomic,strong) NSString *type;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
@end

@implementation FriendSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDefaultNavBarButtons];
    self.title=NSLocalizedStringFromTable(@"搜尋朋友",@"InfoPlist",nil);
    
    self.page=[NSNumber numberWithInt:1];
    self.isLoading=NO;
    self.isLast=NO;
    self.listArray=[[NSMutableArray alloc] init];
    self.type=@"User";
    
    self.myTableView.tableFooterView=nil;
    
    //self.touchView.hidden=YES;
    
    [self.searchBar becomeFirstResponder];

}

-(void)loadData:(NSNumber *)page{
    
    self.isLoading=YES;
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self.manager search:self.searchBar.text type:self.type page:self.page callback:^(NSMutableArray *listArray, NSString *errorMsg, NSError *error) {
        
        self.isLoading=NO;
        
        if (listArray.count<10) {
            self.isLast=YES;
        }
        
        if (listArray.count>0) {
            [self.listArray addObjectsFromArray:listArray];
        }
        self.myTableView.tableFooterView=nil;
        //self.touchView.hidden=YES;
        [self.myTableView reloadData];
        [WaitingAlert dismiss];
        
        if (self.listArray.count==0) {
            [self alertShow:NSLocalizedStringFromTable(@"目前無資料！",@"InfoPlist",nil)];
        }
        
        
        

    }];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
    [self.listArray removeAllObjects];
    [self loadData:@(1)];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    //self.touchView.hidden=NO;
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SearchObj *obj=[self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text =obj.label;
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchObj *obj=[self.listArray objectAtIndex:indexPath.row];
    MyViewController *mvc=[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    mvc.userId= [NSNumber numberWithInteger: [obj.Id integerValue]];
    [self.navigationController pushViewController:mvc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
    //self.touchView.hidden=YES;
}

@end
