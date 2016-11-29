//
//  FriendProfileViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 11/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "MainVerticalScroller.h"

@interface FriendProfileViewController ()
@property MainVerticalScroller *helper;
@end

@implementation FriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    self.title = [self.data objectForKey:@"NickName"];
    NSLog(@"%@",self.data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
