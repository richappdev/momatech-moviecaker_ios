//
//  MovieController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//
//  [Note]
//  This view is the main view while entering App

#import "MovieController.h"
#import "MovieDetailController.h"
#import "scrollBoxView.h"
#import "movieModel.h"
#import "UIImage+FontAwesome.h"
#import "MainVerticalScroller.h"
#import "MovieTableViewController.h"
#import "AustinApi.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MovieViewController.h"
#import "reviewController.h"
#import "TopicDetailViewController.h"
#import "LoginController.h"
#import "buttonHelper.h"
#import <Crashlytics/Crashlytics.h>

@interface MovieController ()
@property (strong, nonatomic) IBOutlet scrollBoxView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UILabel *uititle;
@property (strong, nonatomic) IBOutlet UIImageView *blurredBg;
@property (strong, nonatomic) IBOutlet UIView *iconEyeBtn;
@property (strong, nonatomic) IBOutlet UIView *iconLikeBtn;
@property (strong, nonatomic) IBOutlet UIView *iconPocketBtn;
@property (strong, nonatomic) IBOutlet UIView *iconPenBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *MainScroll;
@property (strong, nonatomic) IBOutlet UIView *iconMovieNew;
@property (strong, nonatomic) IBOutlet UIView *iconMovieHot;
@property (strong, nonatomic) IBOutlet UIView *iconTopicIndex;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *movieTableHeight;
@property (strong, nonatomic) IBOutlet UIImageView *FirstChevron;
@property (strong, nonatomic) IBOutlet UIView *moreBtn;
@property (strong, nonatomic) IBOutlet UIImageView *SecondChevron;
@property (strong, nonatomic) IBOutlet UIView *moreBtn2;
@property MovieTableViewController *movieTableController;
@property MovieTableViewController *movieTable2Controller;
@property NSMutableArray *movieArray;
@property MainVerticalScroller *scrollDelegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *movieTable2Height;
@property int lastIndex;
@property BOOL notSelected;
@property NSMutableArray *returnData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *movieTableTopspace;
@property (strong, nonatomic) IBOutlet UIImageView *iconEyeIndex;
@property (strong, nonatomic) IBOutlet UIImageView *iconLikeIndex;
@property (strong, nonatomic) IBOutlet UIImageView *iconPoketIndex;
@property BOOL sync;
@end

@implementation MovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get system language
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"%@",language);
    if([language containsString:@"zh-Hans"]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"simplified"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"simplified"];
    }
    
    // Parameter initialized
    self.refresh = NO;
    self.notSelected = YES;
    self.lastIndex = 0;
    
    // Image Scroll
    self.scrollView.scrollView = self.imageScroll;
    self.imageScroll.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieDetail:)];
    [self.imageScroll addGestureRecognizer:singleTap];
    self.imageScroll.pagingEnabled = YES;
    self.imageScroll.clipsToBounds = NO;
    
    // Index Gesture
    [self addIndexGesture:self.iconEyeBtn];
    [self addIndexGesture:self.iconPenBtn];
    [self addIndexGesture:self.iconPocketBtn];
    [self addIndexGesture:self.iconLikeBtn];
    [self addIndexGesture:self.iconMovieNew];
    [self addIndexGesture:self.iconMovieHot];
    [self addIndexGesture:self.iconTopicIndex];
    [self addIndexGesture:self.moreBtn];
    [self addIndexGesture:self.moreBtn2];
    
    // Title of View
    self.title = NSLocalizedStringFromTableInBundle(@"acW-dT-cKf.title", @"Main", [NSBundle mainBundle], nil);
    
    // Scroll
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.MainScroll.delegate = self.scrollDelegate;
    self.scrollDelegate.nav = self.navigationController;
    self.scrollDelegate.movingButtons = self.movingButtons;
    [self.scrollDelegate setupStatusbar:self.view];
    //CGPoint position = CGPointMake(0,0);
    //[self.MainScroll setContentOffset:position];
    
    // Navigation Controller
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
    
    self.FirstChevron.image = self.SecondChevron.image = [UIImage imageWithIcon:@"fa-chevron-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:0.97 green:0.39 blue:0.00 alpha:1.0] andSize:CGSizeMake(10, 14)];

    // Movie Table1 and Table2
    self.movieTable2Controller = [[MovieTableViewController alloc] init:1];
    self.movieTableController = [[MovieTableViewController alloc] init:0];
    self.movieTable.scrollEnabled = NO;

    // Calling methods to init data
    [self imageScrollCall];
    [self topicCall];
    [self reviewCall];

    // App Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    // Crashlytics init
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"] == nil) {
        // Not login
        [self logUserWithDefault];
    }
}

