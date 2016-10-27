//
//  myMovieViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 10/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "myMovieViewController.h"
#import "MainVerticalScroller.h"
@interface myMovieViewController ()
@property MainVerticalScroller *helper;
@end

@implementation myMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type==0){
        self.title=@"我看過的電影";
    }
    if(self.type==1){
        self.title=@"我喜歡的電影";
    }
    if(self.type==2){
        self.title=@"我想看的電影";
    }
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
