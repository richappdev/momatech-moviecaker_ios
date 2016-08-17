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
#define USERKEY @"userkey"
@interface LoginController ()
@property (strong, nonatomic) IBOutlet UIButton *Button;
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *Button2;
@property (strong, nonatomic) IBOutlet UIImageView *wechatBtn;

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
}
-(void)retract{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]];
    NSLog(@"%@",returnData);
    if(returnData!=nil){
        [self.Button setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
        [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)wLogin:(UIGestureRecognizer*)gesture{
    [self Login:gesture.view];
}
- (IBAction)Login:(id)sender {
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    movie.refresh = YES;
    UIButton *btn = (UIButton*)sender;
    if([[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]!=nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERKEY];
        [self.Button setTitle:@"Wechat Login" forState:UIControlStateNormal];
        [self.Button2 setTitle:@"Login" forState:UIControlStateNormal];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            // Here I see the correct rails session cookie
            NSLog(@"%@",cookie);
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    else if(btn.tag==1){
        [[AustinApi sharedInstance]loginWithAccount:self.username.text withPassword:self.password.text withRemember:YES function:^(NSDictionary *returnData) {
            if([[returnData objectForKey:@"success"]boolValue]==TRUE){
            NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[returnData objectForKey:@"data"],@"Data", nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:temp] forKey:USERKEY];
                [self.Button setTitle:[NSString stringWithFormat:@"%@:log out",[[temp objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
                [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[temp objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
                
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

            [self.Button setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
            [self.Button2 setTitle:[NSString stringWithFormat:@"%@:log out",[[returnData objectForKey:@"Data"] objectForKey:@"NickName"]] forState:UIControlStateNormal];
            
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
@end
