//
//  MovieTwoTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/19/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTwoTableViewController.h"
#import "MovieTabCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

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
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(self.type == 0||self.type == 1){
    MovieTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableOne" forIndexPath:indexPath];
    NSDictionary *data = [self.data objectAtIndex:indexPath.row];
    cell.title.text = [data objectForKey:@"CNName"];
    NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[data objectForKey:@"Picture"]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    cell.imdb.text = [self testNil:[data objectForKey:@"Ratings_IMDB"]];
    cell.dou.text = [self testNil:[data objectForKey:@"Ratings_Douban"]];
    cell.date.text = [NSString stringWithFormat:@"%@ 上映",[data objectForKey:@"ReleaseDate"]];
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    cell.liked.text = [[data objectForKey:@"LikeNum"]stringValue];
    cell.favored.text = [[data objectForKey:@"WantViewNum"]stringValue];
    cell.reviewed.text = [[data objectForKey:@"ReviewNum"]stringValue];
    cell.viewed.text = [[data objectForKey:@"ViewNum"]stringValue]
        ;
        
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
-(NSString*)testNil:(id)test{
    if(![test isKindOfClass:[NSNull class]]){
        return [test stringValue];
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.type ==3){
        return 190;
    }else{
        return 165;}
}

@end
