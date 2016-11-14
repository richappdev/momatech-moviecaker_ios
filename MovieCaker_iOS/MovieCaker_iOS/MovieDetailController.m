//
//  MovieDetailControllerViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/14/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieDetailController.h"
#import "MovieTableViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AustinApi.h"
#import "MainVerticalScroller.h"
#import "buttonHelper.h"
#import "reviewController.h"
#import "WXApi.h"
#import "WechatAccess.h"
#import "TopicDetailViewController.h"
#import "UIImage+FontAwesome.h"

@interface MovieDetailController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIScrollView *actorScroll;
@property (strong, nonatomic) IBOutlet UIView *TopicTop;
@property (strong, nonatomic) IBOutlet UIView *topicGrey;
@property (strong, nonatomic) IBOutlet UITableView *topicTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topicTableHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *reviewGrey;
@property (strong, nonatomic) IBOutlet UIView *reviewTop;
@property (strong, nonatomic) IBOutlet UITableView *reviewTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewTableHeight;
@property MovieTableViewController *firstTableController;
@property MovieTableViewController *secondTableController;
@property NSArray *starArray;
@property (strong, nonatomic) IBOutlet UIImageView *starOne;
@property (strong, nonatomic) IBOutlet UIImageView *starTwo;
@property (strong, nonatomic) IBOutlet UIImageView *starThree;
@property (strong, nonatomic) IBOutlet UIImageView *starFour;
@property (strong, nonatomic) IBOutlet UIImageView *starFive;
@property (strong, nonatomic) IBOutlet UILabel *ChineseName;
@property (strong, nonatomic) IBOutlet UILabel *EnglishName;
@property (strong, nonatomic) IBOutlet UILabel *releaseDate;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *movieDescriptionHeight;
@property (strong, nonatomic) IBOutlet UILabel *movieDescription;
@property (strong, nonatomic) IBOutlet UILabel *imdb;
@property (strong, nonatomic) IBOutlet UILabel *bean;
@property (strong, nonatomic) IBOutlet UIButton *readMoreBtn;
@property (strong, nonatomic) IBOutlet UILabel *ViewNum;
@property (strong, nonatomic) IBOutlet UILabel *LikeNum;
@property (strong, nonatomic) IBOutlet UILabel *WantViewNum;
@property (strong, nonatomic) IBOutlet UILabel *ReviewNum;
@property (strong, nonatomic) IBOutlet UILabel *ShareNum;
@property (strong, nonatomic) IBOutlet UIView *reviewBtn;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *watchBtn;
@property (strong, nonatomic) IBOutlet UIView *wannaBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UIView *moreBtn;
@property (strong, nonatomic) IBOutlet UIImageView *Chervon;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property UITapGestureRecognizer *watchGesture;
@property BOOL newReview;
@property BOOL opened;
@property BOOL simplified;
@property MainVerticalScroller *scrollDelegate;
@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.simplified = [[[NSUserDefaults standardUserDefaults] objectForKey:@"simplified"] boolValue];
    [buttonHelper gradientBg:self.bgImage width:self.view.frame.size.width];
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.scrollDelegate.nav = self.navigationController;
    [self.scrollDelegate setupBackBtn:self];
    [self.scrollDelegate setupStatusbar:self.view];
    
    self.firstTableController = [[MovieTableViewController alloc] init:0];
    self.firstTableController.data = [[NSArray alloc]init];
    [self.firstTableController ParentController:self];
    
    [self topicCall];
    
    self.secondTableController = [[MovieTableViewController alloc] init:1];
    self.reviewTable.scrollEnabled = false;
    self.reviewTable.delegate = self.secondTableController;
    self.reviewTable.dataSource = self.secondTableController;
    self.secondTableController.tableHeight = self.reviewTableHeight;
    self.secondTableController.tableView = self.reviewTable;
    self.secondTableController.data =[[NSArray alloc]init];
    [self.secondTableController ParentController:self];

    [self reviewCall];
    
    self.starArray = [[NSArray alloc]initWithObjects:self.starOne,self.starTwo,self.starThree,self.starFour,self.starFive, nil];
    if(self.loadLater!=YES){
        [self changeReal];
    }
    //NSLog(@"%@",self.movieDetailInfo);
    
    [[AustinApi sharedInstance] movieDetail:[self.movieDetailInfo objectForKey:@"Id"] function:^(NSMutableDictionary *returnData) {
       // NSLog(@"%@",[returnData objectForKey:@"Actor"]);
        if(self.loadLater==YES){
            self.movieDetailInfo = [[NSMutableDictionary alloc] initWithDictionary:returnData];
            [self changeReal];
        }
        
        int count = 0;
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[returnData objectForKey:@"Actor"]];
        for (NSDictionary *row in array) {
            if([[row objectForKey:@"RoleType"]isEqualToString:@"Director"]){
                id obj = array[count];
                [array removeObjectAtIndex:count];
                [array insertObject:obj atIndex:0];
                break;
            }
            count++;
        }
        [self createActorSlider:array];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [self addIndexGesture:self.reviewBtn];
    [self addIndexGesture:self.likeBtn];
    // [self addIndexGesture:self.watchBtn];
    //[self addIndexGesture:self.wannaBtn];
    [self addIndexGesture:self.shareBtn];
    
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(watchClick:)];
    [self.watchBtn addGestureRecognizer:indexTap];
    
    
    UITapGestureRecognizer *indexTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wantWatchClick:)];
    [self.wannaBtn addGestureRecognizer:indexTap2];
    
    [self addMask];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreClick)];
    [self.moreBtn addGestureRecognizer:tap];
   self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
}
-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)topicCall{
    [[AustinApi sharedInstance]getTopic:@"7" vid:[self.movieDetailInfo objectForKey:@"Id"] page:nil uid:nil function:^(NSArray *returnData) {
        NSLog(@"a%lu",(unsigned long)[returnData count]);
        self.topicTable.scrollEnabled = false;
        self.topicTable.delegate = self.firstTableController;
        self.topicTable.dataSource = self.firstTableController;
        self.firstTableController.tableHeight = self.topicTableHeight;
        self.firstTableController.tableView = self.topicTable;
        if([returnData count]==0){
            self.topicGrey.hidden = YES;
            self.TopicTop.hidden = YES;
            self.topicTable.hidden = YES;
            self.topicTableHeight.constant = 0;
        }else{
            self.firstTableController.data = returnData;
            [self.firstTableController.tableView reloadData];}
        [self scrollSize];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)reviewCall{
    [[AustinApi sharedInstance] getReviewByVid:[self.movieDetailInfo objectForKey:@"Id"] function:^(NSArray *returnData) {
        NSLog(@"b%lu",(unsigned long)[returnData count]);
        
        if([returnData count]==0){
            self.reviewTop.hidden=YES;
            self.reviewGrey.hidden=YES;
            self.reviewTable.hidden=YES;
        }else{
            self.secondTableController.data = returnData;
            [self.secondTableController.tableView reloadData];
        }
        [self scrollSize];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)changeReal{
    if(![[self.movieDetailInfo objectForKey:@"AverageScore"] isKindOfClass:[NSNull class]]){
        [self setStars:floor([[self.movieDetailInfo objectForKey:@"AverageScore"]floatValue])];
    }else{
        [self setStars:10];
    }
    if(self.simplified){
        self.movieDescription.text = [self.movieDetailInfo objectForKey:@"CNIntro"];
        self.title = self.ChineseName.text = [self.movieDetailInfo objectForKey:@"CNName"];
    }
    else{
        self.movieDescription.text = [self.movieDetailInfo objectForKey:@"Intro"];
        self.title = self.ChineseName.text = [self.movieDetailInfo objectForKey:@"Name"];
    }
    self.EnglishName.text = [self.movieDetailInfo objectForKey:@"ENName"];
    [self.smallImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?width=90",[self.movieDetailInfo objectForKey:@"PosterUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:[self.movieDetailInfo objectForKey:@"BannerUrl"]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.releaseDate.text = [NSString stringWithFormat:@"%@ 上映",[[self.movieDetailInfo objectForKey:@"ReleaseDate"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
  /*  if([buttonHelper isLabelTruncated:self.movieDescription]==NO){
        self.readMoreBtn.hidden = YES;
    }*/
    if(![[self.movieDetailInfo objectForKey:@"Ratings_Douban"] isKindOfClass:[NSNull class]]){
    self.bean.text = [NSString stringWithFormat:@"%.1f",[[self.movieDetailInfo objectForKey:@"Ratings_Douban"]floatValue]];}
    if(![[self.movieDetailInfo objectForKey:@"Ratings_IMDB"] isKindOfClass:[NSNull class]]){
    self.imdb.text = [NSString stringWithFormat:@"%.1f",[[self.movieDetailInfo objectForKey:@"Ratings_IMDB"]floatValue]];
    }
    self.ViewNum.text =[[self.movieDetailInfo objectForKey:@"ViewNum"]stringValue];
    self.LikeNum.text =[[self.movieDetailInfo objectForKey:@"LikeNum"]stringValue];
    self.WantViewNum.text =[[self.movieDetailInfo objectForKey:@"WantViewNum"]stringValue];
    self.ReviewNum.text =[[self.movieDetailInfo objectForKey:@"ReviewNum"]stringValue];
    self.ShareNum.text =[[self.movieDetailInfo objectForKey:@"ShareNum"]stringValue];
    
    [buttonHelper v2AdjustWatch:self.watchBtn state:[[self.movieDetailInfo objectForKey:@"IsViewed"] boolValue]];
    [buttonHelper v2AdjustLike:self.likeBtn state:[[self.movieDetailInfo objectForKey:@"IsLiked"] boolValue]];
    [buttonHelper v2AdjustWanna:self.wannaBtn state:[[self.movieDetailInfo objectForKey:@"IsWantView"] boolValue]];

}
-(IBAction)readMore:(id)sender{
    UIButton *btn = sender;
    btn.hidden = YES;
    [self.movieDescription sizeToFit];
    self.movieDescriptionHeight.constant = self.movieDescription.frame.size.height;
    [self scrollSize];
}
-(void)createActorSlider:(NSArray*)actors{
    int width = 100;
    int margin =10;
    int height = 150;
    int count = 0;
    self.actorScroll.contentSize = CGSizeMake(100*[actors count], self.actorScroll.frame.size.height);
    for (NSDictionary *row in actors) {
    
    UIImageView *view = [[UIImageView alloc]init];
    view.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
    [view sd_setImageWithURL:[NSURL URLWithString:[row objectForKey:@"Avatar"]]  placeholderImage:[UIImage imageNamed:@"nobody-big.jpg"]];
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(margin+width*count, height, width-margin*2, 20)];
    label.textAlignment =NSTextAlignmentLeft;
    label.textColor  = [[UIColor alloc]initWithRed:51.0/255.0f green:68.0/255.0f blue:85.0/255.0f alpha:1];
    label.text = [row objectForKey:@"CNName"];
    label.font =  [UIFont fontWithName:@"Heiti SC" size:14.0f];
        
    [self.actorScroll addSubview:label];
    [self.actorScroll addSubview:view];
    count++;
    }

}
-(void)setStars:(int)rating{
    int main =floor(rating/2);
    int remain = rating%2;
    int count = 1;
    for (UIImageView *row in self.starArray) {
        if(main>=count){
            row.image = [UIImage imageNamed:@"iconStarSitetotal.png"];
        }else if (remain==1&&count==(main+1)){
            row.image = [UIImage imageNamed:@"iconStarHalfSitetotal.png"];
        }else{
            row.image = [UIImage imageNamed:@"iconStarOSitetotal.png"];
        }
        
        count++;
    }
    
}

-(void)scrollSize{
    int height;
    height = [self.firstTableController returnTotalHeight]+[self.secondTableController returnTotalHeight]+700+self.movieDescriptionHeight.constant;
 //   NSLog(@"%d",[self.secondTableController returnTotalHeight]);
    self.mainScroll.contentSize = CGSizeMake(self.view.bounds.size.width, height);
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    self.mainScroll.delegate = self.scrollDelegate;
    
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    if(movie.refresh){
     //   self.firstTableController = nil;
       // self.secondTableController = nil;
        //[self.navigationController popViewControllerAnimated:NO];
        [self reviewCall];
        [self topicCall];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    self.mainScroll.delegate = nil;
    if(self.syncReview){
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
        MovieController *movie = [[nav viewControllers]objectAtIndex:0];
        movie.refresh = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"topicSegue"]){
        TopicDetailViewController *vc = segue.destinationViewController;
        vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.firstTableController.data objectAtIndex:self.firstTableController.selectIndex]];
        vc.percent = [NSNumber numberWithInt:-1];
    }
    
    if([[segue identifier] isEqualToString:@"reviewSegue"]){
    reviewController *vc = segue.destinationViewController;
    if(self.newReview){
        self.newReview = NO;
        vc.newReview = YES;
        vc.data = [buttonHelper reviewNewData:self.movieDetailInfo User:[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]]objectForKey:@"Data"]];
    }else{
    vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.secondTableController.data objectAtIndex:self.secondTableController.selectIndex]];
        if(self.syncReview ==YES){
            vc.sync = YES;
            self.syncReview = NO;
        }}
    }
}
-(void)watchClick:(UITapGestureRecognizer *)gesture{
    self.watchGesture =gesture;
    
    if([[self.movieDetailInfo objectForKey:@"IsWantView"]boolValue]&&![[self.movieDetailInfo objectForKey:@"IsViewed"]boolValue]){
        [self failAlert];
    }else if([[self.movieDetailInfo objectForKey:@"IsViewed"]boolValue]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"你確定要取消看過嗎？"
                                                      delegate:self
                                             cancelButtonTitle:@"好"
                                             otherButtonTitles:@"不要",nil];
        [alert show];
    }else{
        [self indexClick:gesture];
    }

}

