//
//  SecondViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UIView *lowerBar;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;
@property (strong, nonatomic) IBOutlet UIView *firstFilter;
@property (strong, nonatomic) IBOutlet UIView *secondFilter;
@property (strong, nonatomic) IBOutlet UIView *thirdFilter;
@property (strong, nonatomic) IBOutlet UIView *locationBtn;
@property UIView *currentFilter;
@property int filterIndex;
@property NSArray *labelArray;
@property int index;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    self.labelArray = [[NSArray alloc]initWithObjects:self.firstLabel,self.secondLabel,self.thirdLabel,self.fourthLabel, nil];
    
    for (UILabel *label in self.labelArray) {
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [label addGestureRecognizer:singleFingerTap];
    }
    self.index = 0;
    self.filterIndex = 0;
    self.currentFilter = self.firstFilter;
    
    self.locationBtn.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.locationBtn.frame), CGRectGetHeight(self.locationBtn.frame)+2);
    
    [self.locationBtn.layer addSublayer:rightBorder];
}

-(void)handleSingleTap:(UIGestureRecognizer*)gestureRecongnizer{
    self.index = (int)gestureRecongnizer.view.tag;
    [self moveBar:[self.labelArray objectAtIndex:gestureRecongnizer.view.tag]];
    [self setFilter];
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index>0){
        self.index--;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index<[self.labelArray count]-1){
        self.index++;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)setFilter{
    if(self.index!=self.filterIndex){
        self.filterIndex = self.index;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.currentFilter.alpha = 0;
        BOOL change = false;
        if(self.filterIndex ==0){
            self.currentFilter = self.firstFilter;
            change = true;
        }
        if(self.filterIndex==1){
            self.currentFilter = self.secondFilter;
            change = true;
        }
        if(self.filterIndex==3){
            self.currentFilter = self.thirdFilter;
            change = true;
        }
        if(change){
            self.currentFilter.alpha = 1;}
        [UIView commitAnimations];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.lowerBar.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 4);
    
    [UIView commitAnimations];

}
@end
