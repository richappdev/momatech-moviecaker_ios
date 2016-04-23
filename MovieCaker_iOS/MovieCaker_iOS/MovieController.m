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

@interface MovieController ()
@property (strong, nonatomic) IBOutlet scrollBoxView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *uistar;
@property (strong, nonatomic) IBOutlet UILabel *uirating;
@property (strong, nonatomic) IBOutlet UILabel *uititle;
@property (strong, nonatomic) IBOutlet UIView *ratingBg;
@property (strong, nonatomic) IBOutlet UIImageView *blurredBg;
@property NSMutableArray *movieArray;
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
    
    [self generateList];
    [self generateMovie];
    self.lastIndex = 0;
    [self setMovieDetails:[self.movieArray objectAtIndex:0]];
    
    [self curvedMask:self.ratingBg];
    self.uistar.image = [UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(18, 18)];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


-(void)generateList{

    self.movieArray = [[NSMutableArray alloc]init];
    movieModel *temp = [movieModel alloc];
    temp.title = @"title1";
    temp.rating = 2;
    temp.movieImage = [UIImage imageNamed:@"on.png"];
    [self.movieArray addObject:temp];
    temp = [movieModel alloc];
    temp.title = @"title2";
    temp.rating = 3;
    temp.movieImage = [UIImage imageNamed:@"on.png"];
    [self.movieArray addObject:temp];
    temp = [movieModel alloc];
    temp.title = @"title3";
    temp.rating = 5;
    temp.movieImage = [UIImage imageNamed:@"on.png"];
    [self.movieArray addObject:temp];
}

-(void)generateMovie{
    int margin = 15;
    int width = 255;
    int height = 250;
    int count = 0;
    
    self.imageScroll.contentSize = CGSizeMake(width* [self.movieArray count], self.imageScroll.frame.size.height);
    
    for (movieModel *row in self.movieArray) {
        
        UIImageView *image = [[UIImageView alloc] initWithImage:row.movieImage];
        image.userInteractionEnabled = YES;
        
        image.frame = CGRectMake(margin+width*count, 0, width-margin*2, height);
        [self.imageScroll addSubview:image];
        count++;
    }
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
   // self.blurredBg.image =[self blurImage:model.movieImage withBottomInset:0 blurRadius:43];
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
@end
