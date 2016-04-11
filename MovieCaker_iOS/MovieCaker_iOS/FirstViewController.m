//
//  FirstViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "FirstViewController.h"
#import "scrollBoxView.h"
@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet scrollBoxView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.scrollView = self.imageScroll;
    
    self.imageScroll.contentSize = CGSizeMake(2000, self.imageScroll.frame.size.height);
    self.imageScroll.pagingEnabled = YES;
    //self.imageScroll.backgroundColor = [UIColor blueColor];
    self.imageScroll.clipsToBounds = NO;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"on.png"]];
    image.frame = CGRectMake(10, 0, 130, 250);
    [self.imageScroll addSubview:image];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"on.png"]];
    image2.frame = CGRectMake(160, 0, 130, 250);
    [self.imageScroll addSubview:image2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"on.png"]];
    image3.frame = CGRectMake(310, 0, 130, 250);
    [self.imageScroll addSubview:image3];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