-(void)failAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                    message:@"想看跟看過不能共存"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil,nil];
    [alert show];
}

-(void)applicationIsActive:(NSNotification *)notification{
    [self refreshPage];
}

-(void)reviewCall{
    
    [[AustinApi sharedInstance]getReview:API_REVIEW_ORDER_HOT1W
                                    page:nil
                                     uid:nil
                                function:^(NSArray *returnData) {
        
        self.movieTable2Controller.data = returnData;
        self.movieTable2.delegate = self.movieTable2Controller;
        self.movieTable2.dataSource = self.movieTable2Controller;
        self.movieTable2Controller.tableHeight = self.movieTable2Height;
        self.movieTable2Controller.tableView = self.movieTable2;
        [self.movieTable2Controller.tableView reloadData];
        [self.movieTable2Controller ParentController:self];
        [self readjustScrollsize];
        
    } error:^(NSError *error) {
    }];
}

-(void)topicCall{
    
    [[AustinApi sharedInstance]getTopic:API_TOPIC_TYPE_CLASSIC
                                    vid:nil
                                   page:nil
                                    uid:nil
                               function:^(NSArray *returnData) {
                                   
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (NSDictionary *row in returnData) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:row];
            if ([array count] < 2)
                [array addObject:dict];
        }
                                   
        self.movieTableController.data =array;
        self.movieTable.delegate = self.movieTableController;
        self.movieTable.dataSource = self.movieTableController;
        self.movieTableController.tableHeight = self.movieTableHeight;
        self.movieTableController.tableView = self.movieTable;
        [self.movieTableController.tableView reloadData];
        self.movieTableTopspace.constant = 45+ [self.movieTableController returnTotalHeight];
        [self.movieTableController ParentController:self];
        [self readjustScrollsize];
                                   
    } error:^(NSError *error) {
    }];

}

