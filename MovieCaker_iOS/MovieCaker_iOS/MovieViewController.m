//
//  SecondViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieViewController.h"
#import "AustinApi.h"
#import "MovieTwoTableViewController.h"

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
@property (strong, nonatomic) IBOutlet UIView *locationFilter;
@property (strong, nonatomic) IBOutlet UIView *locationConfirmBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationConstrant;
@property UIView *currentFilter;
@property int filterIndex;
@property NSArray *labelArray;
@property NSArray *locationArray;
@property int locationIndex;
@property int index;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITableView *movieTable;
@property MovieTwoTableViewController *movieTableController;
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

    CALayer *top = [CALayer layer];
    top.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    top.borderWidth = 1;
    top.frame = CGRectMake(0,0, CGRectGetWidth(self.view.frame), 1.0f);
    
    
    self.locationFilter.clipsToBounds = YES;
    [self.locationFilter.layer addSublayer:top];
    
    UITapGestureRecognizer *locationConfirm =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmLocation:)];
    [self.locationConfirmBtn addGestureRecognizer:locationConfirm];

    UITapGestureRecognizer *showLocation =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation:)];
    [self.locationBtn addGestureRecognizer:showLocation];
    
    self.locationIndex = 0;
    [self createLocationIcons];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTable.allowsSelection = NO;
    self.movieTableController.tableView = self.movieTable;
}
-(void)createLocationIcons{
    
    
    [[AustinApi sharedInstance] locationList:^(NSMutableDictionary *returnData) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        int count = 0;
        for (NSDictionary *row in returnData) {
            if(count==0){
                self.locationLabel.text = [row objectForKey:@"Name"];
            }
            UIView *view;
            if(self.view.frame.size.width>=375){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 30, 62, 28)];
            }else{
                if(count<4){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 20, 62, 28)];
                }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(18, 52, 62, 28)];
                }
            }
            view.tag = count;
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1].CGColor;
            view.layer.cornerRadius = 4;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationBtnClick:)];
            [view addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 28)];
            label.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
            label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
            label.text = [row objectForKey:@"Name"];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self.locationFilter addSubview:view];
            count++;
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view",label,@"label", nil];
            [tempArray addObject:dict];
        }
        self.locationArray = tempArray;
        [self setLocationBtnColor:0];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}
-(void)setLocationBtnColor:(int)index{
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UIView *view = [temp objectForKey:@"view"];
    UILabel *label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor whiteColor];
    label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    
    temp = [self.locationArray objectAtIndex:index];
    view = [temp objectForKey:@"view"];
    label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    label.textColor = [UIColor whiteColor];
    self.locationIndex = index;
}
-(void)locationBtnClick:(UITapGestureRecognizer*)gestureRecongnizer{
    [self setLocationBtnColor:(int)gestureRecongnizer.view.tag];
}
-(void)confirmLocation:(UISwipeGestureRecognizer*)gestureRecongnizer{
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = -150;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UILabel *label = [temp objectForKey:@"label"];
    self.locationLabel.text = label.text;
    self.locationLabel.tag = self.locationIndex;
}

-(void)showLocation:(UISwipeGestureRecognizer*)gestureRecongnizer{
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
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
    //cancel location selection
    [self setLocationBtnColor:(int)self.locationLabel.tag];
    [self confirmLocation:nil];
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
