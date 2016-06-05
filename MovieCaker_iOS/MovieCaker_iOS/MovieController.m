//
//  FirstViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieController.h"
#import "MovieDetailController.h"
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
@property NSArray *returnData;
@end

@implementation MovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notSelected = YES;
    self.scrollView.scrollView = self.imageScroll;
    self.imageScroll.delegate = self;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieDetail:)];
    [self.imageScroll addGestureRecognizer:singleTap];
    
    self.imageScroll.pagingEnabled = YES;
    //self.imageScroll.backgroundColor = [UIColor blueColor];
    self.imageScroll.clipsToBounds = NO;
    
    self.lastIndex = 0;
    
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

    self.movieTable2Controller = [[MovieTableViewController alloc] init:1];
    self.movieTable2.delegate = self.movieTable2Controller;
    self.movieTable2.dataSource = self.movieTable2Controller;
    self.movieTable2Controller.tableHeight = self.movieTable2Height;
    self.movieTable2Controller.tableView = self.movieTable2;
 //   CGPoint position = CGPointMake(0,0);
  //  [self.MainScroll setContentOffset:position];
    [[AustinApi sharedInstance] movieList:^(NSMutableDictionary *returnData) {
        //NSLog(@"%@",returnData);
        self.returnData = returnData;
        self.movieArray = [[NSMutableArray alloc]init];
        
        int margin = 15;
        int width = 255;
        int height = 341;
        int count = 0;
        self.imageScroll.contentSize = CGSizeMake(width* [returnData count], self.imageScroll.frame.size.height);
        for(NSDictionary *row in returnData){
            
        movieModel *temp = [movieModel alloc];
        temp.title = [row objectForKey:@"CNName"];
        temp.rating = [NSString stringWithFormat:@"%@", [row objectForKey:@"AverageScore"]];
        UIImage *placeholder = [UIImage imageNamed:@"img-placeholder.jpg"];
        UIImageView *image = [[UIImageView alloc] initWithImage:temp.movieImage];
       
        NSString *url = [NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=235",[row objectForKey:@"Picture"]];
            
        image.userInteractionEnabled = YES;
            
        image.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
        [self.imageScroll addSubview:image];
        
        temp.movieImageView = image;
            
            UIView *ratingBg = [[UIView alloc]initWithFrame:CGRectMake(margin+width*count, 275, 66, 66)];
            ratingBg.backgroundColor = [UIColor colorWithRed:(77.0f/255.0f) green:(182.0f/255.0f) blue:(172.0f/255.0f) alpha:0.6];
            [self curvedMask:ratingBg];
            [self.imageScroll addSubview:ratingBg];
            UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 18, 18)];
            star.image = [UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 18)];
            [ratingBg addSubview:star];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 38, 48, 21)];
            label.text = [NSString stringWithFormat:@"%@", [row objectForKey:@"AverageScore"]];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [ratingBg addSubview:label];
        
        [self.movieArray addObject:temp];
            
        if(count==0){
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self setMovieDetails:[self.movieArray objectAtIndex:0]];
            }];
        }
        else{
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
        }
            count++;
        
    }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [[AustinApi sharedInstance]getTopic:@"6" function:^(NSArray *returnData) {
        NSLog(@"bbb%@",returnData);
        self.movieTableController = [[MovieTableViewController alloc] init:0];
        self.movieTableController.data =returnData;
        self.movieTable.delegate = self.movieTableController;
        self.movieTable.dataSource = self.movieTableController;
        self.movieTableController.tableHeight = self.movieTableHeight;
        self.movieTableController.tableView = self.movieTable;
        [self.movieTableController.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.MainScroll.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    self.notSelected = YES;
    self.MainScroll.delegate = self.scrollDelegate;
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
    if(self.notSelected&&[self.movieArray count]>0){
    [self performSegueWithIdentifier:@"movieDetail" sender:self];
        self.notSelected = NO;}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int indexOfPage = self.imageScroll.contentOffset.x / self.imageScroll.frame.size.width;
    NSLog(@"%d",indexOfPage);
    MovieDetailController *detailVc = segue.destinationViewController;
    detailVc.movieDetailInfo = [self.returnData objectAtIndex:indexOfPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if(self.lastIndex!=indexOfPage){
    [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage]];
        self.lastIndex = indexOfPage;
    }

}
-(void)setMovieDetails:(movieModel*)model{
    self.uititle.text = model.title;
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
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //First, we'll use CIAffineClamp to prevent black edges on our blurred image
    //CIAffineClamp extends the edges off to infinity (check the docs, yo)
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:filter.outputImage forKeyPath:kCIInputImageKey];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKeyPath:@"inputTransform"];
    CIImage *clampedImage = [clampFilter outputImage];
    
    //Next, create some darkness
    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.52];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];
    
    //Apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:clampedImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];
    
    return [UIImage imageWithCGImage: [context createCGImage:darkenedImage fromRect:ciImage.extent]];
    
}
-(void)indexClick:(UITapGestureRecognizer *)sender{
    NSLog(@"asd%ld",sender.view.tag);
    if(sender.view.tag==7){
        self.tabBarController.selectedIndex = 1;
    }
}

@end
