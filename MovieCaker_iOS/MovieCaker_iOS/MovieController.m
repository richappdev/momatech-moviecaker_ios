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

@interface MovieController ()
@property (strong, nonatomic) IBOutlet scrollBoxView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *uistar;
@property (strong, nonatomic) IBOutlet UILabel *uirating;
@property (strong, nonatomic) IBOutlet UILabel *uititle;
@property NSMutableArray *movieArray;
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
    // Do any additional setup after loading the view, typically from a nib.
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
    int margin = 10;
    int width = 150;
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
    [self setMovieDetails:[self.movieArray objectAtIndex:indexOfPage]];
    self.uistar.hidden = NO;
    self.uirating.hidden = NO;
    
}
-(void)setMovieDetails:(movieModel*)model{
    self.uititle.text = model.title;
    self.uirating.text = [NSString stringWithFormat:@"%d",model.rating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
