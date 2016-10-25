//
//  tabBarViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 10/21/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "tabBarViewController.h"
#import "LoginController.h"

@interface tabBarViewController ()

@end

@implementation tabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = viewController;
    NSArray *viewControllers = nav.viewControllers;
    if([[viewControllers objectAtIndex:0]isKindOfClass:[LoginController class]]){
        [nav popViewControllerAnimated:YES];
    };
}

@end
