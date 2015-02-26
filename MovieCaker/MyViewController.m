//
//  MyViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MyViewController.h"

#import "MyChannelCell.h"
#import "MyVideoViewController.h"
#import "MyTopicViewController.h"
#import "MySchoolPartyViewController.h"
#import "MyFriendsViewController.h"
#import "MyActivityViewController.h"

@interface MyViewController ()
    @property (nonatomic, strong) NSArray *unitAry;
    @property (nonatomic, strong) NSArray *unitIcons;
    @property (nonatomic, strong) NSDictionary *userDashBoard;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyViewController

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
    
    if (self.friend) {
        
        self.userDashBoard=[self getUserDashboard:self.friend.userId];
        
        NSLog(@"%@",self.userDashBoard);
        
        if (userID.intValue==self.friend.userId.intValue) {
            [self setupDefaultNavBarButtons];
            self.title=NSLocalizedStringFromTable(@"我自己",@"InfoPlist",nil);
            
        }else{
            
            self.title=self.friend.nickName;
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
            left.frame = CGRectMake(0, 0, 32, 32);
            left.showsTouchWhenHighlighted = YES;
            [left addTarget:self
                     action:@selector(back:)
           forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
             [self loadData];
        }
    }else{
  
        
        
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        left.frame = CGRectMake(0, 0, 32, 32);
        left.showsTouchWhenHighlighted = YES;
        [left addTarget:self
                 action:@selector(back:)
       forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        
        [self loadData];
    }

    self.unitIcons = [NSArray arrayWithObjects:@"", @"我的頁面Icon01.png", @"我的頁面Icon02.png", @"我的頁面Icon03.png", @"我的頁面Icon04.png", @"我的頁面Icon05.png", @"我的頁面Icon06.png", nil];
    self.unitAry = @[@"",
                     NSLocalizedStringFromTable(@"電影",@"InfoPlist",nil),
                     NSLocalizedStringFromTable(@"專題",@"InfoPlist",nil),
                     NSLocalizedStringFromTable(@"社團",@"InfoPlist",nil),
                     NSLocalizedStringFromTable(@"朋友",@"InfoPlist",nil),
                     NSLocalizedStringFromTable(@"動態",@"InfoPlist",nil)];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyChannelCell" bundle:nil] forCellReuseIdentifier:@"MyChannelCell"];

}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.friend.userId){
        self.userDashBoard=[self getUserDashboard:self.friend.userId];
        [self.myTableView reloadData];
    }
    
}

-(void)loadData{
    
    NSNumber *ID;
    
    if (self.userId) {
        ID=self.userId;
    }else{
        ID=self.friend.userId;
    }
    
    [self.manager userProfile:ID callback:^(FriendObj *friend, NSString *errorMsg, NSError *error) {
        self.friend=friend;
        
        NSNumber *userID=self.userInfo[@"UserId"];
        
        if (userID.intValue == self.friend.userId.intValue) {

            self.title=NSLocalizedStringFromTable(@"我自己",@"InfoPlist",nil);
        }else{
            self.title=self.friend.nickName;
        }
        
        self.userDashBoard=[self getUserDashboard:self.friend.userId];
        [self.myTableView reloadData];
    }];
}

#pragma mark - MyHeaderCellDelegate
- (void)refreshData {
    [self loadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friend) {
        return self.unitAry.count;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我自己",@"InfoPlist",nil)]) {
            return 116;
        }
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue) {
            return 162;
        }
        return 116;
    }
    else {
        return 67;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier = @"MyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    if(indexPath.row >= 1)
    {
        static NSString *cellIdentifier = @"MyChannelCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyChannelCell:(MyChannelCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        MyVideoViewController *mvvc=[[MyVideoViewController alloc] initWithNibName:@"MyVideoViewController" bundle:nil];
        mvvc.friend=self.friend;
        [self.navigationController pushViewController:mvvc animated:YES];
    }
    if (indexPath.row==2) {
        MyTopicViewController *mtvc=[[MyTopicViewController alloc] initWithNibName:@"MyTopicViewController" bundle:nil];
        mtvc.friend=self.friend;
        [self.navigationController pushViewController:mtvc animated:YES];
    }
    if (indexPath.row==3) {
        MySchoolPartyViewController *mspvc=[[MySchoolPartyViewController alloc] initWithNibName:@"MySchoolPartyViewController" bundle:nil];
         mspvc.friend=self.friend;
        [self.navigationController pushViewController:mspvc animated:YES];
    }
    
    if (indexPath.row==4) {
        MyFriendsViewController *mfvc=[[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:nil];
        mfvc.friend=self.friend;
        [self.navigationController pushViewController:mfvc animated:YES];
    }
    
    if (indexPath.row==5) {
        MyActivityViewController *mavc=[[MyActivityViewController alloc] initWithNibName:@"MyActivityViewController" bundle:nil];
        mavc.friend=self.friend;
        [self.navigationController pushViewController:mavc animated:YES];  
    }
    
}

-(void) configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gender =(self.friend.gender.boolValue)? NSLocalizedStringFromTable(@"男",@"InfoPlist",nil):NSLocalizedStringFromTable(@"女",@"InfoPlist",nil);
    
    cell.delegate=self;
    
    cell.friend=self.friend;
    
    if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我自己",@"InfoPlist",nil)]) {
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
        
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue) {
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

-(void) configureMyChannelCell:(MyChannelCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    [cell.channelIcon setImage:[UIImage imageNamed:self.unitIcons[indexPath.row]]];
    
    NSString *channelTitle=self.unitAry[indexPath.row];
    cell.channelTitle.text=[NSString stringWithFormat:@"%@%@%@",self.friend.nickName,NSLocalizedStringFromTable(@"的",@"InfoPlist",nil),channelTitle];
    NSNumber *count=[NSNumber numberWithInt:0];
    
    
    NSNumber *likeCount=self.userDashBoard[@"Data"][@"LikeCount"];
    NSNumber *viewCount=self.userDashBoard[@"Data"][@"ViewCount"];
    NSNumber *wantViewCount=self.userDashBoard[@"Data"][@"WantViewCount"];
    
    NSInteger totalSocialCount=likeCount.integerValue+viewCount.integerValue+wantViewCount.integerValue;
    
    if ([channelTitle isEqualToString:NSLocalizedStringFromTable(@"電影",@"InfoPlist",nil)]) {
        count=self.userDashBoard[@"Data"][@"ViewCount"];
    }
    if ([channelTitle isEqualToString:NSLocalizedStringFromTable(@"專題",@"InfoPlist",nil)]) {
        count=self.userDashBoard[@"Data"][@"TopicCount"];
    }
    if ([channelTitle isEqualToString:NSLocalizedStringFromTable(@"社團",@"InfoPlist",nil)]) {
        count=self.userDashBoard[@"Data"][@"ClubCount"];
    }
    if ([channelTitle isEqualToString:NSLocalizedStringFromTable(@"朋友",@"InfoPlist",nil)]) {
        count=self.userDashBoard[@"Data"][@"FriendCount"];
        
        NSLog(@"%@",count.stringValue);
    }
    if ([channelTitle isEqualToString:NSLocalizedStringFromTable(@"動態",@"InfoPlist",nil)]) {
        count=[NSNumber numberWithInteger:totalSocialCount];
    }
    cell.countLabel.text=[NSString stringWithFormat:@"(%@)",count.stringValue];
    
    //{"MovieCount":100,"TopicCount":11,"ClubCount":9,"FriendCount":8,"NotificationCount":1}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