-(void)imageScrollCall{
    
    [[AustinApi sharedInstance] movieList:^(NSArray *returnData) {
        
        //NSLog(@"%@",returnData);
        self.returnData = [[NSMutableArray alloc]init];
        self.movieArray = [[NSMutableArray alloc]init];
        
        int margin = 15;
        int width = 255;
        int height = 341;
        int count = 0;
        
        self.imageScroll.contentSize = CGSizeMake(width* [returnData count], 341);
        
        for(NSDictionary *row in returnData){
            
            [self.returnData addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
            
            movieModel *temp = [movieModel alloc];
            
            // Movie title with CN or TW name
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            if([language containsString:@"zh-Hans"]){
                temp.title = [row objectForKey:@"CNName"];
            }
            else{
                temp.title = [row objectForKey:@"Name"];
            }
            
            temp.rating = [NSString stringWithFormat:@"%@", [row objectForKey:@"AverageScore"]];
            temp.IsViewed = [[row objectForKey:@"IsViewed"]boolValue];
            temp.IsLiked = [[row objectForKey:@"IsLiked"]boolValue];
            temp.IsWantView = [[row objectForKey:@"IsWantView"]boolValue];
            
            // Poster placeholder
            UIImage *placeholder = [UIImage imageNamed:@"placeholder-poster.jpg"];
            UIImageView *image = [[UIImageView alloc] initWithImage:temp.movieImage];
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = 5;
            
            // Poster image URL
            NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=235",[row objectForKey:@"Picture"]];
            
            // Set poster image
            image.userInteractionEnabled = YES;
            image.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
            [self.imageScroll addSubview:image];
            temp.movieImageView = image;
            
            // Rating btn
            UIView *ratingBg = [[UIView alloc]initWithFrame:CGRectMake(margin+width*count, 275, 66, 66)];
            ratingBg.backgroundColor = [UIColor colorWithRed:(77.0f/255.0f) green:(182.0f/255.0f) blue:(172.0f/255.0f) alpha:0.6];
            [self curvedMask:ratingBg];
            [self.imageScroll addSubview:ratingBg];
            
            // Star for rating btn
            UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 18, 18)];
            star.image = [UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 18)];
            [ratingBg addSubview:star];
            
            // Label string with rating
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 36, 52, 21)];
            if(![[row objectForKey:@"AverageScore"] isKindOfClass:[NSNull class]]){
                label.text = [NSString stringWithFormat:@"%0.1f", [[row objectForKey:@"AverageScore"]floatValue]];
            } else {
                label.text = @"";
                star.image = [UIImage imageWithIcon:@"fa-star-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 18)];
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [ratingBg addSubview:label];
            
            // Movie Array
            [self.movieArray addObject:temp];
            if(count==0){
                [image sd_setImageWithURL:[NSURL URLWithString:url]
                         placeholderImage:placeholder
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self setMovieDetails:[self.movieArray objectAtIndex:0] blur:YES];
                                }];
            } else {
                [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
            }
            count++;
            
            // Login
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:4];
            LoginController *login = [[nav viewControllers]objectAtIndex:0];
            login.images = self.movieArray;
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)readjustScrollsize{
    int height;
    height = [self.movieTableController returnTotalHeight]+[self.movieTable2Controller returnTotalHeight]+600;
    self.MainScroll.contentSize = CGSizeMake(self.view.bounds.size.width, height);
}

-(void)viewWillDisappear:(BOOL)animated{
    self.MainScroll.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.MainScroll setContentOffset:CGPointZero];
    [self.scrollDelegate disappear];
    
    self.notSelected = YES;
    self.MainScroll.delegate = self.scrollDelegate;
    
    if(self.refresh){
        [self refreshPage];
    }else{
        int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
        [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage] blur:YES];
        self.lastIndex = indexOfPage;
    }
    
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];
    if(returnData!=nil){
        [[AustinApi sharedInstance]getFriends:[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue]
                                         page:1
                                     function:nil
                                      refresh:NO];
    }
}

