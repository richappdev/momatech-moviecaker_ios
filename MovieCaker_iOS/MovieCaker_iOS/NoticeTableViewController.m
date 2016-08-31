//
//  NoticeTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/26/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "noticeCell.h"
#import "UIImageView+WebCache.h"
#import "AustinApi.h"

@interface NoticeTableViewController ()

@end

@implementation NoticeTableViewController

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
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return  [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    noticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[[[self.data objectAtIndex:indexPath.row]objectForKey:@"User"] objectForKey:@"Avatar"]]]];
    cell.content.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"Message"];
    if(cell.content.text.length ==0){
        cell.content.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"Title"];
      cell.content.text = [[cell.content.text stringByAppendingString:@"-"]stringByAppendingString:[[[self.data objectAtIndex:indexPath.row]objectForKey:@"User"] objectForKey:@"NickName"]];
    }
    cell.time.text = [[[[self.data objectAtIndex:indexPath.row] objectForKey:@"CreatedOn"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"]stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    cell.time.text = [cell.time.text substringWithRange:NSMakeRange(0,([cell.time.text rangeOfString:@"."].location-3))];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
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
