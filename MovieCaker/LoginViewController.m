//
//  LoginViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.title=@"Movie Caker";
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    
    self.accountField.placeholder=NSLocalizedStringFromTable(@"帳號",@"InfoPlist",nil);
    self.pwd.placeholder=NSLocalizedStringFromTable(@"密碼",@"InfoPlist",nil);
    
    
    if(IS_DEBUG_MODE == YES){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *account=[defaults stringForKey:@"account"];
        if (account) {
            self.accountField.text=account;
            self.pwd.text=[defaults stringForKey:@"password"];;
        }else{
            self.accountField.text=@"";
            self.pwd.text=@"";
        }
        
        
    }
    
    if (!self.appDelegate.session.isOpen)
    {
        // create a fresh session object
        self.appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"photo_upload", @"publish_stream"]];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (self.appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [self.appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                                  FBSessionState status,
                                                                  NSError *error) {
                [self updateView];
            }];
        }
    }
    
    [self registerForKeyboardNotifications];
    [self.notLoginButton setTitle:NSLocalizedStringFromTable(@"暫時不想登入",@"InfoPlist",nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    if (![self isRetina4inch]) {
        [self.scollView setContentOffset:CGPointMake(0.0,70) animated:YES];
    }

    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (![self isRetina4inch]) {
        [self.scollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
    }
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    [SVProgressHUD show];
    
    
    NSString *account=self.accountField.text;
    NSString *password=self.pwd.text;

    [self.manager getLoginWithAccount:account withPassword:password withRemember:YES callback:^(NSDictionary *loginInfo, NSString *errorMsg, NSError *error) {
        
        NSLog(@"loginInfo:%@",loginInfo);
        
        BOOL success=[[loginInfo valueForKey:@"success"] boolValue];
        
        if (success) {
            
            NSDictionary *dic=[self checkLoginInfo:loginInfo];
            [self.manager saveLoginInfo:dic];
            [self.manager saveLoginAccount:account withPwd:password];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
             message:NSLocalizedStringFromTable(@"登入錯誤",@"InfoPlist",nil)
             delegate:nil
             cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
             otherButtonTitles:nil];
             [alert show];
            
        }

        [SVProgressHUD dismiss];
    }];
}
- (IBAction)facebookLoginButtonPressed:(id)sender {
    
    if (self.appDelegate.session.isOpen == NO)
    {
        if (self.appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            self.appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"photo_upload", @"publish_stream"]];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error) {
            // and here we make sure to update our UX according to the new session state
            NSLog(@"error: %@", error.description);
            [self updateView];
        }];
        
        
    }
}

#pragma mark - misc

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView
{
    if (self.appDelegate.session.isOpen)
    {
        /*
         NSString *token = self.appDelegate.session.accessTokenData.accessToken;
         NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
         NSString *msg = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", token];
         
         UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"已登入"
         message:msg
         delegate:nil
         cancelButtonTitle:@"確定"
         otherButtonTitles:nil] autorelease];
         
         [alert show];
         */
        
        [self backendLogin];
    }
    else
    {
        /*
         NSString *msg = nil;
         
         
         UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"未登入"
         message:msg
         delegate:nil
         cancelButtonTitle:@"確定"
         otherButtonTitles:nil] autorelease];
         
         [alert show];
         */
    }
}

- (void)backendLogin
{
    if(self.appDelegate.session.isOpen)
    {
        [FBSession setActiveSession:self.appDelegate.session];
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            
            /*
            NSString *uid = user.id;
            NSString *name = user.name;
            NSString *pic = uid;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:uid forKey:@"uid"];
            [defaults setObject:name forKey:@"name"];
            [defaults setObject:pic forKey:@"pic_square"];
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"logined"];
            [defaults synchronize];
             */
            
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"尚未登入"
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                               otherButtonTitles:nil];
        
        [alert show];
    }
}

- (IBAction)notLoginButtonPressed:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchScreen:(id)sender {
    
    [self.accountField resignFirstResponder];
    [self.pwd resignFirstResponder];
}
@end
