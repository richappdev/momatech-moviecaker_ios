//
//  MyTopicChildViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/24.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "MyTopicChildViewController.h"
#import "TopicCell.h"

#import "TopicObj.h"
#import "TopicDetailViewController.h"

@interface MyTopicChildViewController ()
    @property(nonatomic,strong)NSArray *topicArray;
    @property (nonatomic, strong) NSDateFormatter *df;
    @property(nonatomic,strong) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property(assign,nonatomic) BOOL isPreview;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyTopicChildViewController

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
    
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userID=self.userInfo[@"UserId"];
    if (userID.intValue==self.friend.userId.intValue) {
        self.title=NSLocalizedStringFromTable(@"我的專題",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@%@%@",self.friend.nickName,NSLocalizedStringFromTable(@"的",@"InfoPlist",nil),NSLocalizedStringFromTable(@"專題",@"InfoPlist",nil)];
    }
    
    
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
    
    self.page=[NSNumber numberWithInt:1];
    
    [self loadData:self.page];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.topicArray.count>0) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void)loadData:(NSNumber *)page{
    

    self.isLoading=YES;
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self.manager getTopicWithId:self.friend.userId.stringValue channel:self.topicChannel withPage:page callback:^(NSArray *topicArray, NSString *errorMsg, NSError *error) {
        
        if (topicArray) {
            self.isLoading=NO;
            self.topicArray=topicArray;
            [self.myTableView reloadData];
            self.myTableView.tableFooterView=nil;
        }
        if (self.topicArray.count>=1) {
            TopicObj *topic=(TopicObj *)self.topicArray[0];
            if (self.topicArray.count==topic.total.intValue) {
                self.isLast=YES;
            }
        }else{
            self.isLast=YES;
        }

        [WaitingAlert dismiss];
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"self.topicArray:%d",self.topicArray.count);
    return self.topicArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我的專題",@"InfoPlist",nil)]) {
            return 116;
        }
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue) {
            return 162;
        }
        return 116;
    }
    return 230;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"MyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row>=1) {
        static NSString *cellIdentifier = @"TopicCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureTopicCell:(TopicCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=1) {
        TopicObj *topic=self.topicArray[indexPath.row-1];
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.topic=topic;
        topicDetailVC.channel=@"InTopic";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }
    
    
}

-(void) configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    NSString *gender =(self.friend.gender.boolValue)? NSLocalizedStringFromTable(@"男",@"InfoPlist",nil):NSLocalizedStringFromTable(@"女",@"InfoPlist",nil);
   // cell.addFriendButton.hidden=YES;
    cell.inviteView.hidden=YES;
    cell.delegate=self;
    
    cell.friend=self.friend;
    
    if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我的專題",@"InfoPlist",nil)]) {
        cell.inviteView.hidden=YES;
        cell.addFriendButton.hidden=YES;
    }else{
        if (self.friend.isBeingInviting.boolValue) {
            cell.inviteView.hidden=NO;
            cell.inviteWord.text=NSLocalizedStringFromTable(@"寄給你一則交友邀請",@"InfoPlist",nil);
            cell.rejectButton.hidden=NO;
            [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"確認",@"InfoPlist",nil) forState:UIControlStateNormal];
        }else if(self.friend.isInviting.boolValue){
            cell.inviteView.hidden=NO;
            cell.inviteWord.text=NSLocalizedStringFromTable(@"你已寄出交友邀請",@"InfoPlist",nil);
            cell.rejectButton.hidden=YES;
            [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil) forState:UIControlStateNormal];
        }else{
            cell.inviteView.hidden=YES;
        }
        
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue ) {
            cell.addFriendButton.hidden=YES;
            
        }else{
            if (self.friend.isFriend.boolValue) {
                cell.addFriendButton.hidden=NO;
                cell.addFriendButton.enabled=NO;
                [cell.addFriendButton setTitle:NSLocalizedStringFromTable(@"朋友",@"InfoPlist",nil) forState:UIControlStateDisabled];
            }else{
                cell.addFriendButton.hidden=NO;
                cell.addFriendButton.enabled=YES;
                [cell.addFriendButton setTitle:NSLocalizedStringFromTable(@"加入朋友",@"InfoPlist",nil) forState:UIControlStateNormal];
            }
            
        }
    }
    
    
     
    
    cell.userName.text=[NSString stringWithFormat:@" %@ %@ %@",self.friend.nickName,self.friend.locationName,gender];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.friend.avatar];
    
    NSURL *bannerUrl=[self getUesrBannerUrl:self.friend.userId];
    
    [cell.userBanner setImageWithURL:bannerUrl placeholderImage:nil];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
}

-(void) configureTopicCell:(TopicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.friendView.hidden=YES;
    cell.topicView.frame=CGRectMake(5, 3, 309, 230);
    cell.buttonView.hidden=YES;

    TopicObj *topic=(TopicObj *)self.topicArray[indexPath.row-1];
    cell.header.text=[NSString stringWithFormat:@"%@(%d)",topic.title,topic.videoCount.intValue];
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
    
    cell.content.text=[topic.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,topic.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    cell.nickName.text=topic.nickName;
    
    cell.createdOn.text=[self.df stringFromDate:topic.createdOn];
    
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
