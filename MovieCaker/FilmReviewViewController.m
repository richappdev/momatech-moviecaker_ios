//
//  FilmReviewViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "FilmReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "FilmReviewCell.h"
#import "VideoReview.h"
#import "JoinTopicViewController.h"

@interface FilmReviewViewController ()
    @property (nonatomic, strong) NSArray *reviewArray;
    @property (nonatomic, assign) BOOL isLoading;
@end

@implementation FilmReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title=NSLocalizedStringFromTable(@"電影影評",@"InfoPlist",nil);
    
    self.isLoading=YES;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

    if (self.video.reviewNum.intValue>0) {
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager getVideoReviewWithId:self.video.videoID callback:^(NSArray *reviewArray, NSString *errorMsg, NSError *error) {
            self.reviewArray=reviewArray;
            
            NSLog(@"self.reviewArray.count:%d",self.reviewArray.count);
            
            [WaitingAlert dismiss];
            [self.myTableView reloadData];
            self.isLoading=NO;
        }];
    }
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MovieListCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FilmReviewCell" bundle:nil] forCellReuseIdentifier:@"FilmReviewCell"];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.isLoading) {
         [self.myTableView reloadData];
    }
   
    //[WaitingAlert dismiss];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
   // [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     
}

#pragma mark - MovieCellDelegate

- (void)joinTopic:(VideoObj *)video{
    JoinTopicViewController *jtvc=[[JoinTopicViewController alloc] initWithNibName:@"JoinTopicViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:jtvc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviewArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        VideoReview *review=self.reviewArray[indexPath.row-1];
        float reviewHeight=[self getContentHeight:review.reviewContent width:264 fontSize:13];
        NSLog(@"reviewHeight:%f",reviewHeight);
        if (reviewHeight==0) {
            return 0;
        }else if(reviewHeight<16){
            return 44;
        }else{
            return reviewHeight+29;
        }
    }
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
        [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    if(indexPath.row > 0)
    {
        FilmReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilmReviewCell"];
        [self configureFilmReviewCell:(FilmReviewCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *path=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",self.video.picture];
    
    [cell.videoImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    cell.delegate=self;
    cell.video=self.video;
    
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        cell.name.text=self.video.name;
    }else{
        cell.name.text=self.video.cnName;
    }
    cell.enName.text=self.video.enName;
    
    [cell updateVideoInfo];
    
    
    if (![self.manager isLogined]) {
        cell.likeButton.backgroundColor=[UIColor lightGrayColor];
        cell.seenButton.backgroundColor=[UIColor lightGrayColor];
        cell.watchButton.backgroundColor=[UIColor lightGrayColor];
        //cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
        //cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        //cell.addTopicButton.backgroundColor=[UIColor lightGrayColor];
    }else{
        
        NSComparisonResult result=[[NSDate date] compare:[self stringToDate:self.video.releaseDate]];
        
        
        if (result==NSOrderedAscending) {
            cell.seenButton.backgroundColor=[UIColor lightGrayColor];
            //cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
            //cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        }else{
            if (self.video.isViewed.boolValue) {
                cell.seenButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
                cell.seenButton.selected=YES;
                
            }else{
                cell.seenButton.backgroundColor=[UIColor grayColor];
                cell.seenButton.selected=NO;
            }
        }
        
        if (self.video.isLiked.boolValue) {
            cell.likeButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            cell.likeButton.selected=YES;
            
        }else{
            cell.likeButton.backgroundColor=[UIColor grayColor];
            cell.likeButton.selected=NO;
        }
        
        
        if (self.video.isWantView.boolValue) {
            cell.watchButton.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:195.0/255.0 blue:77.0/255.0 alpha:1.0];
            cell.watchButton.selected=YES;
            
        }else{
            cell.watchButton.backgroundColor=[UIColor grayColor];
            cell.watchButton.selected=NO;
        }
        
        
    }
}


- (void)configureFilmReviewCell:(FilmReviewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VideoReview *review=self.reviewArray[indexPath.row-1];
    self.df.dateFormat = @"yyyy-MM-dd";
    cell.nickName.text=[NSString stringWithFormat:@"%@ %@ %@",review.nickName,NSLocalizedStringFromTable(@"寫於",@"InfoPlist",nil) ,[self.df stringFromDate:review.createdOn]];
    float reviewHeight=[self getContentHeight:review.reviewContent width:264 fontSize:13];
    cell.message.frame=CGRectMake(46, 22, 264, reviewHeight+5);
    cell.message.text=review.reviewContent;
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,review.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
