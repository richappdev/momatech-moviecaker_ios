//
//  SignUpViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signUpButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end