-(void)refreshPage{
    
    [[self.imageScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
    self.uititle.text= @"";
    self.blurredBg.image =nil;
    self.movieArray =nil;
    self.returnData =nil;
    self.iconEyeIndex.image = [UIImage imageNamed:@"iconEyeIndex.png"];
    self.iconLikeIndex.image = [UIImage imageNamed:@"iconLikeIndex.png"];
    self.iconPoketIndex.image = [UIImage imageNamed:@"iconPoketIndex.png"];
    self.lastIndex =0;
    self.refresh =NO;
    
    [self imageScrollCall];
    [self topicCall];
    [self reviewCall];
    
}

-(void)addIndexGesture:(UIView*)view{
    
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)movieDetail:(id)sender{
    
    if(self.notSelected && [self.movieArray count] > 0){
        [self performSegueWithIdentifier:@"movieDetail" sender:self];
        self.notSelected = NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"movieDetail"]){
        
        int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
        NSLog(@"%d",indexOfPage);
        
        MovieDetailController *detailVc = segue.destinationViewController;
        detailVc.movieDetailInfo = [self.returnData objectAtIndex:indexOfPage];
        detailVc.model = [self.movieArray objectAtIndex:indexOfPage];
    }
    
    if([[segue identifier] isEqualToString:@"reviewSegue"]){
        
        reviewController *vc = segue.destinationViewController;
        
        if(self.movieTable2Controller.selectIndex==-1){
            vc.newReview = YES;
            
            int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
            NSDictionary *vData = [self.returnData objectAtIndex:indexOfPage];
            movieModel *movie = [self.movieArray objectAtIndex:indexOfPage];
            
            NSDictionary *User = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                              objectForKey:@"userkey"]]objectForKey:@"Data"];
            NSDictionary *param = @{@"VideoPosterUrl":[vData objectForKey:@"PosterUrl"],
                                    @"UserAvatar":[User objectForKey:@"Avatar"],
                                    @"UserNickName":[User objectForKey:@"NickName"],
                                    @"VideoName":[vData objectForKey:@"CNName"],
                                    @"OwnerLinkVideo_Score":@10,
                                    @"OwnerLinkVideo_IsLiked":[NSNumber numberWithBool:movie.IsLiked],
                                    @"PageViews":@0,
                                    @"LikedNum":@0,
                                    @"SharedNum":@0,
                                    @"UserId":[User objectForKey:@"UserId"],
                                    @"IsLiked":@false,
                                    @"IsShared":@false,
                                    @"ReviewId":@0,
                                    @"VideoId":[vData objectForKey:@"Id"]};
            
            vc.data = [[NSMutableDictionary alloc]initWithDictionary:param];
        } else {
            vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTable2Controller.data objectAtIndex:self.movieTable2Controller.selectIndex]];
        }
        
        if(self.syncReview ==YES){
            vc.sync = YES;
            self.syncReview = NO;
        }
    }
    
    if([[segue identifier] isEqualToString:@"topicSegue"]){
        TopicDetailViewController *vc = segue.destinationViewController;
        vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex]];
        if(![[self.movieTableController.circlePercentage objectAtIndex:self.movieTableController.selectIndex]isKindOfClass:[NSNull class]]){
            vc.percent = [self.movieTableController.circlePercentage objectAtIndex:self.movieTableController.selectIndex];}else{
                vc.percent = [[NSNumber alloc]initWithInt:-1];
            }
        NSLog(@"%@",self.movieTableController.circlePercentage);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if(self.lastIndex!=indexOfPage){
        [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage] blur:YES];
        self.lastIndex = indexOfPage;
    }

}

-(void)setMovieDetails:(movieModel*)model blur:(BOOL)blur{
    
    self.uititle.text = model.title;
    
    if(blur){
        self.blurredBg.image =[buttonHelper blurImage:model.movieImageView.image  withBottomInset:0 blurRadius:43];
    }
    
    if(model.IsViewed){
        self.iconEyeIndex.image = [UIImage imageNamed:@"iconEyeIndexActive.png"];
    }else{
        self.iconEyeIndex.image = [UIImage imageNamed:@"iconEyeIndex.png"];
    }
    
    if(model.IsLiked){
        self.iconLikeIndex.image = [UIImage imageNamed:@"iconHeartIndexActive.png"];
    }else{
        self.iconLikeIndex.image = [UIImage imageNamed:@"iconLikeIndex.png"];
    }
    
    if(model.IsWantView){
        self.iconPoketIndex.image = [UIImage imageNamed:@"iconPocketIndexActive.png"];
    }else{
        self.iconPoketIndex.image = [UIImage imageNamed:@"iconPoketIndex.png"];
    }
}

