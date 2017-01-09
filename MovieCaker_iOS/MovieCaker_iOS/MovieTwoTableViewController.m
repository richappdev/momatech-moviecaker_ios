//
//  MovieTwoTableViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/19/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTwoTableViewController.h"
#import "MovieTabCell.h"
#import "Movie2Cell.h"
#import "AustinApi.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MovieTwoTableViewController ()
@property MovieViewController *parentController;
@property BOOL simplified;
@end

@implementation MovieTwoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ParentController:(MovieViewController *)movie{
    self.parentController = movie;
    self.tableView.allowsSelection = YES;
    self.simplified = [[[NSUserDefaults standardUserDefaults] objectForKey:@"simplified"] boolValue];
    NSLog(@"simplified%d",self.simplified);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

-(void)gotoEdit:(long)row{
    self.selectIndex =row;
    self.parentController.newReview = YES;
    [self.parentController performSegueWithIdentifier:@"reviewSegue" sender:self];
    NSLog(@"aa%ld",row);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.row>=self.page*10-1){
        self.page =self.page+1;
        [self.parentController loadMore:self.page];
        //loadmore
    }
    if(self.type == 0||self.type == 1||self.type==2){
        MovieTabCell *cell;
        if(self.type==2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableTwo" forIndexPath:indexPath];
            cell.ratingBg.hidden = YES;
            cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableOne" forIndexPath:indexPath];
            if(self.type==0&&self.hideRating == YES){
                cell.ratingBg.hidden = YES;
            }else{
                cell.ratingBg.hidden = NO;
            }
    }
    cell.index =indexPath.row;
    cell.parent= self;
    NSMutableDictionary *data = [self.data objectAtIndex:indexPath.row];
    cell.data = data;
        if(self.simplified){
            cell.title.text = [data objectForKey:@"CNName"];}
        else{
            cell.title.text = [data objectForKey:@"Name"];
        }
    NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[data objectForKey:@"Picture"]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder-poster.jpg"]];
    cell.imdb.text = [self testNil:[data objectForKey:@"Ratings_IMDB"]];
    if([cell.imdb.text isEqualToString:@""]){
        cell.imdbWhole.hidden = YES;
    }else{
        cell.imdbWhole.hidden = NO;
    }
    cell.dou.text = [self testNil:[data objectForKey:@"Ratings_Douban"]];
        if([cell.dou.text isEqualToString:@""]){
            cell.douWhole.hidden = YES;
        }else{
            cell.douWhole.hidden = NO;
        }
    cell.date.text = [NSString stringWithFormat:@"%@ 上映",[data objectForKey:@"ReleaseDate"]];
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    cell.liked.text = [[data objectForKey:@"LikeNum"]stringValue];
    cell.favored.text = [[data objectForKey:@"WantViewNum"]stringValue];
    cell.reviewed.text = [[data objectForKey:@"ReviewNum"]stringValue];
    cell.viewed.text = [[data objectForKey:@"ViewNum"]stringValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    [cell setWatchState:[[data objectForKey:@"IsViewed"] boolValue]];
    [cell setLikeState:[[data objectForKey:@"IsLiked"] boolValue]];
    [cell setWannaState:[[data objectForKey:@"IsWantView"] boolValue]];
        
    return cell;
    }else if (self.type == 2){
    MovieTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableTwo" forIndexPath:indexPath];
        cell.ratingBg.hidden = NO;
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        return cell;
    }else if (self.type ==3){
    Movie2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableThree" forIndexPath:indexPath];
        NSDictionary *data =[self.data objectAtIndex:indexPath.row];
        //     NSLog(@"%@",data);
        cell.Id =[data objectForKey:@"ReviewId"];
        cell.videoId = [data objectForKey:@"VideoId"];
        if(self.simplified){
            cell.Title.text = [data objectForKey:@"VideoCNName"];
        }else{
            cell.Title.text = [data objectForKey:@"VideoName"];
            }
        cell.Content.text = [data objectForKey:@"Review"];
        cell.CreatedOn.text = [[data objectForKey:@"CreateOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        cell.CreatedOn.text = [cell.CreatedOn.text substringWithRange:NSMakeRange(0,[cell.CreatedOn.text rangeOfString:@"T"].location)];
        cell.Author.text = [data objectForKey:@"UserNickName"];
        cell.Messages.text = [[data objectForKey:@"MessageNum"]stringValue];
        cell.Views.text = [[data objectForKey:@"PageViews"]stringValue];
        NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[data objectForKey:@"VideoPicture"]];
        [cell.mainPic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder-poster.jpg"]];
        
        [cell.AvatarPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[data objectForKey:@"UserAvatar"]]]];
         if(![[data objectForKey:@"OwnerLinkVideo_Score"] isKindOfClass:[NSNull class]]){
             [cell setStars:floor([[data objectForKey:@"OwnerLinkVideo_Score"]floatValue])];}
         else{
             [cell setStars:0];
         }
        if([[data objectForKey:@"OwnerLinkVideo_IsLiked"]intValue]==0){
            cell.Heart.image = [UIImage imageNamed:@"iconHeartList.png"];
        }else{
            cell.Heart.image = [UIImage imageNamed:@"iconHeartListLiked.png"];
        }
        [cell setLikeState:[[data objectForKey:@"IsLiked"] boolValue]];
        [cell setShareState:[[data objectForKey:@"IsShared"] boolValue]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([data objectForKey:@"LikedNum"] != NULL)
            cell.likeLabel.text = [NSString stringWithFormat:@"喜歡   %@",[data objectForKey:@"LikedNum"]];
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectIndex = indexPath.row;
    if(self.type!=3){
        [self.parentController performSegueWithIdentifier:@"movieDetail" sender:self];
    }else{
        [self.parentController performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
}
@end
