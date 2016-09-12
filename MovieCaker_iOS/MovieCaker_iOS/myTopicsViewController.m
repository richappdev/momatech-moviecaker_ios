//
//  myTopicsViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/12/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "myTopicsViewController.h"
#import "MainVerticalScroller.h"

@interface myTopicsViewController ()
@property MainVerticalScroller *helper;
@end

@implementation myTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ 的電影", self.nickName];
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
