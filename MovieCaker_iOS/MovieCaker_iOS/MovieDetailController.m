//
//  MovieDetailControllerViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/14/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieDetailController.h"

@interface MovieDetailController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIScrollView *actorScroll;

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

-(void)viewDidLayoutSubviews{

    self.actorScroll.contentSize = CGSizeMake(100*11, self.actorScroll.frame.size.height);
    
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
