//
//  noticeViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/25/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "noticeViewController.h"
#import "MainVerticalScroller.h"
#import "AustinApi.h"
#import "NoticeTableViewController.h"

@interface noticeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property MainVerticalScroller *helper;
@property NoticeTableViewController *tableController;
@end

@implementation noticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的通知";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    self.tableController = [[NoticeTableViewController alloc]init];
    self.tableController.tableView = self.tableview;
    
    [[AustinApi sharedInstance] getNotice:^(NSArray *returnData) {
        NSLog(@"%@",returnData);
        self.tableController.data = returnData;
        [self.tableController.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
