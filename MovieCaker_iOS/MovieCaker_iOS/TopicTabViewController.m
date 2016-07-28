//
//  TopicTabViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 7/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "TopicTabViewController.h"

@interface TopicTabViewController ()
@property (strong, nonatomic) IBOutlet UILabel *tabOne;
@property (strong, nonatomic) IBOutlet UILabel *tabTwo;
@property (strong, nonatomic) IBOutlet UILabel *tabThree;
@property (strong, nonatomic) IBOutlet UIView *lowerBar;
@property int index;
@property NSArray *labelArray;
@end

@implementation TopicTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelArray = [[NSArray alloc]initWithObjects:self.tabOne,self.tabTwo,self.tabThree, nil];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];

    for (UILabel *label in self.labelArray) {
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [label addGestureRecognizer:singleFingerTap];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.lowerBar.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 4);
    
    [UIView commitAnimations];
    
}
-(void)setFilter{

}
@end
