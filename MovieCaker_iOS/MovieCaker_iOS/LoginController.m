//
//  LoginController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/17/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "LoginController.h"

#import "WXApi.h"
#import "AFNetworking.h"
#import "WechatAccess.h"
#import "AustinApi.h"
#import "MovieController.h"
#import "movieModel.h"
#import "buttonHelper.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FontAwesome.h"
#import "friendsViewController.h"
#import "myTopicsViewController.h"
#import "MovieViewController.h"
#import "myMovieViewController.h"

#define USERKEY @"userkey"
@interface LoginController ()
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *Button2;
@property (strong, nonatomic) IBOutlet UIImageView *wechatBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bgOne;
@property (strong, nonatomic) IBOutlet UIImageView *bgTwo;
@property int count;
@property NSTimer *timer;
@property UIImageView *current;
@property UIImageView *next;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIImageView *BannerUrl;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UIImageView *gender;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIImageView *chevron;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIImageView *chevron2;
@property (strong, nonatomic) IBOutlet UIImageView *chevron3;
@property (strong, nonatomic) IBOutlet UIImageView *chevron4;
@property (strong, nonatomic) IBOutlet UIImageView *chevron5;
@property (strong, nonatomic) IBOutlet UIView *noticeView;
@property (strong, nonatomic) IBOutlet UIImageView *bullhorn;
@property (strong, nonatomic) IBOutlet UIView *inviting;
@property (strong, nonatomic) IBOutlet UIView *friendList;
@property (strong, nonatomic) IBOutlet UIView *qrcode;
@property (strong, nonatomic) IBOutlet UIImageView *invitingIcon;
@property (strong, nonatomic) IBOutlet UIImageView *friendListIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendLabel;
@property (strong, nonatomic) IBOutlet UIImageView *qrcodeIcon;
@property BOOL jump;
@property BOOL jump2;
@property (strong, nonatomic) IBOutlet UILabel *btnLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconFilm;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *archive;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) IBOutlet UIView *myTopic;
@property (strong, nonatomic) IBOutlet UIView *likedTopic;
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wantLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicSLabel;
@property (strong, nonatomic) IBOutlet UIView *wechatLine;
@property (strong, nonatomic) IBOutlet UILabel *wechatOr;
@property (strong, nonatomic) IBOutlet UILabel *noticeDot;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginConstraint;
@property NSTimer *dotTimer;
@property NSTimer *inviteDotTimer;
@property (strong, nonatomic) IBOutlet UIView *watchedIcon;
@property (strong, nonatomic) IBOutlet UIView *likedIcon;
@property (strong, nonatomic) IBOutlet UIView *wannaWatchIcon;
@property (strong, nonatomic) IBOutlet UILabel *invitingDot;
@property (strong, nonatomic) IBOutlet UIView *reviewIcon;
@property int movieTemp;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retract)];
    [self.view addGestureRecognizer:tap];
    self.username.delegate = self;
    self.password.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.username.frame.size.height - 1, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1].CGColor;
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.username.frame.size.height - 1, self.view.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1].CGColor;
    [self.username.layer addSublayer:bottomBorder];
    [self.password.layer addSublayer:bottomBorder2];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wLogin:)];
    [self.wechatBtn setUserInteractionEnabled:YES];
    [self.wechatBtn addGestureRecognizer:tap2];
   
    self.count =0;
    movieModel *temp = [self.images objectAtIndex:0];
    self.bgOne.image = [buttonHelper blurImage:temp.movieImageView.image withBottomInset:0 blurRadius:4];
    movieModel *temp2 = [self.images objectAtIndex:1];
    self.bgTwo.image = [buttonHelper blurImage:temp2.movieImageView.image withBottomInset:0 blurRadius:4];
    self.current =self.bgOne;
    self.next =self.bgTwo;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail)];
    [self.detailView addGestureRecognizer:tap3];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.8f, @1.0f ];
    maskLayer.frame = CGRectMake(0,0, self.view.frame.size.width, self.BannerUrl.frame.size.height);
    self.BannerUrl.layer.mask = maskLayer;
    [self addIndexClick:self.noticeView];
    [self addIndexClick:self.qrcode];
    [self addIndexClick:self.friendList];
    [self addIndexClick:self.inviting];
    [self addIndexClick:self.myTopic];
    [self addIndexClick:self.likedTopic];
    [self addMovieClick:self.watchedIcon];
    [self addMovieClick:self.wannaWatchIcon];
    [self addMovieClick:self.likedIcon];
    [self addMovieClick:self.reviewIcon];
   
    self.bullhorn.image = [UIImage imageWithIcon:@"fa-bullhorn" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    self.friendListIcon.image =  [UIImage imageWithIcon:@"fa-users" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    self.invitingIcon.image =  [UIImage imageWithIcon:@"fa-bell" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    
    self.qrcodeIcon.image =  [UIImage imageWithIcon:@"fa-qrcode" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    
    AustinApi *temp3 = [AustinApi sharedInstance];
    self.friendLabel.text = [NSString stringWithFormat:@"%lu 個朋友",(unsigned long)[temp3.friendList count]];

    self.iconFilm.image = [UIImage imageWithIcon:@"fa-film" backgroundColor:[UIColor whiteColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1] andSize:CGSizeMake(18, 16)];
    
    self.archive.image = [UIImage imageWithIcon:@"fa-archive" backgroundColor:[UIColor whiteColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1] andSize:CGSizeMake(16, 16)];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

}
-(void)sendNotification{
    UILocalNotification *local = [[UILocalNotification alloc]init];
    local.alertAction = @"回去";
    local.alertBody = @"你有新通知";
    local.fireDate = [[NSDate alloc]initWithTimeIntervalSinceNow:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
}
-(void)viewDidLayoutSubviews{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
}
-(void)addIndexClick:(UIView*)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:tap];
}
-(void)addMovieClick:(UIView*)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieClick:)];
    [view addGestureRecognizer:tap];
}
-(void)indexClick:(UITapGestureRecognizer*)gesture{
    NSLog(@"%ld",gesture.view.tag);
    if(gesture.view.tag==0){
        [self performSegueWithIdentifier:@"qrcodeSegue" sender:self];
    }
    if(gesture.view.tag==1||gesture.view.tag==2){
        if(gesture.view.tag==2){
            self.invitingDot.hidden = YES;
            self.jump = YES;
        }
        [self performSegueWithIdentifier:@"friendsSegue" sender:self];
    }
    if(gesture.view.tag==3){
        [self performSegueWithIdentifier:@"noticeSegue" sender:self];
    }
    if(gesture.view.tag==4||gesture.view.tag==5){
        if(gesture.view.tag==5){
            self.jump2 = YES;
        }
        [self performSegueWithIdentifier:@"topicSegue" sender:self];
    }
}

