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
#import "UIImage+FontAwesome.h"
#import "buttonHelper.h"
#import "ReviewTableViewController.h"

@interface reviewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIView *editBtn;
@property MainVerticalScroller *scrollHelp;
@property (strong, nonatomic) IBOutlet UIImageView *editPen;
@property (strong, nonatomic) IBOutlet UIImageView *penPic;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UIImageView *movieNavIcon;
@property (strong, nonatomic) IBOutlet UIView *movieNavBg;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UITableView *reviewTable;
@property ReviewTableViewController *tableController;
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
    
    self.editBtn.layer.borderWidth=1;
    self.editBtn.layer.cornerRadius =3;
    self.editBtn.layer.borderColor = [UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1].CGColor;
    self.editPen.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1.0] andSize:CGSizeMake(10, 10)];
    self.penPic.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1.0] andSize:CGSizeMake(12, 14)];
    
    self.movieNavIcon.image = [UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(16, 16)];
    self.movieNavBg.layer.cornerRadius =8;
    self.movieNavBg.backgroundColor = [UIColor colorWithRed:(68/255.0f) green:(85/255.0f) blue:(102/255.0f) alpha:1.0];
    [self.content setEditable:NO];
    
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    
    self.tableController = [[ReviewTableViewController alloc] init];
    self.reviewTable.delegate = self.tableController;
    self.reviewTable.dataSource = self.tableController;
    self.tableController.tableView = self.reviewTable;
    self.reviewTable.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)indexClick:(UITapGestureRecognizer *)sender{
    [buttonHelper likeShareClick:sender.view];
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