-(void)curvedMask:(UIView*)view{
    UIBezierPath *aPath = [UIBezierPath bezierPath];

    CGSize viewSize = view.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x,viewSize.height)]; //(489,0)
    [aPath addLineToPoint:CGPointMake(viewSize.width,viewSize.height)];
    [aPath addQuadCurveToPoint:CGPointMake(0,0) controlPoint:CGPointMake(viewSize.width, 0)];
    
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = view.bounds;
    layer.path = aPath.CGPath;
    view.layer.mask = layer;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)indexClick:(UITapGestureRecognizer *)sender{
    NSLog(@"asd%ld",sender.view.tag);
    
    if(sender.view.tag<4){
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]!=nil){
            
            if(sender.view.tag==3){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                                message:@"此功能未開放"
                                                               delegate:self
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil,nil];
                [alert show];
                //self.movieTable2Controller.selectIndex = -1;
                //[self performSegueWithIdentifier:@"reviewSegue" sender:self];
            }else{
                int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
                NSLog(@"%@",[[self.returnData objectAtIndex:indexOfPage]objectForKey:@"Id"]);
                
                [[AustinApi sharedInstance]socialAction:[[self.returnData objectAtIndex:indexOfPage]objectForKey:@"Id"]
                                                    act:[NSString stringWithFormat:@"%ld",sender.view.tag]
                                                    obj:@"1"
                                               function:^(NSString *returnData) {

                                                   movieModel *model = [self.movieArray objectAtIndex:indexOfPage];
                                                   NSMutableDictionary *data = [self.returnData objectAtIndex:indexOfPage];
                                                   
                                                   // IsViewed
                                                   if(sender.view.tag==0){
                                                       if(model.IsWantView){
                                                           [self failAlert];
                                                       }else{
                                                           model.IsViewed =!model.IsViewed;
                                                           [data setObject:[[NSNumber alloc] initWithBool:model.IsViewed] forKey:@"IsViewed"];
                                                       }
                                                   }
                                                   
                                                   // IsLiked
                                                   if(sender.view.tag==1){
                                                       model.IsLiked =!model.IsLiked;
                                                       [data setObject:[[NSNumber alloc] initWithBool:model.IsLiked] forKey:@"IsLiked"];
                                                   }
                                                   
                                                   // IsWantView
                                                   if(sender.view.tag==2){
                                                       if(model.IsViewed){
                                                           [self failAlert];
                                                       }else{
                                                           model.IsWantView = !model.IsWantView;
                                                           [data setObject:[[NSNumber alloc] initWithBool:model.IsWantView] forKey:@"IsWantView"];
                                                       }
                                                   }
                                                   
                                                   [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage] blur:NO];
                                               } error:^(NSError *error) {
                                                   NSLog(@"%@",error);
                                               }];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                            message:@"请登入"
                                                           delegate:self
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(sender.view.tag==4){ //Moving Btn: Movie-New 院線熱映
        // GoTO: Topic page(1) and JumpTO: Movie-New(1)
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        MovieViewController *movie = [[nav viewControllers]objectAtIndex:0];
        movie.jump = 1;
        self.tabBarController.selectedIndex =1;
    }
    
    if(sender.view.tag==5){ //Moving Btn: Movie-Hot 熱門電影
        // GoTO: Topic page(1) and JumpTO: Movie-Hot(2)
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        MovieViewController *movie = [[nav viewControllers]objectAtIndex:0];
        movie.jump = 2;
        self.tabBarController.selectedIndex = 1;
    }
    
    if(sender.view.tag==6){ //必刷專題-More
        // GoTO: Topic page(3) and JumpTO: Classical topic(0)
        self.tabBarController.selectedIndex = 3;
    }
    
    if(sender.view.tag==7){ //熱門影評-More
        // GoTO: Topic page(1) and JumpTO: Review(4)
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        MovieViewController *movie = [[nav viewControllers]objectAtIndex:0];
        movie.jump = 3;
        self.tabBarController.selectedIndex = 1;
    }
    
    if(sender.view.tag==8){ //Moving-Btn: Topic-Index 熱映專題
        // GoTO: Topic page(3) and JumpTO: Hot topic(?)
        self.tabBarController.selectedIndex = 3;
    }
}

-(void)loadMore:(int)page{

}

- (void) logUserWithDefault {
    [CrashlyticsKit setUserIdentifier:@"MovieCaker-iOS"];
    [CrashlyticsKit setUserEmail:@"MovieCaker-iOS"];
    [CrashlyticsKit setUserName:@"MovieCaker-iOS"];
    NSLog(@"CrashlyticsKit-logUser: Default");
}

@end
