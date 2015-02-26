//
//  MyVideoViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MyVideoViewController.h"
#import "MyVideoChildViewController.h"



@interface MyVideoViewController ()

    @property(nonatomic,strong) NSNumber *uid;
    @property(nonatomic,strong) MyVideoChildViewController *seenViewController;
    @property(nonatomic,strong) MyVideoChildViewController *likeViewController;
    @property(nonatomic,strong) MyVideoChildViewController *wantViewController;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyVideoViewController

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
        self.title=NSLocalizedStringFromTable(@"我的電影",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@%@%@",self.friend.nickName,NSLocalizedStringFromTable(@"的",@"InfoPlist",nil),NSLocalizedStringFromTable(@"電影",@"InfoPlist",nil)];
    }
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"我看過",@"InfoPlist",nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"我喜歡",@"InfoPlist",nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"我想看",@"InfoPlist",nil) forSegmentAtIndex:2];
    if([self isRunningiOS7]){
        [self.segmentedControl setTintColor:[UIColor whiteColor]];
    }
    
    [self childPages];
    
    


    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//設定childViewController
-(void) childPages {
    self.seenViewController=[[MyVideoChildViewController alloc] initWithNibName:@"MyVideoChildViewController" bundle:nil];
    self.likeViewController=[[MyVideoChildViewController alloc] initWithNibName:@"MyVideoChildViewController" bundle:nil];
    self.wantViewController=[[MyVideoChildViewController alloc] initWithNibName:@"MyVideoChildViewController" bundle:nil];
    
    self.seenViewController.friend=self.friend;
    self.seenViewController.myType=@(0);
    
    self.likeViewController.friend=self.friend;
    self.likeViewController.myType=@(1);
    
    self.wantViewController.friend=self.friend;
    self.wantViewController.myType=@(2);
    
    [self showViewController:self.seenViewController animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didChangeSegmentControl:(id)sender {
     UISegmentedControl *control=sender;
    
    if (control.selectedSegmentIndex==0){
        [self showViewController:self.seenViewController animated:YES];
        [self hideViewController:self.likeViewController animated:YES];
        [self hideViewController:self.wantViewController animated:YES];
    }else if(control.selectedSegmentIndex==1){
        [self hideViewController:self.seenViewController animated:YES];
        [self showViewController:self.likeViewController animated:YES];
        [self hideViewController:self.wantViewController animated:YES];
    }else{
        [self hideViewController:self.seenViewController animated:YES];
        [self hideViewController:self.likeViewController animated:YES];
        [self showViewController:self.wantViewController animated:YES];
    }
}
@end
