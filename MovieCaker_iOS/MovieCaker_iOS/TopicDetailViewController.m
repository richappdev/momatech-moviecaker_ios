//
//  TopicDetailViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 7/21/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "MainVerticalScroller.h"
#import "buttonHelper.h"

@interface TopicDetailViewController ()
@property MainVerticalScroller *scrollDelegate;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *mainBg;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [buttonHelper gradientBg:self.mainBg width:self.view.frame.size.width];
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.scrollDelegate.nav = self.navigationController;
    [self.scrollDelegate setupBackBtn:self];
    [self.scrollDelegate setupStatusbar:self.view];
    self.mainScroll.delegate = self.scrollDelegate;
}

-(void)viewWillLayoutSubviews{
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, 2000)];

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
