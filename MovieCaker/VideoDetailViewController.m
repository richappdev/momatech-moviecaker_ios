//
//  VideoDetailViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/22.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "FilmReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "VideoIntroCell.h"
#import "ReviewMoreCell.h"
#import "TopicDetailViewController.h"
#import "JoinTopicViewController.h"

@interface VideoDetailViewController ()
    @property (nonatomic, strong) NSString *lineUp;
    @property (nonatomic, strong) NSNumber *lineUpHeight;
    @property (nonatomic, assign) float introHeight;
    @property (nonatomic, strong) NSArray *actorArray;
    @property (nonatomic, assign) BOOL introOpen;

@end

@implementation VideoDetailViewController

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
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    
     self.title=self.video.name;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    //演員陣容
    self.actorArray=[self.manager getActorWithVideoId:self.video.videoID];
    
    self.introOpen=NO;

    //影片介紹
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        self.introHeight=[self getContentHeight:self.video.intro width:300 fontSize:15]+30;
    }else{
        self.introHeight=[self getContentHeight:self.video.cnIntro width:300 fontSize:15]+30;
    }
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MovieListCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"LineUpCell" bundle:nil] forCellReuseIdentifier:@"LineUpCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"VideoIntroCell" bundle:nil] forCellReuseIdentifier:@"VideoIntroCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ReviewMoreCell" bundle:nil] forCellReuseIdentifier:@"ReviewMoreCell"];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[SVProgressHUD dismiss];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [WaitingAlert dismiss];
   // NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    //[self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

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
    
    //NSLog(@"%d",self.video.reviewNum.intValue);
   // if (self.video.reviewNum.intValue==0){
        //return 3;
    //}
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 220;
    }else{
        return self.introHeight;
    }
    
    /*
    if (indexPath.row==0) {
        return 220;
    }else if(indexPath.row==1){
        if (self.actorArray.count==0) {
            return 0;
        }else{
            return self.lineUpHeight.intValue;
        }
    }else if(indexPath.row==2){
        if (self.introOpen) {
            return self.introHeight;
        }else{
            return self.introHeight>75?75:self.introHeight;
        }
    }else{
        if (self.video.reviewNum.intValue==0) {
            return 0;
        }
        return 44;
    }
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
        [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
        return cell;
    }
    /*
    if(indexPath.row == 1)
    {
        LineUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LineUpCell"];
        [self configureLineUpCell:(LineUpCell *)cell atIndexPath:indexPath];
        return cell;
    }
     */
    if(indexPath.row == 1)
    {
        VideoIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoIntroCell"];
        [self configureVideoIntroCell:(VideoIntroCell *)cell atIndexPath:indexPath];
        return cell;
    }
    /*
    if(indexPath.row == 3)
    {
        ReviewMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewMoreCell"];
        [self configureReviewMoreCell:(ReviewMoreCell *)cell atIndexPath:indexPath];
        return cell;
    }
     */
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ReviewMoreCell class]]) {
        FilmReviewViewController *frvc=[[FilmReviewViewController alloc] initWithNibName:@"FilmReviewViewController" bundle:nil];
        frvc.video=self.video;
        [self.navigationController pushViewController:frvc animated:YES];
    }
    
    if (indexPath.row==2) {
        self.introOpen=!self.introOpen;
        [self.myTableView reloadData];
    }
    
}

- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *path=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",self.video.picture];

    [cell.videoImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"noMoviePoster.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

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

- (void)configureLineUpCell:(LineUpCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=cell.indexPath.row) {
        self.lineUpHeight=[cell lineSet:self.actorArray];
        cell.indexPath=indexPath;
        cell.delegate=self;
    }

    
}
- (void)configureVideoIntroCell:(VideoIntroCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (self.introOpen) {
        cell.intro.numberOfLines=0;
        cell.intro.lineBreakMode=NSLineBreakByWordWrapping;
        cell.intro.frame=CGRectMake(10, 5, 300, self.introHeight);
    }else{
        cell.intro.numberOfLines=3;
        cell.intro.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.intro.frame=CGRectMake(10, 5, 300, 70);
    }
     */
    cell.intro.numberOfLines=0;
    cell.intro.lineBreakMode=NSLineBreakByWordWrapping;
    cell.intro.frame=CGRectMake(10, 5, 300, self.introHeight);
    
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        
        if (![self.video.intro isEqualToString:@"N/A"]) {
            cell.intro.text=self.video.intro;
        }else{
            cell.intro.text=@"";
        }
        
        NSLog(@"self.video.intro:%@",self.video.intro);
    }else{
        
        if (![self.video.cnIntro isEqualToString:@"N/A"]) {
            cell.intro.text=self.video.cnIntro;
        }else{
            cell.intro.text=@"";
        }
        NSLog(@"self.video.cnIntro:%@",self.video.cnIntro);
    }
   
}
- (void)configureReviewMoreCell:(ReviewMoreCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)clickActor:(NSNumber *)actorId withActorName:(NSString *)actorName{
    
    TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
    topicDetailVC.actorId=actorId;
    topicDetailVC.channel=@"Actor";
    topicDetailVC.actorName=actorName;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