-(void)movieClick:(UITapGestureRecognizer*)gesture{
    self.movieTemp =(int)gesture.view.tag;
    [self performSegueWithIdentifier:@"myMovieSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"friendsSegue"]){
        friendsViewController *dest = segue.destinationViewController;
        dest.nickName = self.nickname.text;
        if(self.jump){
            dest.jump = YES;
            self.jump = NO;
        }
    }
    if([[segue identifier]isEqualToString:@"topicSegue"]){
        myTopicsViewController *dest = segue.destinationViewController;
        dest.nickName = self.nickname.text;
        if(self.jump2){
            dest.jump = YES;
            self.jump2 = NO;
        }
    }
    
    if([[segue identifier]isEqualToString:@"noticeSegue"]){
        self.noticeDot.hidden = YES;
    }
    
    if([[segue identifier]isEqualToString:@"myMovieSegue"]){
        myMovieViewController *temp = segue.destinationViewController;
        temp.type =self.movieTemp;
    }

}
-(void)detail{
    [self performSegueWithIdentifier:@"mypageSegue" sender:self];
}
-(void)timerTicked:(id)sender{
    if(self.count<[self.images count]-1){
        self.count++;
    }else{
        self.count=0;
    }
    [self changePic:self.count];
}

-(void)changePic:(int)row{
    NSLog(@"work");
    [UIView animateWithDuration:1.0f animations:^{
        self.current.alpha =0;
        self.next.alpha=1;
    } completion:^(BOOL finished){
        UIImageView *temp = self.current;
        self.current =self.next;
        self.next = temp;
        movieModel *temp2 = [self.images objectAtIndex:row];
        temp.image =[buttonHelper blurImage:temp2
                     .movieImageView.image withBottomInset:0 blurRadius:4];
    }];
}
-(void)retract{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self stopDotTimers];
}
-(void)stopDotTimers{
    [self.dotTimer invalidate];
    self.dotTimer = nil;
    [self.inviteDotTimer invalidate];
    self.inviteDotTimer = nil;
}
-(void)startDotTimer:(NSDictionary*)data{
    if(self.noticeDot.hidden == YES){
        self.dotTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(testDot) userInfo:nil repeats:YES];
        [self testDot];
    }
    if(self.invitingDot.hidden == YES){
        self.inviteDotTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(preRefresh:) userInfo:data repeats:YES];
        [self refreshFriend:data];
    }
}
-(void)preRefresh:(NSTimer*)timer{
    NSDictionary *temp = timer.userInfo;
    [self refreshFriend:temp];
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]];
    NSLog(@"%@",returnData);
    if(returnData!=nil){
        [self startDotTimer:[returnData objectForKey:@"Data"]];
        [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
        [self.myView setHidden:NO];
        [self populate:[returnData objectForKey:@"Data"]];
        [self refreshFriend:[returnData objectForKey:@"Data"]];
    }else{
        [self startTimer];}
    [self.navigationController setNavigationBarHidden:YES];
    
    if([[WechatAccess sharedInstance]isWechatAppInstalled]==YES){
        // remove WeCaht login method temporary for Moma internal user testing
        self.wechatOr.hidden = YES;
        self.wechatBtn.hidden = YES;
        self.wechatLine.hidden = YES;
    }else{
        self.wechatOr.hidden = YES;
        self.wechatBtn.hidden = YES;
        self.wechatLine.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)testDot{
    NSLog(@"test");
    
   NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"noticeCount"];
    
    [[AustinApi sharedInstance] getNotice:^(NSArray *returnData) {
        if([returnData count]>[num integerValue]){
            [self.dotTimer invalidate];
            self.noticeDot.hidden = NO;
            [self sendNotification];
        }
    } error:^(NSError *error) {
        
    }];
    
}
-(void)keyboardWillShow{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.loginConstraint.constant = -100;
    [UIView commitAnimations];
    
}
-(void)keyboardWillHide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.loginConstraint.constant = 0;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self retract];
    return YES;
}
-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}
-(void)stopTimer{
    [self.timer invalidate];
    self.timer=nil;
}
-(void)logout{
    [self refresh];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERKEY];
    [self.Button2 setTitle:@"Login" forState:UIControlStateNormal];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        // Here I see the correct rails session cookie
        NSLog(@"%@",cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [self.myView setHidden:YES];
    if(self.timer!=nil){
        [self startTimer];}
    [self stopDotTimers];
}
-(void)wLogin:(UIGestureRecognizer*)gesture{
    [self Login:gesture.view];
}
-(void)refreshFriend:(NSDictionary*)returnData{
    [[AustinApi sharedInstance]getFriends:[[returnData objectForKey:@"UserId"]stringValue] page:1 function:^(NSString *returnData) {
            AustinApi *temp3 = [AustinApi sharedInstance];
            self.friendLabel.text = [NSString stringWithFormat:@"%lu 個朋友",(unsigned long)[temp3.friendList count]];
        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"inviteCount"];
        
        NSMutableArray *one= [[NSMutableArray alloc]init];
        for (NSDictionary *row in temp3.friendWaitList) {
            if([[row objectForKey:@"IsInviting"]integerValue]==1){
                [one addObject:row];
            }
        }
        if([one count]>[num integerValue]){
            [self.inviteDotTimer invalidate];
            self.inviteDotTimer =nil;
            self.invitingDot.hidden =NO;
        }
        } refresh:YES];
}
-(void)refresh{
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    movie.refresh = YES;
    nav =  [self.tabBarController.viewControllers objectAtIndex:1];
    MovieViewController *tab=[[nav viewControllers]objectAtIndex:0];
    [tab refresh];
}
- (IBAction)Login:(id)sender {
    [self refresh];
    [self retract];
    UIButton *btn = (UIButton*)sender;
    if([[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]!=nil){
        [self logout];
    }
    else if(btn.tag==1){
        [[AustinApi sharedInstance]loginWithAccount:self.username.text withPassword:self.password.text withRemember:YES function:^(NSDictionary *returnData) {
            if([[returnData objectForKey:@"success"]boolValue]==TRUE){
                [self startDotTimer:[returnData objectForKey:@"data"]];
                [self refreshFriend:[returnData objectForKey:@"data"]];
            NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[returnData objectForKey:@"data"],@"Data", nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:temp] forKey:USERKEY];
                [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[temp objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
                [self.myView setHidden:NO];
                [self stopTimer];
                [self populate:[returnData objectForKey:@"data"]];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"用户名或密码不正确" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
                [alert show];
            }
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }else{
    
    
    if([[WechatAccess sharedInstance]isWechatAppInstalled]==YES){
    
        [[[WechatAccess sharedInstance] defaultAccess]login:^(BOOL succeeded, id object) {NSLog(@"wro");
        if(succeeded){
        //do Login Proccess
        [[AustinApi sharedInstance] apiRegisterPost:[object objectForKey:@"unionid"] completion:^(NSMutableDictionary *returnData) {
            NSLog(@"here%@",returnData);
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returnData] forKey:USERKEY];

            [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
            [self.myView setHidden:NO];
            [self stopTimer];
            [self startDotTimer:[returnData objectForKey:@"Data"]];
            NSDictionary *test = [returnData objectForKey:@"Data"];
            if([[test allKeys]count]<2){
                test = returnData;
            }
            [self populate:test];
            [self refreshFriend:test];
            
        } error:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:@"取消" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
            [alert show];
        }
    } viewController:self];}
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请安裝微信" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
        NSLog(@"Wechat not installed");
    }
}
}
-(void)populate:(NSDictionary*)dict{
    [self.BannerUrl sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"BannerUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder-banner.jpg"]];
    self.BannerUrl.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"placeholder-poster.jpg"]];
    self.nickname.text = [dict objectForKey:@"NickName"];
    self.location.text = [dict objectForKey:@"LocationName"];
    if(![[dict objectForKey:@"Gender"] isKindOfClass:[NSNull class]]&&[[dict objectForKey:@"Gender"] integerValue]==1
       ){
        self.gender.image =[UIImage imageWithIcon:@"fa-male" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(119/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }else{
        self.gender.image =[UIImage imageWithIcon:@"fa-female" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(255/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }
   self.chevron2.image = self.chevron3.image = self.chevron4.image = self.chevron5.image = self.chevron.image = [UIImage imageWithIcon:@"fa-chevron-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(10, 14)];
    
    self.btnLabel.text = [NSString stringWithFormat:@"%@的電影",[dict objectForKey:@"NickName"]];
    self.topicLabel.text = [NSString stringWithFormat:@"%@的專題",[dict objectForKey:@"NickName"]];
    [[AustinApi sharedInstance] getStatistics:[dict objectForKey:@"UserId"] function:^(NSDictionary *returnData) {
        self.viewLabel.text = [[returnData objectForKey:@"ViewCount"]stringValue];
        self.likeLabel.text = [[returnData objectForKey:@"LikeCount"] stringValue];
        self.wantLabel.text = [[returnData objectForKey:@"WantViewCount"] stringValue];
        self.topicSLabel.text = [[returnData objectForKey:@"TopicCount"] stringValue];
        
        NSLog(@"%@",returnData);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
