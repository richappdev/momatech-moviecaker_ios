//
//  MovieTwoTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/19/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTwoTableViewController.h"
#import "MovieTabCell.h"
@interface MovieTwoTableViewController ()

@end

@implementation MovieTwoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(self.type == 0||self.type == 1){
    MovieTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableOne" forIndexPath:indexPath];
    
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    return cell;
    }else if (self.type == 2){
    MovieTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableTwo" forIndexPath:indexPath];
        
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        return cell;
    }else if (self.type ==3){
    cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableThree" forIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.type ==3){
        return 190;
    }else{
        return 165;}
}

@end
