//
//  TopicTabViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 7/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "TopicTabViewController.h"
#import "MovieTableViewController.h"
#import "AustinApi.h"
#import "TopicDetailViewController.h"

@interface TopicTabViewController ()
@property (strong, nonatomic) IBOutlet UILabel *tabOne;
@property (strong, nonatomic) IBOutlet UILabel *tabTwo;
@property (strong, nonatomic) IBOutlet UILabel *tabThree;
@property (strong, nonatomic) IBOutlet UIView *lowerBar;
@property int index;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *labelArray;
@property MovieTableViewController *movieTableController;
@property NSMutableArray *tabOneData;
@property NSMutableArray *tabTwoData;
@property NSMutableArray *tabThreeData;
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
    
    self.movieTableController = [[MovieTableViewController alloc] init:0];
    self.tableView.delegate = self.movieTableController;
    self.tableView.dataSource = self.movieTableController;
    self.movieTableController.tableView = self.tableView;
    [self.movieTableController ParentController:self];
    self.index =0;
    [self setData:@"6"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setData:(NSString*)type{

    [[AustinApi sharedInstance]getTopic:type vid:nil function:^(NSArray *returnData) {
        //     NSLog(@"bbb%@",returnData);
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:row];
            [array addObject:dict];
        }
        self.movieTableController.data =array;
        [self.movieTableController setNewCircleArray:[returnData count]];
        if(self.index==0){
            self.tabOneData = array;
        }else if(self.index==1){
            self.tabTwoData = array;
        }else if (self.index==2){
            self.tabThreeData=array;
        }
        [self.movieTableController.tableView reloadData];
        self.movieTableController.tableView.scrollEnabled = YES;
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)handleSingleTap:(UIGestureRecognizer*)gestureRecongnizer{
    [self moveBar:[self.labelArray objectAtIndex:gestureRecongnizer.view.tag]];
    [self setFilter:(int)gestureRecongnizer.view.tag];
    self.index = (int)gestureRecongnizer.view.tag;
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index>0){
        [self setFilter:self.index-1];
        self.index--;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index<[self.labelArray count]-1){
        [self setFilter:self.index+1];
        self.index++;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
}
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.lowerBar.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 4);
    
    [UIView commitAnimations];
    
}
-(void)setFilter:(int)page{
    NSLog(@"%d",page);
    if(self.index!=page){
        self.index = page;
        if(self.index==0){
            if(self.tabOneData==nil){
                [self setData:@"6"];
            }else{
                self.movieTableController.data = self.tabOneData;
                [self.movieTableController setNewCircleArray:[self.tabOneData count]];
                [self.tableView reloadData];
            }
        }else if(self.index==1){
            if(self.tabTwoData==nil){
                [self setData:@"1"];
            }else{
                self.movieTableController.data = self.tabTwoData;
                [self.movieTableController setNewCircleArray:[self.tabTwoData count]];
                [self.tableView reloadData];
            }
        }else if(self.index==2){
            if(self.tabThreeData==nil){
                [self setData:@"0"];
            }else{
                self.movieTableController.data = self.tabThreeData;
                [self.movieTableController setNewCircleArray:[self.tabThreeData count]];
                [self.tableView reloadData];
            }
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
if([[segue identifier] isEqualToString:@"topicSegue"]){
    TopicDetailViewController *vc = segue.destinationViewController;
    vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex]];
    if(![[self.movieTableController.circlePercentage objectAtIndex:self.movieTableController.selectIndex]isKindOfClass:[NSNull class]]){
        vc.percent = [self.movieTableController.circlePercentage objectAtIndex:self.movieTableController.selectIndex];}else{
            vc.percent = [[NSNumber alloc]initWithInt:-1];NSLog(@"aaaaaa");
        }
    NSLog(@"%@",self.movieTableController.circlePercentage);
}}
@end
