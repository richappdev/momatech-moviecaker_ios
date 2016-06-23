//
//  reviewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/23/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "reviewController.h"
#import "MainVerticalScroller.h"
#import "buttonHelper.h"

@interface reviewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property MainVerticalScroller *scrollHelp;
@end

@implementation reviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"test";
    
    self.scrollHelp = [[MainVerticalScroller alloc]init];
    self.scrollHelp.nav = self.navigationController;
    [self.scrollHelp setupBackBtn:self];
    [self.scrollHelp setupStatusbar:self.view];
    
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width,2000);
    self.mainScroll.delegate = self.scrollHelp;
    
    [buttonHelper gradientBg:self.bgImage width:self.view.frame.size.width];
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
