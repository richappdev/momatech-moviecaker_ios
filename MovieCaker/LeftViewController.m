//
//  LeftViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "LeftViewController.h"
#import "TopicViewController.h"
#import "MainMenuCell.h"
#import "SearchCell.h"
#import "TopicDetailViewController.h"
#import "GlobalViewController.h"
#import "SchoolPartyViewController.h"
#import "ActivityViewController.h"
#import "SearchViewController.h"
#import "APIManager.h"

@interface LeftViewController ()
    @property (nonatomic, strong) UIViewController *topicFirendViewController;
    @property (nonatomic, strong) UIViewController *topicWeekController;
    @property (nonatomic, strong) UIViewController *topic10ViewController;
    @property (nonatomic, strong) UIViewController *videoWeekViewController;
    @property (nonatomic, strong) UIViewController *videoFriendViewController;
    @property (nonatomic, strong) UIViewController *videoGlobalViewController;
    @property (nonatomic, strong) UIViewController *schoolPartyViewController;
    @property (nonatomic, strong) UIViewController *activityViewController;
    @property (nonatomic, strong) UIViewController *searchViewController;
    @property (nonatomic, strong) NSArray *unitAry;
    @property (nonatomic, strong) NSArray *unitIcons;
    @property (nonatomic, strong) NSString *version;
@end

@implementation LeftViewController

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
    
    self.unitAry =@[NSLocalizedStringFromTable(@"進階搜尋",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"專題十大",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"一週專題榜",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"朋友專題",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"一週電影熱點",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"朋友電影熱點",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"全球新片",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"發現社團",@"InfoPlist",nil),
                    NSLocalizedStringFromTable(@"動態消息",@"InfoPlist",nil)];
    self.unitIcons=@[@"",@"leftIcon01.png",@"leftIcon02.png",@"leftIcon03.png",@"leftIcon04.png",@"leftIcon05.png",@"leftIcon06.png", @"leftIcon07.png",@"leftIcon08.png"];

    [self.myTableView registerNib:[UINib nibWithNibName:@"MainMenuCell" bundle:nil] forCellReuseIdentifier:@"MainMenuCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.version = [info objectForKey:@"CFBundleVersion"];

   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    
    [self.myTableView reloadData];
}

-(void)topic{
    
    if(!self.topic10ViewController)
    {
        self.topic10ViewController=nil;
    }
        TopicViewController *t10vc = [[TopicViewController alloc] init];
        t10vc.channel=@"Ten";
        t10vc.showLogin=YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:t10vc];
        
        [nav.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        self.topic10ViewController = nav;
    
    if (self.revealViewController.frontViewController == self.topic10ViewController) {
        //
    }else{
        [self configureCenterViewController:self.topic10ViewController];
    }
}

