//
//  MySchoolPartyViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MySchoolPartyViewController.h"
#import "MyPartyChildViewController.h"


@interface MySchoolPartyViewController ()
    @property(strong,nonatomic) MyPartyChildViewController *myJoinPartyViewController;
    @property(strong,nonatomic) MyPartyChildViewController *myManagerPartyViewController;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MySchoolPartyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userID=self.userInfo[@"UserId"];
    if (userID.intValue==self.friend.userId.intValue) {
        self.title=NSLocalizedStringFromTable(@"我的社團",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@的%@",self.friend.nickName,NSLocalizedStringFromTable(@"社團",@"InfoPlist",nil)];
    }
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    if([self isRunningiOS7]){
        [self.segmentedControl setTintColor:[UIColor whiteColor]];
    }
    
    [self childPages];
    // Do any additional setup after loading the view from its nib.
}

//設定childViewController
-(void) childPages {
    self.myJoinPartyViewController=[[MyPartyChildViewController alloc] initWithNibName:@"MyTopicChildViewController" bundle:nil];
    self.myManagerPartyViewController=[[MyPartyChildViewController alloc] initWithNibName:@"MyTopicChildViewController" bundle:nil];
    
    self.myJoinPartyViewController.friend=self.friend;
    self.myJoinPartyViewController.channel=@"Join";
    [self showViewController:self.myJoinPartyViewController animated:YES];
}


- (IBAction)didChangeSegmentControl:(id)sender {
    
    UISegmentedControl *control=sender;
    //NSString *title=[control titleForSegmentAtIndex:control.selectedSegmentIndex];
    
    if (control.selectedSegmentIndex==0){
        [self hideViewController:self.myManagerPartyViewController animated:YES];
        self.myJoinPartyViewController.friend=self.friend;
        self.myJoinPartyViewController.channel=@"Join";
        [self showViewController:self.myJoinPartyViewController animated:YES];
    }else{
        [self hideViewController:self.myJoinPartyViewController animated:YES];
        self.myManagerPartyViewController.friend=self.friend;
        self.myManagerPartyViewController.channel=@"My";
        [self showViewController:self.myManagerPartyViewController animated:YES];
        
    }
}

- (void)showViewController:(UIViewController *)vc animated:(BOOL)animated
{
    
    NSLog(@"showViewController");
    // only if view is not presented
    
    if(vc && vc.parentViewController == nil)
    {
        if(animated)
        {
            // vc view is initial pos at bot of content view
            CGRect frame = self.contentView.bounds;
            frame.origin.y = CGRectGetMaxY(frame);
            vc.view.frame = frame;
            
            [self addChildViewController:vc];
            [self.contentView addSubview:vc.view];
            [vc didMoveToParentViewController:self];
            
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 vc.view.frame = self.contentView.bounds;
                             }];
        }
        else
        {
            vc.view.frame = self.contentView.bounds;
            
            [self addChildViewController:vc];
            [self.contentView addSubview:vc.view];
            [vc didMoveToParentViewController:self];
        }
    }
}

- (void)hideViewController:(UIViewController *)vc animated:(BOOL)animated
{
    NSLog(@"hideViewController");
    // only if view is presented
    if(vc && vc.parentViewController)
    {
        if(animated)
        {
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 // animate to slide down
                                 CGRect frame = self.contentView.bounds;
                                 frame.origin.y = CGRectGetMaxY(frame);
                                 vc.view.frame = frame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 [vc willMoveToParentViewController:nil];
                                 [vc.view removeFromSuperview];
                                 [vc removeFromParentViewController];
                                 
                             }];
        }
        else
        {
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
}


-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
