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
@interface myMovieViewController ()
@property MainVerticalScroller *helper;
@property MovieTwoTableViewController *movieTableController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation myMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type==0){
        self.title=@"我看過的電影";
    }
    if(self.type==1){
        self.title=@"我喜歡的電影";
    }
    if(self.type==2){
        self.title=@"我想看的電影";
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
    self.movieTableController.page = 999;

    [[AustinApi sharedInstance] movieListCustom:@"5" myType:[NSString stringWithFormat:@"%d",self.type] location:nil year:nil month:nil page:nil topicId:nil function:^(NSArray *returnData) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        self.movieTableController.data = array;
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
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
}
@end
