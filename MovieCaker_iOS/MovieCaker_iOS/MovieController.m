//
//  FirstViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieController.h"
#import "scrollBoxView.h"
#import "movieModel.h"
#import "UIImage+FontAwesome.h"
#import "MainVerticalScroller.h"
#import "MovieTableViewController.h"
#import "AustinApi.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MovieController ()
@property (strong, nonatomic) IBOutlet scrollBoxView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *uistar;
@property (strong, nonatomic) IBOutlet UILabel *uirating;
@property (strong, nonatomic) IBOutlet UILabel *uititle;
@property (strong, nonatomic) IBOutlet UIView *ratingBg;
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
@end

@implementation MovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.scrollView = self.imageScroll;
    self.imageScroll.delegate = self;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieDetail:)];
    [self.imageScroll addGestureRecognizer:singleTap];
    
    self.imageScroll.pagingEnabled = YES;
    //self.imageScroll.backgroundColor = [UIColor blueColor];
    self.imageScroll.clipsToBounds = NO;
    
    self.lastIndex = 0;

    [self curvedMask:self.ratingBg];
    self.uistar.image = [UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 18)];
    
    [self addIndexGesture:self.iconEyeBtn];
    [self addIndexGesture:self.iconPenBtn];
    [self addIndexGesture:self.iconPocketBtn];
    [self addIndexGesture:self.iconLikeBtn];
    [self addIndexGesture:self.iconMovieNew];
    [self addIndexGesture:self.iconMovieHot];
    [self addIndexGesture:self.iconTopicIndex];
    [self addIndexGesture:self.moreBtn];
    [self addIndexGesture:self.moreBtn2];
    self.title = @"首頁";
    
    self.scrollDelegate = [[MainVerticalScroller alloc] init];
    self.MainScroll.delegate = self.scrollDelegate;
    self.scrollDelegate.movieView = self;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    
    self.FirstChevron.image = self.SecondChevron.image = [UIImage imageWithIcon:@"fa-chevron-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:0.97 green:0.39 blue:0.00 alpha:1.0] andSize:CGSizeMake(10, 14)];
    
    self.movieTableController = [[MovieTableViewController alloc] init:0];
    self.movieTable.delegate = self.movieTableController;
    self.movieTable.dataSource = self.movieTableController;
    self.movieTableController.tableHeight = self.movieTableHeight;
    self.movieTableController.tableView = self.movieTable;

    self.movieTable2Controller = [[MovieTableViewController alloc] init:1];
    self.movieTable2.delegate = self.movieTable2Controller;
    self.movieTable2.dataSource = self.movieTable2Controller;
    self.movieTable2Controller.tableHeight = self.movieTable2Height;
    self.movieTable2Controller.tableView = self.movieTable2;
 //   CGPoint position = CGPointMake(0,0);
  //  [self.MainScroll setContentOffset:position];
    [[AustinApi sharedInstance] movieList:^(NSMutableDictionary *returnData) {
        NSLog(@"%@",returnData);
        
        self.movieArray = [[NSMutableArray alloc]init];
        
        int margin = 15;
        int width = 255;
        int height = 250;
        int count = 0;
        self.imageScroll.contentSize = CGSizeMake(width* [returnData count], self.imageScroll.frame.size.height);
        for(NSDictionary *row in returnData){
            
        movieModel *temp = [movieModel alloc];
        temp.title = [row objectForKey:@"CNName"];
        temp.rating = 10;
        UIImage *placeholder = [UIImage imageNamed:@"img-placeholder.jpg"];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:temp.movieImage];
       
        NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=235",[row objectForKey:@"Picture"]];
            
        if(count==0){
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self setMovieDetails:[self.movieArray objectAtIndex:0]];
            }];
        }
        else{
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
        }
        
        
        image.userInteractionEnabled = YES;
            
        image.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
        [self.imageScroll addSubview:image];
        
        temp.movieImageView = image;
        count++;
        [self.movieArray addObject:temp];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    int height;
    height = [self.movieTableController returnTotalHeight]+[self.movieTable2Controller returnTotalHeight]+550;
    self.MainScroll.contentSize = CGSizeMake(self.view.bounds.size.width, height);
}

-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)movieDetail:(id)sender{
    int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
    NSLog(@"%d",indexOfPage);
    [self performSegueWithIdentifier:@"movieDetail" sender:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.uistar.hidden = YES;
    self.uirating.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if(self.lastIndex!=indexOfPage){
    [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage]];
        self.lastIndex = indexOfPage;
    }
    self.uistar.hidden = NO;
    self.uirating.hidden = NO;
    self.ratingBg.hidden = NO;
}
-(void)setMovieDetails:(movieModel*)model{
    self.uititle.text = model.title;
    self.uirating.text = [NSString stringWithFormat:@"%d",model.rating];
    
    self.blurredBg.image =[self blurImage:model.movieImageView.image  withBottomInset:0 blurRadius:43];
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
    view.layer.mask = layer;}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)blurImage:(UIImage*)image withBottomInset:(CGFloat)inset blurRadius:(CGFloat)radius{
    
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey:kCIInputRadiusKey];
    
    CIImage *outputCIImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    
    return [UIImage imageWithCGImage: [context createCGImage:outputCIImage fromRect:ciImage.extent]];
    
}
-(void)indexClick:(UITapGestureRecognizer *)sender{
    NSLog(@"asd%ld",sender.view.tag);
    if(sender.view.tag==7){
        self.tabBarController.selectedIndex = 1;
    }
}

@end