-(void)goToMain{
    /*
    TopicViewController *t10vc = [[TopicViewController alloc] init];
    t10vc.channel=@"Ten";
    t10vc.showLogin=NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:t10vc];
    [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.topic10ViewController = nav;
    [self configureCenterViewController:self.topic10ViewController];
    [t10vc goToTopicDetail:[NSNumber numberWithInt:3240]];*/
    
    TopicDetailViewController *vc = [[TopicDetailViewController alloc] init];
    vc.channel = @"Week";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.videoWeekViewController = nav;
    
    [self configureCenterViewController:self.videoWeekViewController];
    [vc goToMovieDetail:@"M00000000092390"];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.unitAry.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"SearchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       // [self configureCell:(MainMenuCell *)cell atIndexPath:indexPath];
        return cell;
    }
    static NSString *cellIdentifier = @"MainMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:(MainMenuCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger channelSN=indexPath.row;
    if (channelSN==0) {
        if (!self.searchViewController) {
            SearchViewController *svc = [[SearchViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.searchViewController = nav;
        }
        [self configureCenterViewController:self.searchViewController];
        
    }else if (channelSN==1) {
        if(!self.topic10ViewController){
        
            TopicViewController *t10vc = [[TopicViewController alloc] init];
            t10vc.channel=@"Ten";
            t10vc.showLogin=NO;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:t10vc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.topic10ViewController = nav;
        }
        
        [self configureCenterViewController:self.topic10ViewController];
        
    }else if(channelSN==2){
        
        if(!self.topicWeekController){
        
            TopicViewController *twvc = [[TopicViewController alloc] init];
            twvc.channel=@"Week";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:twvc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.topicWeekController = nav;
        }

        [self configureCenterViewController:self.topicWeekController];
        
    }else if(channelSN==3){
        if ([self.manager isLogined]) {
            if(!self.topicFirendViewController){
            
            TopicViewController *tfvc = [[TopicViewController alloc] init];
            tfvc.channel=@"Friend";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tfvc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.topicFirendViewController = nav;
            }
        
            [self configureCenterViewController:self.topicFirendViewController];
        }
        
    }else if(channelSN==4){
        
        if(!self.videoWeekViewController){
        
            TopicDetailViewController *vwvc = [[TopicDetailViewController alloc] init];
            vwvc.channel=@"Week";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vwvc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.videoWeekViewController = nav;
        }
        
        [self configureCenterViewController:self.videoWeekViewController];
        
    }else if(channelSN==5){
        if ([self.manager isLogined]) {
            if(!self.videoFriendViewController){
                TopicDetailViewController *vfvc = [[TopicDetailViewController alloc] init];
                vfvc.channel=@"Friend";
                //vfvc.channel=@"Global";
                //vfvc.month=[NSNumber numberWithInt:11];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vfvc];
                [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            
                self.videoFriendViewController = nav;
            }
            [self configureCenterViewController:self.videoFriendViewController];
        }
        
    }else if(channelSN==6){
        
        if(!self.videoGlobalViewController){
        
            GlobalViewController *gvc = [[GlobalViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gvc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.videoGlobalViewController = nav;
        }
        
        
        [self configureCenterViewController:self.videoGlobalViewController];
        
    }else if(channelSN==7){
        
        if(!self.schoolPartyViewController){
            SchoolPartyViewController *spcv = [[SchoolPartyViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:spcv];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            self.schoolPartyViewController = nav;
        }
        
        
        [self configureCenterViewController:self.schoolPartyViewController];
        
    }else if(channelSN==8){
        
        if (self.activityViewController) {
            self.activityViewController=nil;
        }
        
        if(!self.activityViewController){
        
            ActivityViewController *avc = [[ActivityViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:avc];
            [nav.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            
            self.activityViewController = nav;
        }
        
        
        [self configureCenterViewController:self.activityViewController];
        
    }


}
- (void)configureCell:(MainMenuCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.unitAry.count==indexPath.row) {
        cell.unitHeader.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedStringFromTable(@"版本資訊",@"InfoPlist",nil),self.version];
    }else{
        cell.unitHeader.text=self.unitAry[indexPath.row];
        if ([self.manager isLogined]) {
            [cell.unitHeader setTextColor:[UIColor whiteColor]];
        }else{
            if (indexPath.row==3 || indexPath.row==5) {
                [cell.unitHeader setTextColor:[UIColor grayColor]];
            }else{
                [cell.unitHeader setTextColor:[UIColor whiteColor]];
            }
        
        }

        NSString *imageName=self.unitIcons[indexPath.row];
        [cell.unitIcon setImage:[UIImage imageNamed:imageName]];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view controller related

- (void)configureCenterViewController:(UIViewController *)vc
{
    if(self.revealViewController.frontViewController && self.revealViewController.frontViewController == vc){
        NSLog(@"1");
        [self.revealViewController revealToggleAnimated:YES];
    }else{
        NSLog(@"2");
        [self.revealViewController setFrontViewController:vc animated:YES];
    }
}

@end