-(void)wantWatchClick:(UITapGestureRecognizer*)gesture{
    if([[self.movieDetailInfo objectForKey:@"IsViewed"]boolValue]&&![[self.movieDetailInfo objectForKey:@"IsWantView"]boolValue]){
        [self failAlert];
    }else{
        [self indexClick:gesture];
    }
}
-(void)failAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"想看跟看過不能共存" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self indexClick:self.watchGesture];
    }
}
-(void)indexClick:(UITapGestureRecognizer *)gesture{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        UIView *view = gesture.view;
        if(view.tag==0||view.tag==1||view.tag==2||view.tag==3){
            if(view.tag==3){
            
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [self.movieDetailInfo objectForKey:@"CNName"];
                
                NSString *str;
                if ([[self.movieDetailInfo objectForKey:@"Intro"] length]>140) {
                    str=[[self.movieDetailInfo objectForKey:@"Intro"] substringToIndex:140];
                }else{
                    str=[self.movieDetailInfo objectForKey:@"Intro"];
                }
                
                message.description=str;
                
                [message setThumbImage:self.smallImage.image];
                
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl =  [NSString stringWithFormat:@"%@/video/%@",[[AustinApi sharedInstance] getBaseUrl],[self.movieDetailInfo objectForKey:@"Id"]];
                NSLog(@"%@",ext.webpageUrl);
                message.mediaObject = ext;
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                
                [WXApi sendReq:req];
            
            }else{
            UILabel *label = [view viewWithTag:6];
            NSNumber *boolValue;
            int count;
            if(view.tag==0){
                count = [[self.movieDetailInfo objectForKey:@"ViewNum"] integerValue];
                boolValue = [self.movieDetailInfo objectForKey:@"IsViewed"];
            }else if (view.tag==1){
                count = [[self.movieDetailInfo objectForKey:@"LikeNum"] integerValue];
                boolValue = [self.movieDetailInfo objectForKey:@"IsLiked"];
            }else if (view.tag==2){
                count = [[self.movieDetailInfo objectForKey:@"WantViewNum"] integerValue];
                boolValue = [self.movieDetailInfo objectForKey:@"IsWantView"];
            }
            if([boolValue boolValue]){
                count--;
            }else{
                count++;
            }
            
            
            if(view.tag==0){
                [buttonHelper v2AdjustWatch:self.watchBtn state:![boolValue boolValue]];
                [self.movieDetailInfo setObject:[[NSNumber alloc] initWithBool:![boolValue boolValue]] forKey:@"IsViewed"];
                [self.movieDetailInfo setObject:[NSNumber numberWithInt:count] forKey:@"ViewNum"];
                self.model.IsViewed = ![boolValue boolValue];
            }else if (view.tag==1){
                [buttonHelper v2AdjustLike:self.likeBtn state:![boolValue boolValue]];
                [self.movieDetailInfo setObject:[[NSNumber alloc] initWithBool:![boolValue boolValue]] forKey:@"IsLiked"];
                [self.movieDetailInfo setObject:[NSNumber numberWithInt:count] forKey:@"LikeNum"];
                self.model.IsLiked = ![boolValue boolValue];
            }else if (view.tag==2){
                [buttonHelper v2AdjustWanna:self.wannaBtn state:![boolValue boolValue]];
                [self.movieDetailInfo setObject:[[NSNumber alloc] initWithBool:![boolValue boolValue]] forKey:@"IsWantView"];
                [self.movieDetailInfo setObject:[NSNumber numberWithInt:count] forKey:@"WantViewNum"];
                self.model.IsWantView = ![boolValue boolValue];
            }
                label.text = [NSString stringWithFormat:@"%d",count];}
            
            [[AustinApi sharedInstance]socialAction:[self.movieDetailInfo objectForKey:@"Id"] act:[NSString stringWithFormat:@"%ld",(long)view.tag] obj:@"1" function:^(NSString *returnData) {
                NSLog(@"%@",returnData);
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else if(view.tag==4){
            self.newReview =YES;
            [self performSegueWithIdentifier:@"reviewSegue" sender:self];
        }
    }
}
-(void)addMask{/*
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.0f, @1.0f ];
    maskLayer.frame = CGRectMake(0,0, self.view.frame.size.width, self.movieDescriptionHeight.constant);
    self.movieDescription.layer.mask = maskLayer;*/
}
-(void)moreClick{
    if(self.opened){
        self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
        self.moreLabel.text = @"展開全文";
        self.movieDescriptionHeight.constant = 94;
        [self addMask];
    }else{
        self.Chervon.image = [UIImage imageWithIcon:@"fa-chevron-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 20)];
        self.moreLabel.text = @"顯示部分";
        [self.movieDescription sizeToFit];
        self.movieDescription.layer.mask = nil;
        self.movieDescriptionHeight.constant = self.movieDescription.frame.size.height+10;
   //     self.moreHeight.constant = self.contentHeight.constant-3+10;
    }
    self.opened = !self.opened;
    [self scrollSize];
}
@end
