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

@interface MovieDetailController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIScrollView *actorScroll;
@property (strong, nonatomic) IBOutlet UITableView *topicTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topicTableHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UITableView *reviewTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewTableHeight;
@property MovieTableViewController *movieTableController;
@property MovieTableViewController *movieTable2Controller;
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
@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconPageBackNoheader.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bgImage.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.7f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    self.bgImage.layer.mask = gradientLayer;
    [self createActorSlider];
    
    self.movieTableController = [[MovieTableViewController alloc] init:0];
    self.topicTable.delegate = self.movieTableController;
    self.topicTable.dataSource = self.movieTableController;
    self.movieTableController.tableHeight = self.topicTableHeight;
    self.movieTableController.tableView = self.topicTable;
    
    self.movieTable2Controller = [[MovieTableViewController alloc] init:1];
    self.reviewTable.delegate = self.movieTable2Controller;
    self.reviewTable.dataSource = self.movieTable2Controller;
    self.movieTable2Controller.tableHeight = self.reviewTableHeight;
    self.movieTable2Controller.tableView = self.reviewTable;
    
    self.starArray = [[NSArray alloc]initWithObjects:self.starOne,self.starTwo,self.starThree,self.starFour,self.starFive, nil];
    [self setStars:[[self.movieDetailInfo objectForKey:@"AverageScore"]intValue]];
    self.ChineseName.text = [self.movieDetailInfo objectForKey:@"CNName"];
    self.EnglishName.text = [self.movieDetailInfo objectForKey:@"ENName"];
    [self.smallImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=90",[self.movieDetailInfo objectForKey:@"Picture"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:[self.movieDetailInfo objectForKey:@"PosterPath"]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.releaseDate.text = [NSString stringWithFormat:@"%@ 上映",[[self.movieDetailInfo objectForKey:@"ReleaseDate"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    self.movieDescription.text = [self.movieDetailInfo objectForKey:@"Intro"];
    self.movieDescriptionHeight.constant = [self.movieDescription.text length]/26*30;
    NSLog(@"%@",self.movieDetailInfo);
}

-(void)createActorSlider{
    int width = 100;
    int margin =10;
    int height = 150;
    int count = 0;
    
    for (int i=0; i<11; i++) {
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"on.png"]];
    view.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(margin+width*count, height, width-margin*2, 20)];
    label.textAlignment =NSTextAlignmentLeft;
    label.textColor  = [[UIColor alloc]initWithRed:51.0/255.0f green:68.0/255.0f blue:85.0/255.0f alpha:1];
    label.text = @"actor";
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
-(void)viewDidLayoutSubviews{

    self.actorScroll.contentSize = CGSizeMake(100*11, self.actorScroll.frame.size.height);
    self.mainScroll.contentSize  = CGSizeMake(self.view.frame.size.width,3400);
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
