//
//  scanViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/7/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "scanViewController.h"
#import "MainVerticalScroller.h"

@interface scanViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UIView *bg;
@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"掃瞄";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    self.bg.layer.borderColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1].CGColor;
    self.bg.layer.borderWidth = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
