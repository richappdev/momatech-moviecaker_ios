//
//  MovieDetailControllerViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/14/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieDetailController.h"

@interface MovieDetailController ()

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
