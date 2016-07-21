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
#import "UIImageView+WebCache.h"
#import "UIImage+FontAwesome.h"
#import "MovieTwoTableViewController.h"

@interface TopicDetailViewController ()
@property MainVerticalScroller *scrollDelegate;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *mainBg;
@property (strong, nonatomic) IBOutlet UIImageView *penIcon;
@property (strong, nonatomic) IBOutlet UITextView *mainTxt;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property MovieTwoTableViewController *movieTableController;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [buttonHelper gradientBg:self.mainBg width:self.view.frame.size.width];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.0f, @1.0f ];
    maskLayer.frame = self.mainTxt.bounds;
    self.mainTxt.layer.mask = maskLayer;
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.scrollDelegate.nav = self.navigationController;
    [self.scrollDelegate setupBackBtn:self];
    [self.scrollDelegate setupStatusbar:self.view];
    self.mainScroll.delegate = self.scrollDelegate;
    self.penIcon.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1.0] andSize:CGSizeMake(10, 10)];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTableController.tableView = self.tableView;
    self.tableView.delegate =self.movieTableController;
    self.movieTableController.data = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] init],[[NSDictionary alloc]init], nil];
    self.tableHeight.constant = 320;
   // [self.movieTableController ParentController:self];
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
