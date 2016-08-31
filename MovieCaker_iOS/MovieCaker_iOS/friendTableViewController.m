//
//  friendTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/30/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "friendTableViewController.h"
#import "friendCell.h"
#import "UIImage+FontAwesome.h"
#import "UIImageView+WebCache.h"
#import "AustinApi.h"
@interface friendTableViewController ()

@end

@implementation friendTableViewController

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
    friendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    if(self.type==0){
        cell.statusTxt.text = @"好友";
        cell.bgWidth.constant = 75;
        cell.statusBg.backgroundColor = [UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(172/255.0f) alpha:1];
        cell.statusIcon.image =  [UIImage imageWithIcon:@"fa-check-circle" backgroundColor:[UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(172/255.0f) alpha:1] iconColor:[UIColor whiteColor] andSize:CGSizeMake(12, 12)];

    }else if(self.type==1){
        cell.statusTxt.text = @"確認接受";
        cell.bgWidth.constant = 97;
        cell.statusBg.backgroundColor = [UIColor colorWithRed:(248/255.0f) green:(100/255.0f) blue:(0/255.0f) alpha:1];
        cell.statusIcon.image =  [UIImage imageWithIcon:@"fa-check-circle" backgroundColor:[UIColor colorWithRed:(248/255.0f) green:(100/255.0f) blue:(0/255.0f) alpha:1] iconColor:[UIColor whiteColor] andSize:CGSizeMake(12, 12)];

    }else{
        cell.statusTxt.text = @"等待接受";
        cell.bgWidth.constant = 97;
        cell.statusBg.backgroundColor = [UIColor colorWithRed:(68/255.0f) green:(85/255.0f) blue:(102/255.0f) alpha:1];
                cell.statusIcon.image =  [UIImage imageWithIcon:@"fa-clock-o" backgroundColor:[UIColor colorWithRed:(68/255.0f) green:(85/255.0f) blue:(102/255.0f) alpha:1] iconColor:[UIColor whiteColor] andSize:CGSizeMake(12, 12)];
    }
    
    
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.data objectAtIndex:indexPath.row]objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    cell.nickName.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"NickName"];
    cell.location.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"LocationName"];
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
