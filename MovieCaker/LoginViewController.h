//
//  LoginViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UITextField *pwd;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;
- (IBAction)facebookLoginButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *notLoginButton;
- (IBAction)notLoginButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scollView;
- (IBAction)touchScreen:(id)sender;

@end
