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
#import "CircleView.h"
#import "buttonHelper.h"
#import "AustinApi.h"

@interface TopicDetailViewController ()
@property MainVerticalScroller *scrollDelegate;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *mainBg;
@property (strong, nonatomic) IBOutlet UIImageView *penIcon;
@property (strong, nonatomic) IBOutlet UITextView *mainTxt;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) IBOutlet UIImageView *pcircleBtn;
@property (strong, nonatomic) IBOutlet UIImageView *eyeBtn;
@property (strong, nonatomic) IBOutlet UILabel *finishLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet CircleView *circleView;
@property (strong, nonatomic) IBOutlet UIImageView *Avatar;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *topicTitle;
@property (strong, nonatomic) IBOutlet UILabel *viewCount;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *Chervon;
@property (strong, nonatomic) IBOutlet UIView *moreBtn;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property BOOL opened;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreHeight;
@property (strong, nonatomic) IBOutlet UILabel *tableLabel;
@property BOOL eyeB;
@property BOOL playB;
@property NSArray *original;

@property MovieTwoTableViewController *movieTableController;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [buttonHelper gradientBg:self.mainBg width:self.view.frame.size.width];
    
    [self addMask];
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.scrollDelegate.nav = self.navigationController;
    [self.scrollDelegate setupBackBtn:self];
    [self.scrollDelegate setupStatusbar:self.view];
    self.mainScroll.delegate = self.scrollDelegate;
    self.penIcon.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1.0] andSize:CGSizeMake(10, 10)];
    self.eyeBtn.image = [UIImage imageWithIcon:@"fa-eye-slash" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(20, 20)];
    self.pcircleBtn.image = [UIImage imageWithIcon:@"fa-play-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(18, 20)];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTableController.tableView = self.tableView;
    self.tableView.delegate =self.movieTableController;
    self.tableHeight.constant = 320;
    
    UIColor *circleColor = [buttonHelper circleColor:.8];
    self.circleView.percentage = self.percent.floatValue;
    
    self.circleView.color = circleColor;
    self.finishLabel.textColor = self.percentLabel.textColor = circleColor;
    self.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.percent.floatValue*100)];
    
    NSLog(@"%@",self.data);
    [self.Avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[[self.data objectForKey:@"Author"] objectForKey:@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.nickName.text = [[self.data objectForKey:@"Author"] objectForKey:@"NickName"];
    self.title = self.topicTitle.text = [self.data objectForKey:@"Title"];
    self.mainTxt.text = [self.data objectForKey:@"Content"];
    self.viewCount.text = [[self.data objectForKey:@"ViewNum"]stringValue];
    self.date.text = [[self.data objectForKey:@"ModifiedOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [self.mainBg sd_setImageWithURL:[NSURL URLWithString:[self.data objectForKey:@"BannerUrl"]]  placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreClick)];
    [self.moreBtn addGestureRecognizer:tap];
    
    [[AustinApi sharedInstance]movieListCustom:@"3" location:nil year:nil month:nil page:nil topicId:[self.data objectForKey:@"Id"] function:^(NSArray *returnData) {
        self.original = self.movieTableController.data = returnData;
        self.tableHeight.constant = 165*[returnData count];
        [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, self.tableHeight.constant+550)];
        self.tableLabel.text = [NSString stringWithFormat:@"專題單片%lu部",(unsigned long)[returnData count]];
        [self.movieTableController.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [self filterAddTap:self.eyeBtn];
    [self filterAddTap:self.pcircleBtn];
}
-(void)filterAddTap:(UIView*)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClick:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}
-(void)filterClick:(UIGestureRecognizer*)gesture{
    if(gesture.view.tag==0){
        if(self.eyeB){
            self.eyeBtn.image = [UIImage imageWithIcon:@"fa-eye-slash" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(20, 20)];
        }else{
            self.eyeBtn.image = [UIImage imageWithIcon:@"fa-eye-slash" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1.0] andSize:CGSizeMake(20, 20)];
        }
        self.eyeB = !self.eyeB;
    }
    if(gesture.view.tag==1){
        if(self.playB){
            self.pcircleBtn.image = [UIImage imageWithIcon:@"fa-play-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(18, 20)];
        }else{
            self.pcircleBtn.image = [UIImage imageWithIcon:@"fa-play-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1.0] andSize:CGSizeMake(18, 20)];
        }
        self.playB = !self.playB;
    }
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (NSDictionary *row in self.original) {
        BOOL add = YES;
        if(self.eyeB){
            if([[row objectForKey:@"IsViewed"]boolValue]==TRUE){
                add= NO;
            }
        }
        if(self.playB){
            if([[row objectForKey:@"IsPlayable"]boolValue]==FALSE){
                add = NO;
            }
        }
        if(add){
            [temp addObject:row];
        }
    }
    self.movieTableController.data = temp;
    self.tableHeight.constant = 165*[temp count];
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, self.tableHeight.constant+550)];
    self.tableLabel.text = [NSString stringWithFormat:@"專題單片%lu部",(unsigned long)[temp count]];
    [self.movieTableController.tableView reloadData];
}
-(void)addMask{
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.0f, @1.0f ];
    maskLayer.frame = self.mainTxt.bounds;
     self.mainTxt.layer.mask = maskLayer;
}
-(void)moreClick{
    if(self.opened){
        self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
        self.moreLabel.text = @"展開全文";
        self.contentHeight.constant = 94;
        self.moreHeight.constant = 90;
        [self addMask];
    }else{
        self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
        self.moreLabel.text = @"顯示部分";
        [self.moreLabel sizeToFit];
        self.mainTxt.layer.mask = nil;
        self.contentHeight.constant = self.mainTxt.frame.size.height;
        self.moreHeight.constant = self.contentHeight.constant-3;
    }
    self.opened = !self.opened;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
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
