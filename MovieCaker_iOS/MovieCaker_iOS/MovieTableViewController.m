//
//  MovieTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieCell.h"
#import "Movie2Cell.h"
#import "AustinApi.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MovieTableViewController ()
@property int cellHeight;
@end

@implementation MovieTableViewController
- (id)init:(int)type {
    if (self = [super init]) {
        self.type = type;
        if(type==0){
            self.cellHeight = 300;}
        else{
            self.cellHeight = 200;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillLayoutSubviews{
    self.tableView.scrollEnabled = false;
    self.tableHeight.constant = self.cellHeight*5;
    self.tableView.allowsSelection = NO;
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

-(int)returnTotalHeight{
    return 3*_cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.type==0){
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
        cell.title.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"Title"];
        cell.Author.text =  [[[self.data objectAtIndex:indexPath.row]objectForKey:@"Author"]objectForKey:@"NickName"];
        cell.Content.text =  [[self.data objectAtIndex:indexPath.row]objectForKey:@"Content"];
        cell.Date.text = [[[self.data objectAtIndex:indexPath.row]objectForKey:@"ModifiedOn"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [cell.AvatarPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[[[self.data objectAtIndex:indexPath.row]objectForKey:@"Author"] objectForKey:@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    [cell setCirclePercentage:(float)arc4random()/0x100000000];
        return cell;
    }else{
            Movie2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Movie2Cell" forIndexPath:indexPath];
            [cell setStars:floor((float)arc4random()/0x100000000*11)];
            return cell;
    

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
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
