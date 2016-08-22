//
//  InnerMyPageViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/22/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "InnerMyPageViewController.h"
#import "MainVerticalScroller.h"
#import "UIImage+FontAwesome.h"

@interface InnerMyPageViewController ()
@property MainVerticalScroller *helper;
@end

@implementation InnerMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(182/255.0) blue:(172/255.0) alpha:1];
    self.title = @"我的裝置";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:(128/255.0) green:(203/255.0) blue:(196/255.0) alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]}];

    [self.view addSubview:statusView];

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
