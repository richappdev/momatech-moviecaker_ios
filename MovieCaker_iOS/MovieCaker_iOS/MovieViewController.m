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

}

-(void)handleSingleTap:(UIGestureRecognizer*)gestureRecongnizer{
    [self moveBar:[self.labelArray objectAtIndex:gestureRecongnizer.view.tag]];
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index>0){
        self.index--;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index<[self.labelArray count]){
        self.index++;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
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
