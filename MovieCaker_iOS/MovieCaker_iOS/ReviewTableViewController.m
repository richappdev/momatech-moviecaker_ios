//
//  ReviewTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/27/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "ReviewTableViewController.h"
#import "reviewCell.h"
#import "AustinApi.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface ReviewTableViewController ()
@end

@implementation ReviewTableViewController

- (id)init{
    if (self = [super init]) {
        self.array = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float size = 130;
    if([self.array count]>indexPath.row){
  //  NSLog(@"%f",[[self.array objectAtIndex:indexPath.row]floatValue]);'
    float test =[[self.array objectAtIndex:indexPath.row]floatValue];
    if(test>60){
     //   NSLog(@"aa%f",self.tableViewHeight.constant);
        size = 70+test;
    }
    self.tableViewHeight.constant = self.tableViewHeight.constant + size+5;
     //   NSLog(@"asd%f",self.tableViewHeight.constant);
    }
    return size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    reviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *data = [self.data objectAtIndex:indexPath.row];
    cell.content.text = [data objectForKey:@"Message"];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[data objectForKey:@"UserAvatar"]]]];
    cell.author.text = [data objectForKey:@"NickName"];
    cell.heartNum.text = [[data objectForKey:@"LikedAmount"]stringValue];
    if([[data objectForKey:@"IsLiked"]boolValue]){
        cell.heart.image = [UIImage imageNamed:@"iconHeartListLiked.png"];
    }else{
        cell.heartNum.textColor = [UIColor colorWithRed:(159/255.0f) green:(172/255.0f) blue:(181/255.0f) alpha:1];
        cell.heart.image = [UIImage imageNamed:@"iconHeartList.png"];
    }
    cell.date.text = [[data objectForKey:@"ModifyOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    cell.date.text = [cell.date.text substringWithRange:NSMakeRange(0,[cell.date.text rangeOfString:@"T"].location)];
    
    [cell.content sizeToFit];
    if(cell.content.frame.size.height>60){
        cell.contentHeight.constant = cell.content.frame.size.height;
    }
    

    [self.array insertObject:[[NSNumber alloc] initWithFloat:cell.contentHeight.constant] atIndex:indexPath.row];
    
    //NSLog(@"ffs%f",[[self.array objectAtIndex:indexPath.row]floatValue]);
    return cell;
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
