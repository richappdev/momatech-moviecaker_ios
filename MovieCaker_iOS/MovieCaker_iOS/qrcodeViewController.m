//
//  qrcodeViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/5/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "qrcodeViewController.h"
#import "MainVerticalScroller.h"

@interface qrcodeViewController ()
@property MainVerticalScroller *helper;
@end

@implementation qrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的QR Code";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
