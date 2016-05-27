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
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconPageBackNoheader.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
