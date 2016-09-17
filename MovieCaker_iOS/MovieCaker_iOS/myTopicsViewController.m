//
//  myTopicsViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/12/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "myTopicsViewController.h"
#import "MainVerticalScroller.h"
#import "MovieTableViewController.h"
#import "AustinApi.h"
#import "TopicDetailViewController.h"

@interface myTopicsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lOne;
@property (strong, nonatomic) IBOutlet UILabel *lTwo;
@property (strong, nonatomic) IBOutlet UIView *bar;
@property NSString *uid;
@property MovieTableViewController *topicController;
@property UILabel *current;
@property MainVerticalScroller *helper;
@end

@implementation myTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ 的電影", self.nickName];
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    [self addTap:self.lOne];
    [self addTap:self.lTwo];
    self.current = self.lOne;
    
    self.topicController = [[MovieTableViewController alloc] init:0];
    self.topicController.data = [[NSArray alloc]init];
    [self.topicController ParentController:self];
    self.topicController.page= 999;
    self.tableView.delegate = self.topicController;
    self.tableView.dataSource = self.topicController;
    self.topicController.tableView = self.tableView;

    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];
    self.uid = [[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue];
    
    [[AustinApi sharedInstance]getTopic:@"4" vid:nil page:nil uid:self.uid function:^(NSArray *returnData) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:row];
            [array addObject:dict];
        }
        self.topicController.data = array;
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    if(self.jump){
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self selected:self.lTwo];
        });
        self.jump = NO;
    }
}
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.bar.frame = CGRectMake(label.frame.origin.x-4, label.frame.origin.y+25, label.frame.size.width+8, 3);
    
    [UIView commitAnimations];
    
}
-(void)addTap:(UILabel*)label{
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(preSelected:)];
    [label addGestureRecognizer:tap];
    
}
-(void)preSelected:(UIGestureRecognizer*)gesture{
    [self selected:gesture.view];
}
-(void)selected:(UILabel*)label{
            NSLog(@"work2");
    if(label!=self.current){
        if(label.tag==0){
            [[AustinApi sharedInstance]getTopic:@"4" vid:nil page:nil uid:self.uid function:^(NSArray *returnData) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSDictionary *row in returnData) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:row];
                    [array addObject:dict];
                }
                self.topicController.data = array;
                [self.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else{
            [[AustinApi sharedInstance]getTopic:@"3" vid:nil page:nil uid:self.uid function:^(NSArray *returnData) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSDictionary *row in returnData) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:row];
                    [array addObject:dict];
                }
                self.topicController.data = array;
                [self.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
        
        self.current.textColor = [UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1];
        label.textColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1];
        self.current = label;
    }
    [self moveBar:label];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"topicSegue"]){
        TopicDetailViewController *vc = segue.destinationViewController;
        vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.topicController.data objectAtIndex:self.topicController.selectIndex]];
        if(![[self.topicController.circlePercentage objectAtIndex:self.topicController.selectIndex]isKindOfClass:[NSNull class]]){
            vc.percent = [self.topicController.circlePercentage objectAtIndex:self.topicController.selectIndex];}else{
                vc.percent = [[NSNumber alloc]initWithInt:-1];NSLog(@"aaaaaa");
            }
    }}
@end
