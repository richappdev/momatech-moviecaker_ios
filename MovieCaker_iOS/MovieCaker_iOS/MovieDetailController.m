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
@property MainVerticalScroller *scrollDelegate;
@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame =CGRectMake(self.bgImage.frame.origin.x, self.bgImage.frame.origin.y, self.view.frame.size.width, self.bgImage.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.7f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    self.bgImage.layer.mask = gradientLayer;
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];

    self.scrollDelegate.nav = self.navigationController;
    [self.scrollDelegate setupBackBtn:self];
    [self.scrollDelegate setupStatusbar:self.view];
    
    self.firstTableController = [[MovieTableViewController alloc] init:0];
    self.firstTableController.data = [[NSArray alloc]init];
    
    [[AustinApi sharedInstance]getTopic:@"7" vid:[self.movieDetailInfo objectForKey:@"Id"] function:^(NSArray *returnData) {
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
    self.secondTableController = [[MovieTableViewController alloc] init:1];
    self.reviewTable.scrollEnabled = false;
    self.reviewTable.delegate = self.secondTableController;
    self.reviewTable.dataSource = self.secondTableController;
    self.secondTableController.tableHeight = self.reviewTableHeight;
    self.secondTableController.tableView = self.reviewTable;
    self.secondTableController.data =[[NSArray alloc]init];
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
    
    self.starArray = [[NSArray alloc]initWithObjects:self.starOne,self.starTwo,self.starThree,self.starFour,self.starFive, nil];
    [self setStars:[[self.movieDetailInfo objectForKey:@"AverageScore"]intValue]];
    self.title = self.ChineseName.text = [self.movieDetailInfo objectForKey:@"CNName"];
    self.EnglishName.text = [self.movieDetailInfo objectForKey:@"ENName"];
    [self.smallImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?width=90",[self.movieDetailInfo objectForKey:@"PosterUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:[self.movieDetailInfo objectForKey:@"BannerUrl"]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.releaseDate.text = [NSString stringWithFormat:@"%@ 上映",[[self.movieDetailInfo objectForKey:@"ReleaseDate"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    self.movieDescription.text = [self.movieDetailInfo objectForKey:@"Intro"];
    self.movieDescriptionHeight.constant = [self.movieDescription.text length]/26*30;
    self.bean.text = [NSString stringWithFormat:@"%.1f",[[self.movieDetailInfo objectForKey:@"Ratings_Douban"]floatValue]];
    self.imdb.text = [NSString stringWithFormat:@"%.1f",[[self.movieDetailInfo objectForKey:@"Ratings_IMDB"]floatValue]];
    //NSLog(@"%@",self.movieDetailInfo);
    
    [[AustinApi sharedInstance] movieDetail:[self.movieDetailInfo objectForKey:@"Id"] function:^(NSMutableDictionary *returnData) {
       // NSLog(@"%@",[returnData objectForKey:@"Actor"]);
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
    [view sd_setImageWithURL:[NSURL URLWithString:[row objectForKey:@"Avatar"]]  placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
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
    self.navigationController.navigationBarHidden = NO;
    self.mainScroll.delegate = self.scrollDelegate;
    
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    if(movie.refresh){
        self.firstTableController = nil;
        self.secondTableController = nil;
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.mainScroll.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
