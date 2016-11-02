//
//  friendsViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "friendsViewController.h"
#import "MainVerticalScroller.h"
#import "AustinApi.h"
#import "friendTableViewController.h"
#import "MBProgressHUD.h"
@interface friendsViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UILabel *lOne;
@property (strong, nonatomic) IBOutlet UILabel *lTwo;
@property (strong, nonatomic) IBOutlet UILabel *lThree;
@property (strong, nonatomic) IBOutlet UIView *bar;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property friendTableViewController *tableController;
@property UILabel *current;

@end

@implementation friendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ 的朋友", self.nickName];
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    [self addTap:self.lOne];
    [self addTap:self.lTwo];
    [self addTap:self.lThree];
    self.current = self.lOne;
    
    self.tableController = [[friendTableViewController alloc]init];
    self.tableController.page = 999;
    self.tableController.parentController = self;
    self.tableController.tableView = self.tableview;
    self.tableview.allowsSelection = NO;
    self.tableview.dataSource = self.tableController;
    self.tableview.delegate = self.tableController;
    self.tableController.type = 0;
    AustinApi *temp3 = [AustinApi sharedInstance];
    self.tableController.data = [[NSMutableArray alloc] initWithArray:temp3.friendList];
    [self.tableview reloadData];
}
-(void)addTap:(UILabel*)label{
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(preSelected:)];
    [label addGestureRecognizer:tap];

}
-(void)preSelected:(UIGestureRecognizer*)gesture{
    [self selected:gesture.view];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selected:(UILabel*)label{
    if(label!=self.current){
    self.current.textColor = [UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1];
    label.textColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1];
    
        self.current = label;
    
        [self moveBar:self.current];
        self.tableController.type = (int)label.tag;
        AustinApi *temp3 = [AustinApi sharedInstance];
        if(label.tag==0){
            self.tableController.data = temp3.friendList;
        }else{
            NSMutableArray *one= [[NSMutableArray alloc]init];
            NSMutableArray *two = [[NSMutableArray alloc]init];
            for (NSDictionary *row in temp3.friendWaitList) {
                if([[row objectForKey:@"IsInviting"]integerValue]==1){
                    [one addObject:row];
                }else{
                    [two addObject:row];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[one count]] forKey:@"inviteCount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if(label.tag==1){
                self.tableController.data =  [[NSMutableArray alloc] initWithArray:one];
            }else{
                self.tableController.data =  [[NSMutableArray alloc] initWithArray:two];
            }
        }
        
        [self.tableview reloadData];
    }
}

-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.bar.frame = CGRectMake(label.frame.origin.x-4, label.frame.origin.y+25, 64, 3);
    
    [UIView commitAnimations];
    
}
-(void)loadMore:(int)page{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];
    [[AustinApi sharedInstance]getFriends:[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue] page:page function:^(NSString *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        AustinApi *temp = [AustinApi sharedInstance];
        self.tableController.data = temp.friendList;
        [self.tableController.tableView reloadData];
    } refresh:YES];
}
@end
