//
//  myTopicsViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/12/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "myTopicsViewController.h"
#import "MainVerticalScroller.h"

@interface myTopicsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lOne;
@property (strong, nonatomic) IBOutlet UILabel *lTwo;
@property (strong, nonatomic) IBOutlet UIView *bar;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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
    if(label!=self.current){
        self.current.textColor = [UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1];
        label.textColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1];
        self.current = label;
    }
    [self moveBar:label];
}
@end
