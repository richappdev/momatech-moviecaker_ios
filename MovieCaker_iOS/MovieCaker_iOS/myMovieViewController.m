//
//  myMovieViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 10/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "myMovieViewController.h"
#import "MainVerticalScroller.h"
#import "MovieTwoTableViewController.h"
#import "MovieDetailController.h"
#import "AustinApi.h"
#import "MBProgressHUD.h"
#import "reviewController.h"
@interface myMovieViewController ()
@property MainVerticalScroller *helper;
@property MovieTwoTableViewController *movieTableController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation myMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type==0){
        self.title = NSLocalizedStringFromTableInBundle(@"mywatch.title", @"Main", [NSBundle mainBundle], nil);
    }
    if(self.type==1){
        self.title = NSLocalizedStringFromTableInBundle(@"mylike.title", @"Main", [NSBundle mainBundle], nil);
    }
    if(self.type==2){
        self.title = NSLocalizedStringFromTableInBundle(@"mywant.title", @"Main", [NSBundle mainBundle], nil);
    }
    if(self.type==3){
        self.title = NSLocalizedStringFromTableInBundle(@"review.title", @"Main", [NSBundle mainBundle], nil);
    }
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTableController.tableView = self.tableView;
    self.tableView.delegate =self.movieTableController;
    [self.movieTableController ParentController:self];
    self.movieTableController.hideRating = YES;
    self.movieTableController.page = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *uid = nil;
    if(self.friendBool ==YES){
        uid = self.friendId;
        NSLog(@"%@",uid);
    }else{
        NSLog(@"NO");
    }
    if(self.type==3){
        [[AustinApi sharedInstance] getReview:@"9" page:@"1" uid:uid function:^(NSArray *returnData) {
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *row in returnData) {
                [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
            }
            self.movieTableController.data = array;
            self.movieTableController.type =3;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } error:^(NSError *error) {
            
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
    [[AustinApi sharedInstance] movieListCustom:@"5" myType:[NSString stringWithFormat:@"%d",self.type] location:nil year:nil month:nil page:nil topicId:nil uid:uid function:^(NSArray *returnData) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        self.movieTableController.data = array;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"movieDetail"]){
        MovieDetailController *vc = segue.destinationViewController;
        vc.movieDetailInfo = [self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex];
    }
    if([[segue identifier]isEqualToString:@"reviewSegue"]){
        reviewController *vc = segue.destinationViewController;
        vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex]];
        
    }
}

-(void)loadMore:(int)page{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *uid = nil;
    if(self.friendBool ==YES){
        uid = self.friendId;
    }
    NSString *pageString = [NSString stringWithFormat:@"%d",page];
    
    if(self.type!=3){
        [[AustinApi sharedInstance] movieListCustom:@"5" myType:[NSString stringWithFormat:@"%d",self.type] location:nil year:nil month:nil page:pageString topicId:nil uid:uid function:^(NSArray *returnData) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        NSArray *new = [self.movieTableController.data arrayByAddingObjectsFromArray:array];
        self.movieTableController.data = new;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    }else{
        [[AustinApi sharedInstance] getReview:@"9" page:pageString uid:uid function:^(NSArray *returnData) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        NSArray *new = [self.movieTableController.data arrayByAddingObjectsFromArray:array];
        self.movieTableController.data = new;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    }
}

@end
