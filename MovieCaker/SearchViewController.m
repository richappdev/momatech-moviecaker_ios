//
//  SearchViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/3/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchObj.h"
#import "TopicDetailViewController.h"
#import "VideoContentViewController.h"


@interface SearchViewController ()
    @property(nonatomic,strong) NSNumber *page;
    @property(nonatomic,strong) NSMutableArray *listArray;
    @property(nonatomic,strong) NSString *type;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;

@end

@implementation SearchViewController

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
    [self setupDefaultNavBarButtons];
    self.title=NSLocalizedStringFromTable(@"進階搜尋",@"InfoPlist",nil);
    
    if (![self.lang isEqualToString:@"zh-Hant"]) {
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"影片",@"专题",@"影人",nil];
    }
    
    
    if([self isRunningiOS7]){
        [self.searchBar setTintColor:[UIColor whiteColor]];
    }

    self.page=[NSNumber numberWithInt:1];
    self.isLoading=NO;
    self.isLast=NO;
    self.listArray=[[NSMutableArray alloc] init];
    self.type=@"Movie";
    
    self.myTableView.tableFooterView=nil;
    
    self.touchView.hidden=YES;
    
    [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData:(NSNumber *)page{
    
    self.isLoading=YES;
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self.manager search:self.searchBar.text type:self.type page:self.page callback:^(NSMutableArray *listArray, NSString *errorMsg, NSError *error) {
        
        NSLog(@"%@",listArray);
        
        self.isLoading=NO;
        
        if (listArray.count<10) {
            self.isLast=YES;
        }
        
        if (listArray.count>0) {
            [self.listArray addObjectsFromArray:listArray];
            [self.myTableView reloadData];
        }
        self.myTableView.tableFooterView=nil;
        self.touchView.hidden=YES;

        [WaitingAlert dismiss];
    }];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
    [self.listArray removeAllObjects];
    [self.myTableView reloadData];
    [self loadData:@(1)];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    //self.touchView.hidden=NO;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
    //UISegmentedControl *control=sender;
    
    if (selectedScope==0){
        self.type=@"Movie";
    }else if(selectedScope==1){
        self.type=@"Topic";
    }else{
        self.type=@"Actor";
    }
    
};


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SearchObj *obj=[self.listArray objectAtIndex:indexPath.row];
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        cell.textLabel.text =obj.label;
    }else{
        cell.textLabel.text =obj.lableCn;
    }
    return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchObj *obj=[self.listArray objectAtIndex:indexPath.row];
    
    if ([obj.value isEqualToString:@"Topic"]) {
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
       // [NSNumber numberWithInteger: [obj.Id integerValue]];
        topicDetailVC.topicId= [NSNumber numberWithInteger: [obj.Id integerValue]];
        topicDetailVC.channel=@"Activity";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
        
    }else if([obj.value isEqualToString:@"Movie"]){
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=obj.Id;
        vcvc.landingNo=0;
        [self.navigationController pushViewController:vcvc animated:YES];
    }else{
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.actorId=[NSNumber numberWithInteger: [obj.Id integerValue]];
        topicDetailVC.channel=@"Actor";
        if (![self.lang isEqualToString:@"zh-Hant"]) {
            topicDetailVC.actorName=obj.label;
        }else{
            topicDetailVC.actorName=obj.lableCn;
        }
        
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }
}
/*
- (void)configureCell:(TopicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TopicObj *topic=self.listArray[indexPath.row];
    cell.topic=topic;
    
    cell.header.text=[NSString stringWithFormat:@"%@(%d)",topic.title,topic.videoCount.intValue];
    
    cell.viewNumLabel.text=[NSString stringWithFormat:@"%@ 瀏覽",topic.viewNum.stringValue];
    
    if ([self.manager isLogined]) {
        cell.likeButton.enabled=YES;
        if (topic.isLiked.boolValue) {
            cell.likeButton.selected=YES;
        }else{
            cell.likeButton.selected=NO;
        }
        
    }else{
        [cell.likeButton setImage:[UIImage imageNamed:@"love_disable.png"] forState:UIControlStateNormal];
    }
    
    NSArray *jpgAry=[topic.picture componentsSeparatedByString:@","];
    
    [cell.imageView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[0]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        
    }];
    
    [cell.imageView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[1]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    
    [cell.imageView3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[2]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    [cell.imageView4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[3]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    [cell.imageView5 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[4]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    cell.content.text=topic.content;
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://happymovie.tv/UserAvatar/%@",topic.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    cell.nickName.text=topic.nickName;
    
    cell.createdOn.text=[self.df stringFromDate:topic.createdOn];
    cell.indexPath=indexPath;
    cell.delegate=self;
    
}
- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VideoObj *video=self.listArray[indexPath.row];
    
    cell.video=video;

    cell.name.text=video.name;
    cell.enName.text=video.enName;
    
    [cell updateVideoInfo];
    
    if (![self.manager isLogined]) {
        cell.likeButton.backgroundColor=[UIColor lightGrayColor];
        cell.seenButton.backgroundColor=[UIColor lightGrayColor];
        cell.watchButton.backgroundColor=[UIColor lightGrayColor];
        cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
        cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        cell.addTopicButton.backgroundColor=[UIColor lightGrayColor];
    }else{
        
        NSComparisonResult result=[[NSDate date] compare:[self stringToDate:video.releaseDate]];
        
        
        if (result==NSOrderedDescending) {
            cell.seenButton.backgroundColor=[UIColor lightGrayColor];
            cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
            cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        }else{
            if (video.isViewed.boolValue) {
                cell.seenButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
                cell.seenButton.selected=YES;
                
            }else{
                cell.seenButton.backgroundColor=[UIColor grayColor];
                cell.seenButton.selected=NO;
            }
        }
        
        if (video.isLiked.boolValue) {
            cell.likeButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            cell.likeButton.selected=YES;
            
        }else{
            cell.likeButton.backgroundColor=[UIColor grayColor];
            cell.likeButton.selected=NO;
        }
        
        
        if (video.isWantView.boolValue) {
            cell.watchButton.backgroundColor=[UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0];
            cell.watchButton.selected=YES;
            
        }else{
            cell.watchButton.backgroundColor=[UIColor grayColor];
            cell.watchButton.selected=NO;
        }
        
        
    }
    
    NSString *path=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",video.picture];
    
    [cell.videoImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
}

- (void)configureLineUpCell:(LineUpCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=cell.indexPath.row) {
        //self.lineUpHeight=[cell lineSet:self.listArray];
        cell.indexPath=indexPath;
        cell.delegate=self;
    }
    
    
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
    self.touchView.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
    self.touchView.hidden=YES;
}
/*
- (IBAction)didChangeSegmentControl:(id)sender {
    
    UISegmentedControl *control=sender;
    
    if (control.selectedSegmentIndex==0){
        self.type=@"Movie";
    }else if(control.selectedSegmentIndex==1){
        self.type=@"Topic";
    }else{
        self.type=@"Actor";
    }
}
 */

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isLoading) {
        return;
    }
    if (self.isLast) {
        return;
    }
    
    float pointY=scrollView.contentOffset.y;
    float startLoadY=scrollView.contentSize.height-self.view.frame.size.height;
    
    if (pointY>startLoadY) {
        self.page=@(self.page.intValue+1);
        self.myTableView.tableFooterView=self.footView;
        self.moreLabel.text=NSLocalizedStringFromTable(@"載入更多",@"InfoPlist",nil);
        [self loadData:self.page];
    }
}
@end
