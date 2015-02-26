//
//  RightViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "RightViewController.h"
#import "MyViewController.h"
#import "MainMenuCell.h"
#import "CheckInViewController.h"
#import "UIImageView+WebCache.h"
//#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "TopicViewController.h"
#import "CardViewController.h"
#import "FriendObj.h"
#import "ProfileViewController.h"
#import "FriendSearchViewController.h"
#import "InviteViewController.h"
#import "NotificationViewController.h"
#import "InboxViewController.h"
//#import "LoginViewController.h"

@interface RightViewController ()
    @property (nonatomic, strong) UIViewController *myViewController;
    @property (nonatomic, strong) UIViewController *checkInViewComtroller;
    @property (nonatomic, strong) UIViewController *topicViewController;
    @property (nonatomic, strong) UIViewController *cardViewController;
    @property (nonatomic, strong) UIViewController *profileViewController;
    @property (nonatomic, strong) UIViewController *friendSearchViewController;
    @property (nonatomic, strong) UIViewController *inviteViewController;
    @property (nonatomic, strong) UIViewController *notificationViewController;
    @property (nonatomic, strong) UIViewController *inboxViewController;
    @property (nonatomic, strong) NSArray *unitAry;
    @property (nonatomic, strong) NSArray *unitIcons;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (nonatomic, strong) FriendObj *friend;
@end

@implementation RightViewController

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
    
    self.friend=[[FriendObj alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MainMenuCell" bundle:nil] forCellReuseIdentifier:@"MainMenuCell"];
    
    if ([self isRunningiOS7]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:INBOX_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.myTableView reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.myTableView reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:INVITING_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.myTableView reloadData];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.manager isLogined]) {
        
        self.userInfo=[self.manager getLoginUnfo];
        
        NSLog(@"self.userInfo:%@",self.userInfo);
        self.unitAry =@[self.userInfo[@"NickName"],
                        NSLocalizedStringFromTable(@"QR CODE 名片",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"尋找朋友",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"個人資料設置",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"交友邀請",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"通知",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"訊息",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"登出",@"InfoPlist",nil)];
        self.unitIcons =@[self.userInfo[@"Avatar"],@"rightIcon07.png",@"rightIcon08.png",@"rightIcon09.png",@"dating.png",@"new.png",@"mail.png",@"rightIcon10.png"];
        [self convertMyDataToFriend];
        
    }else{
        self.unitAry =@[NSLocalizedStringFromTable(@"登入",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"條碼打卡",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"QR CODE 名片",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"尋找朋友",@"InfoPlist",nil),
                        NSLocalizedStringFromTable(@"個人資料設置",@"InfoPlist",nil)];
        self.unitIcons =@[@"",@"rightIcon06.png", @"rightIcon07.png",@"rightIcon08.png",@"rightIcon09.png",@"rightIcon10.png"];
    }
    
    [self.myTableView reloadData];
}

