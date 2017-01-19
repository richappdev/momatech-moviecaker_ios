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
#import "MovieDetailController.h"
#import "WXApi.h"
#import "WechatAccess.h"
#import "reviewController.h"
#import "MBProgressHUD.h"

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
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIView *friendStatus;
@property (strong, nonatomic) IBOutlet UIImageView *friendAdd;
@property NSArray *original;

@property MovieTwoTableViewController *movieTableController;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [buttonHelper gradientBg:self.mainBg width:self.view.frame.size.width+5];
    
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
    [self.movieTableController ParentController:self];
    self.movieTableController.page = 999;
    
    if([self.percent floatValue]>=0){
    UIColor *circleColor = [buttonHelper circleColor:self.percent.floatValue];
    self.circleView.percentage = self.percent.floatValue;
    
    self.circleView.color = circleColor;
    self.finishLabel.textColor = self.percentLabel.textColor = circleColor;
    self.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.percent.floatValue*100)];
    }else{
        self.circleView.hidden = YES;
    }
    NSLog(@"%@",self.data);
    [self.Avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[[self.data objectForKey:@"Author"] objectForKey:@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"nobody-big.jpg"]];
    self.nickName.text = [[self.data objectForKey:@"Author"] objectForKey:@"NickName"];
    self.title = self.topicTitle.text = [self.data objectForKey:@"Title"];
    self.mainTxt.text = [self.data objectForKey:@"Content"];
    self.viewCount.text = [[self.data objectForKey:@"ViewNum"]stringValue];
    self.date.text = [[self.data objectForKey:@"ModifiedOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.mainBg.contentMode = UIViewContentModeScaleAspectFill;
    [self.mainBg sd_setImageWithURL:[NSURL URLWithString:[self.data objectForKey:@"BannerUrl"]]  placeholderImage:[UIImage imageNamed:@"placeholder-banner.jpg"]];
    
    self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreClick)];
    [self.moreBtn addGestureRecognizer:tap];
    
    self.likeLabel.text = [[self.data objectForKey:@"LikeNum"] stringValue];
    self.shareLabel.text = [[self.data objectForKey:@"ShareNum"] stringValue];
    self.commentLabel.text = [[self.data objectForKey:@"CommentNum"] stringValue];
    
    [buttonHelper v2AdjustLike:self.likeBtn state:[[self.data objectForKey:@"IsLiked"] boolValue]];
    [buttonHelper v2AdjustShare:self.shareBtn state:[[self.data objectForKey:@"IsShared"] boolValue]];
    
    [[AustinApi sharedInstance]movieListCustom:@"3" myType:nil location:nil year:nil month:nil page:nil topicId:[self.data objectForKey:@"Id"] uid:nil function:^(NSArray *returnData) {
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [newArray addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        self.original = self.movieTableController.data = newArray;
        self.tableHeight.constant = 165*[returnData count];
        [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, self.tableHeight.constant+550)];
        self.tableLabel.text = [NSString stringWithFormat:@"專題單片%lu部",(unsigned long)[returnData count]];
        [self.movieTableController.tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [self filterAddTap:self.eyeBtn];
    [self filterAddTap:self.pcircleBtn];
    
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    [self.friendAdd setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFriend)];
    [self.friendAdd addGestureRecognizer:tap2];
}
-(void)addFriend{
    self.friendAdd.hidden = YES;
    [buttonHelper adjustFriendStatus:self.friendStatus state:1];
    [[AustinApi sharedInstance] addFriend:[[self.data objectForKey:@"Author"] objectForKey:@"Id"]];
}
-(void)testFriend{
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];
    
    if(returnData==nil||[[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue] isEqualToString:[[[self.data objectForKey:@"Author"] objectForKey:@"Id"]stringValue]]){
        self.friendAdd.hidden = YES;
        self.friendStatus.hidden = YES;
    }else{
        [[AustinApi sharedInstance]getFriends:[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue] page:1 function:nil refresh:NO];
    int test = [[AustinApi sharedInstance]testFriend:[[[self.data objectForKey:@"Author"] objectForKey:@"Id"]stringValue]];
    if(test==2||test==1){
        self.friendAdd.hidden = YES;
    }else{
        self.friendAdd.hidden = NO;
    }
    [buttonHelper adjustFriendStatus:self.friendStatus state:test];
    }
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
-(void)addMask{/*
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.0f, @1.0f ];
    maskLayer.frame = CGRectMake(0,0, self.view.frame.size.width, self.moreHeight.constant);
     self.mainTxt.layer.mask = maskLayer;*/
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
        [self.mainTxt sizeToFit];
        self.mainTxt.layer.mask = nil;
        self.contentHeight.constant = self.mainTxt.frame.size.height+10;
        self.moreHeight.constant = self.contentHeight.constant-3+10;
    }
    self.opened = !self.opened;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    [[self navigationController] setNavigationBarHidden:NO];
    [self testFriend];
    self.mainScroll.delegate = self.scrollDelegate;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [[self navigationController] setNavigationBarHidden:YES];
    self.mainScroll.delegate = nil;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"movieDetail"]){
        MovieDetailController *vc = segue.destinationViewController;
        vc.movieDetailInfo = [self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex];
    }
    if([[segue identifier] isEqualToString:@"reviewSegue"]){
        reviewController *vc = segue.destinationViewController;
        self.newReview=NO;
        vc.newReview = YES;
        NSDictionary *vData = [self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex];
        NSDictionary *User = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]]objectForKey:@"Data"];
        vc.data = [buttonHelper reviewNewData:vData User:User];
    
    }
}
-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}
-(void)indexClick:(UIGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
        MovieController *movie = [[nav viewControllers]objectAtIndex:0];
        movie.refresh = YES;
      if(view.tag==3){
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = [self.data objectForKey:@"Title"];
            
            NSString *str;
            if ([[self.data objectForKey:@"Content"] length]>140) {
                str=[[self.data objectForKey:@"Content"] substringToIndex:140];
            }else{
                str=[self.data objectForKey:@"Content"];
            }
            
            message.description=str;
            
            [message setThumbImage:self.Avatar.image];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl =  [NSString stringWithFormat:@"%@/topic/topicpage/%@",[[AustinApi sharedInstance] getBaseUrl],[self.data objectForKey:@"Id"]];
            NSLog(@"%@",ext.webpageUrl);
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            [WXApi sendReq:req];
            
        }
        
        UILabel *label = [view viewWithTag:6];
        NSNumber *boolValue;
        int count = 0;
        if(view.tag==1){
            count = [[self.data objectForKey:@"LikeNum"] integerValue];
            boolValue = [self.data objectForKey:@"IsLiked"];
        }else if (view.tag==3){
            count = [[self.data objectForKey:@"ShareNum"] integerValue];
            boolValue = [self.data objectForKey:@"IsShared"];
        }
        
        if([boolValue boolValue]){
            count--;
        }else{
            count++;
        }
        
        if(view.tag==1){
            [buttonHelper v2AdjustLike:self.likeBtn state:![boolValue boolValue]];
            [self.data setObject:[[NSNumber alloc] initWithBool:![boolValue boolValue]] forKey:@"IsLiked"];
            [self.data setObject:[NSNumber numberWithInt:count] forKey:@"LikeNum"];
        }else if (view.tag==3){
            [buttonHelper v2AdjustShare:self.shareBtn state:TRUE];
            count = [[self.data objectForKey:@"ShareNum"]integerValue];
            if(![[self.data objectForKey:@"IsShared"]boolValue]){
                count++;
            }
        }
        label.text = [NSString stringWithFormat:@"%d",count];
    
        [[AustinApi sharedInstance]socialAction:[self.data objectForKey:@"Id"] act:[NSString stringWithFormat:@"%ld",(long)view.tag] obj:@"3" function:^(NSString *returnData) {
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    }

@end
