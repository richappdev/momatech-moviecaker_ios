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
    self.tableHeight.constant = self.cellHeight*[self.data count];
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
    return [self.data count];
}

-(int)returnTotalHeight{
    return [self.data count]*_cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.type==0){
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
        cell.title.text = [[self.data objectAtIndex:indexPath.row]objectForKey:@"Title"];
        cell.Author.text =  [[[self.data objectAtIndex:indexPath.row]objectForKey:@"Author"]objectForKey:@"NickName"];
        cell.Content.text =  [[self.data objectAtIndex:indexPath.row]objectForKey:@"Content"];
        cell.Date.text = [[[self.data objectAtIndex:indexPath.row]objectForKey:@"ModifiedOn"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [cell.AvatarPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[[[self.data objectAtIndex:indexPath.row]objectForKey:@"Author"] objectForKey:@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
        cell.viewCount.text = [[[self.data objectAtIndex:indexPath.row]objectForKey:@"ViewNum"]stringValue];
        NSLog(@"%lu",[[[self.data objectAtIndex:indexPath.row]objectForKey:@"Picture"]count]);
        for(int i =0;i<5;i++){
            UIImageView *view = [cell.imageArray objectAtIndex:i];
            if([[[self.data objectAtIndex:indexPath.row]objectForKey:@"Picture"]count]>i){
                NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[[[self.data objectAtIndex:indexPath.row]objectForKey:@"Picture"]objectAtIndex:i]];
                [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
            }else{
                view.hidden = YES;
            }
        
        }
        cell.Circle.hidden = YES;
        [[AustinApi sharedInstance] getCircleCompletion:[[self.data objectAtIndex:indexPath.row]objectForKey:@"Id"] userId:[[[self.data objectAtIndex:indexPath.row]objectForKey:@"Author"]objectForKey:@"Id"] function:^(NSDictionary *returnData) {
            cell.Circle.hidden = NO;
            [cell setCirclePercentage:[[returnData objectForKey:@"PercentComplete"]floatValue]*0.01];
            [cell.Circle setNeedsDisplay];
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        return cell;
    }else{
            Movie2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Movie2Cell" forIndexPath:indexPath];
        NSDictionary *data =[self.data objectAtIndex:indexPath.row];
   //     NSLog(@"%@",data);
        cell.Title.text = [data objectForKey:@"VideoCNName"];
        cell.Content.text = [data objectForKey:@"Review"];
        cell.CreatedOn.text = [[data objectForKey:@"CreateOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        cell.CreatedOn.text = [cell.CreatedOn.text substringWithRange:NSMakeRange(0,[cell.CreatedOn.text rangeOfString:@"T"].location)];
        cell.Author.text = [data objectForKey:@"UserNickName"];
        cell.Messages.text = [[data objectForKey:@"MessageNum"]stringValue];
        cell.Views.text = [[data objectForKey:@"PageViews"]stringValue];
        NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[data objectForKey:@"VideoPicture"]];
        [cell.mainPic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
        
        [cell.AvatarPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[data objectForKey:@"UserAvatar"]]]];
        if(![[data objectForKey:@"OwnerLinkVideo_Score"] isKindOfClass:[NSNull class]]){
        [cell setStars:floor([[data objectForKey:@"OwnerLinkVideo_Score"]floatValue])];
        }else{
            [cell setStars:0];
        }
        if([[data objectForKey:@"OwnerLinkVideo_IsLiked"]intValue]==0){
            cell.Heart.image = [UIImage imageNamed:@"iconHeartList.png"];
        }else{
            cell.Heart.image = [UIImage imageNamed:@"iconHeartListLiked.png"];
        }
        
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