-(void)convertMyDataToFriend{
    
    NSLog(@"convertMyDataToFriend");
    
    self.friend.ownerId=self.userInfo[@"UserId"];
    NSString *avatar=[NSString stringWithFormat:@"%@",self.userInfo[@"Avatar"]];
    if (![avatar isEqualToString:@"<null>"]) {
         self.friend.avatar=avatar;
    }else{
         self.friend.avatar=@"";
    }
    
     self.friend.nickName=self.userInfo[@"NickName"];
     self.friend.userId=self.userInfo[@"UserId"];
     self.friend.userName=self.userInfo[@"UserName"];
    
    NSString *fristName=[NSString stringWithFormat:@"%@",self.userInfo[@"FristName"]];
    if (![fristName isEqualToString:@"<null>"]) {
         self.friend.fristName=fristName;
    }else{
         self.friend.fristName=@"";
    }
    
    NSString *lastName=[NSString stringWithFormat:@"%@",self.userInfo[@"lastName"]];
    if (![lastName isEqualToString:@"<null>"]) {
         self.friend.lastName=lastName;
    }else{
         self.friend.lastName=@"";
    }
    
     self.friend.brithDay=self.userInfo[@"BrithDay"];
     self.friend.location=self.userInfo[@"Location"];
     self.friend.locationName=self.userInfo[@"LocationName"];
    
    NSString *intro=[NSString stringWithFormat:@"%@",self.userInfo[@"Intro"]];
    
    NSLog(@"intro");
    if (![intro isEqualToString:@"<null>"]) {
         self.friend.intro=intro;
    }else{
         self.friend.intro=@"";
    }
    
     self.friend.masterLocation=self.userInfo[@"MasterLocation"];
    
    NSString *gender=[NSString stringWithFormat:@"%@",self.userInfo[@"Gender"]];
    
    NSLog(@"gender:%@",self.userInfo[@"Gender"]);
    
    if (![gender isEqualToString:@"<null>"]) {
         self.friend.gender=self.userInfo[@"Gender"];
    }
    
    self.friend.isCompleteEditProfile=self.userInfo[@"IsCompleteEditProfile"];
    self.friend.editStage=self.userInfo[@"EditStage"];
    
    NSString *bannerType=[NSString stringWithFormat:@"%@",self.userInfo[@"BannerType"]];
    if (![bannerType isEqualToString:@"<null>"]) {
        self.friend.bannerType=self.userInfo[@"BannerType"];
    }
    
    self.friend.banner=self.userInfo[@"Banner"];
    self.friend.isFriend=[NSNumber numberWithBool:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.unitAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MainMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:(MainMenuCell *)cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        if ([self.manager isLogined]) {
            if (!self.myViewController) {
                self.myViewController=nil;
            }
                MyViewController *myvc = [[MyViewController alloc] init];
                myvc.friend=self.friend;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myvc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
                self.myViewController = nav;
            
            
            [self configureCenterViewController:self.myViewController];
        }else{
            
            self.appDelegate.autoLogin=YES;
            
            if(!self.topicViewController)
            {
                self.topicViewController=nil;
            }
            
            TopicViewController *topicView = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
            topicView.channel=@"Ten";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:topicView];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            
            self.topicViewController = nav;
            [self configureCenterViewController:self.topicViewController];

        }
        
    }

    if(indexPath.row==1)
    {
        if ([self.manager isLogined]) {
            if (!self.cardViewController) {
                CardViewController *cvc = [[CardViewController alloc] init];
                cvc.friend=self.friend;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                
                self.cardViewController = nav;
            }
            
            [self configureCenterViewController:self.cardViewController];
        }
    }
    
    if(indexPath.row==2)
    {
        if ([self.manager isLogined]) {
            if (!self.friendSearchViewController) {
                FriendSearchViewController *fsvc = [[FriendSearchViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fsvc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                
                self.friendSearchViewController = nav;
            }
            
            [self configureCenterViewController:self.friendSearchViewController];
        }
    }
    
    
     if(indexPath.row==3)
     {
         if ([self.manager isLogined]) {
             self.profileViewController=nil;
             if (!self.profileViewController) {
                 ProfileViewController *pvc = [[ProfileViewController alloc] init];
                 pvc.friend=self.friend;
                 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pvc];
                 [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
     
                 self.profileViewController = nav;
             }
     
             [self configureCenterViewController:self.profileViewController];
         }
     }
    
    if(indexPath.row==4)
    {
        if ([self.manager isLogined]) {
            self.inviteViewController=nil;
            if (!self.inviteViewController) {
                InviteViewController *ivc = [[InviteViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ivc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                
                self.inviteViewController = nav;
            }
            
            [self configureCenterViewController:self.inviteViewController];
        }
    }
    
    if(indexPath.row==5)
    {
        if ([self.manager isLogined]) {
            self.notificationViewController=nil;
            if (!self.notificationViewController) {
                NotificationViewController *nvc = [[NotificationViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nvc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                
                self.notificationViewController = nav;
            }
            
            [self configureCenterViewController:self.notificationViewController];
        }
    }
    
    if(indexPath.row==6)
    {
        if ([self.manager isLogined]) {
            self.inboxViewController=nil;
            if (!self.inboxViewController) {
                InboxViewController *invc = [[InboxViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:invc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                
                self.inboxViewController = nav;
            }
            
            [self configureCenterViewController:self.inboxViewController];
        }
    }
    
    if(indexPath.row==7)
    {
        if ([self.manager isLogined]) {
            [self.manager logout];
            self.appDelegate.autoLogin=YES;
            
            if(!self.topicViewController)
            {
                self.topicViewController=nil;
            }
            
            TopicViewController *topicView = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
            topicView.channel=@"Ten";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:topicView];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            
            self.topicViewController = nav;
            [self configureCenterViewController:self.topicViewController];
            //[self.revealViewController rightRevealToggleAnimated:YES];
        }
    }
    

    
    
}

- (void)configureCell:(MainMenuCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    

    
    
    cell.unitHeader.frame=CGRectMake(120, 12, 180, 20);
    
    cell.unitHeader.text=self.unitAry[indexPath.row];
    
    if ([self.manager isLogined]) {
        [cell.unitHeader setTextColor:[UIColor whiteColor]];
    }else{
        if (indexPath.row==0) {
            [cell.unitHeader setTextColor:[UIColor whiteColor]];
        }else{
           [cell.unitHeader setTextColor:[UIColor grayColor]];
        }
        
    }
    
    NSString *imageName=self.unitIcons[indexPath.row];
    cell.unitIcon.frame=CGRectMake(83, 7, 30, 30);
    if (indexPath.row==0) {
        cell.unitIcon.contentMode=UIViewContentModeScaleToFill;
    }else{
        cell.unitIcon.contentMode=UIViewContentModeCenter;
    }
    
    
    
    if (indexPath.row==0) {
        if ([self.manager isLogined]) {
            NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,imageName];
            [cell.unitIcon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
        }else{
             [cell.unitIcon setImage:[UIImage imageNamed:@"nobody.jpg"]];
        }
    }else{
        [cell.unitIcon setImage:[UIImage imageNamed:imageName]];
    }
    
    
    
    if (indexPath.row==4) {
        if ([self.manager isLogined]) {
            cell.badgeView.text=[self.manager invitingCount];
            if ([cell.badgeView.text isEqualToString:@"0"]) {
                cell.badgeView.hidden=YES;
            }else{
                cell.badgeView.hidden=NO;
            }
        }else{
            cell.badgeView.hidden=YES;
        }
        
    }
    if (indexPath.row==5) {
        if ([self.manager isLogined]) {
            cell.badgeView.text=[self.manager notificationCount];
            if ([cell.badgeView.text isEqualToString:@"0"]) {
                cell.badgeView.hidden=YES;
            }else{
                cell.badgeView.hidden=NO;
            }
        }else{
            cell.badgeView.hidden=YES;
        }
        
    }
    if (indexPath.row==6) {
        if ([self.manager isLogined]) {
            cell.badgeView.text=[self.manager inboxCount];
            if ([cell.badgeView.text isEqualToString:@"0"]) {
                cell.badgeView.hidden=YES;
            }else{
                cell.badgeView.hidden=NO;
            }
        }else{
            cell.badgeView.hidden=YES;
        }
    }
    
    cell.badgeView.badgeColor = [UIColor redColor];
    cell.badgeView.textColor = [UIColor whiteColor];
    


}

#pragma mark - view controller related

- (void)configureCenterViewController:(UIViewController *)vc
{
    [self.revealViewController setFrontViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
