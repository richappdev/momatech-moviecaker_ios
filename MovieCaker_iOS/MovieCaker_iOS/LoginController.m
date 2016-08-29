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
    maskLayer.frame = CGRectMake(0,0, self.BannerUrl.frame.size.width+200, self.BannerUrl.frame.size.height);
    self.BannerUrl.layer.mask = maskLayer;
    [self addIndexClick:self.noticeView];
    [self addIndexClick:self.qrcode];
    [self addIndexClick:self.friendList];
    [self addIndexClick:self.inviting];
   
    self.bullhorn.image = [UIImage imageWithIcon:@"fa-bullhorn" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    self.friendListIcon.image =  [UIImage imageWithIcon:@"fa-users" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    self.invitingIcon.image =  [UIImage imageWithIcon:@"fa-bell" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(51/255.0f) green:(68/255.0f) blue:(85/255.0f) alpha:1.0] andSize:CGSizeMake(16, 16)];
    
    AustinApi *temp3 = [AustinApi sharedInstance];
    self.friendLabel.text = [NSString stringWithFormat:@"%lu 個朋友",(unsigned long)[temp3.friendList count]];
}

-(void)addIndexClick:(UIView*)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:tap];
}
-(void)indexClick:(UITapGestureRecognizer*)gesture{
    NSLog(@"%ld",gesture.view.tag);
    if(gesture.view.tag==1){
        [self performSegueWithIdentifier:@"friendsSegue" sender:self];
    }
    if(gesture.view.tag==3){
        [self performSegueWithIdentifier:@"noticeSegue" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"friendsSegue"]){
        friendsViewController *dest = segue.destinationViewController;
        dest.nickName = self.nickname.text;
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
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]];
    NSLog(@"%@",returnData);
    if(returnData!=nil){
        [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
        [self.myView setHidden:NO];
        [self populate:[returnData objectForKey:@"Data"]];
    }else{
        [self startTimer];}
    [self.navigationController setNavigationBarHidden:YES];
    
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
}
-(void)wLogin:(UIGestureRecognizer*)gesture{
    [self Login:gesture.view];
}
- (IBAction)Login:(id)sender {
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    movie.refresh = YES;
    UIButton *btn = (UIButton*)sender;
    if([[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]!=nil){
        [self logout];
    }
    else if(btn.tag==1){
        [[AustinApi sharedInstance]loginWithAccount:self.username.text withPassword:self.password.text withRemember:YES function:^(NSDictionary *returnData) {
            if([[returnData objectForKey:@"success"]boolValue]==TRUE){
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
            [self populate:[returnData objectForKey:@"Data"]];
        } error:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:@"取消" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
            [alert show];
        }
    } viewController:self];}
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请使用微信登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
        NSLog(@"Wechat not installed");
    }
}
}
-(void)populate:(NSDictionary*)dict{
    [self.BannerUrl sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"BannerUrl"]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[[AustinApi sharedInstance] getBaseUrl],[dict objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.nickname.text = [dict objectForKey:@"NickName"];
    self.location.text = [dict objectForKey:@"LocationName"];
    if([[dict objectForKey:@"Gender"] integerValue]==1){
        self.gender.image =[UIImage imageWithIcon:@"fa-male" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(119/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }else{
        self.gender.image =[UIImage imageWithIcon:@"fa-female" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(255/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }
   self.chevron2.image = self.chevron3.image = self.chevron4.image = self.chevron5.image = self.chevron.image = [UIImage imageWithIcon:@"fa-chevron-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(10, 14)];
}
@end
