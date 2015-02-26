//
//  VideoContentViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/11.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "VideoContentViewController.h"
#import "VideoDetailViewController.h"
#import "FilmReviewViewController.h"
#import "LineUpViewController.h"

@interface VideoContentViewController ()
    @property(strong, nonatomic) VideoDetailViewController *videoDetailViewController;
    @property(strong, nonatomic) FilmReviewViewController *filmReviewViewController;
    @property(strong, nonatomic) LineUpViewController *lineUpViewController;
    @property(strong, nonatomic) NSArray *actorArray;
@end

@implementation VideoContentViewController

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
    
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    
    if([self isRunningiOS7]){
        [self.segmentedControl setTintColor:[UIColor whiteColor]];
    }
    
    
    
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"影片介紹",@"InfoPlist",nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"影評",@"InfoPlist",nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"導演及演員",@"InfoPlist",nil) forSegmentAtIndex:2];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    
    if (self.video) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            self.title=self.video.name;
        }else{
            self.title=self.video.cnName;
        }
        
        if (self.video.reviewNum.intValue<=0) {
            [self.segmentedControl removeSegmentAtIndex:1 animated:NO];
        }
        [self childPages];
        self.videoDetailViewController.video=self.video;
        [self showViewController:self.videoDetailViewController animated:YES];
    }else{
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager getVideoWithVideoID:self.videoId callback:^(VideoObj *video, NSMutableArray *actorArray,NSString *errorMsg, NSError *error) {
            
            self.video=video;
            
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                self.title=self.video.name;
            }else{
                self.title=self.video.cnName;
            }
            
            NSLog(@"self.video.reviewNum.intValue:%d",self.video.reviewNum.intValue);
            
            if (self.video.reviewNum.intValue<=0) {
                [self.segmentedControl removeSegmentAtIndex:1 animated:NO];
            }
            
            [self childPages];
            if (self.landingNo==1) {
                self.segmentedControl.selectedSegmentIndex=1;
                self.filmReviewViewController.video=self.video;
                [self showViewController:self.filmReviewViewController animated:YES];
            }else{
                self.segmentedControl.selectedSegmentIndex=0;
                self.videoDetailViewController.video=self.video;
                [self showViewController:self.videoDetailViewController animated:YES];
            }
            
            self.actorArray=[NSArray arrayWithArray:actorArray];
            
            [WaitingAlert dismiss];

        }];
        
    }
    
    
    
}

//設定childViewController

-(void) childPages {
    
    self.videoDetailViewController=[[VideoDetailViewController alloc] initWithNibName:@"VideoDetailViewController" bundle:nil];
    
    self.filmReviewViewController=[[FilmReviewViewController alloc] initWithNibName:@"FilmReviewViewController" bundle:nil];
    
    self.lineUpViewController=[[LineUpViewController alloc] initWithNibName:@"LineUpViewController" bundle:nil];
    //self.videoDetailViewController.video=self.video;
    //[self showViewController:self.videoDetailViewController animated:YES];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didChangeSegmentControl:(id)sender {
    
    UISegmentedControl *control=sender;
    NSString *title=[control titleForSegmentAtIndex:control.selectedSegmentIndex];
    
    if ([title isEqualToString:NSLocalizedStringFromTable(@"影片介紹",@"InfoPlist",nil)]){
        [self hideViewController:self.lineUpViewController animated:YES];
        [self hideViewController:self.filmReviewViewController animated:YES];
        self.videoDetailViewController.video=self.video;
        [self showViewController:self.videoDetailViewController animated:YES];
    }else if ([title isEqualToString:NSLocalizedStringFromTable(@"影評",@"InfoPlist",nil)]){
        [self hideViewController:self.lineUpViewController animated:YES];
        [self hideViewController:self.videoDetailViewController animated:YES];
        self.filmReviewViewController.video=self.video;
        [self showViewController:self.filmReviewViewController animated:YES];
    }else{
        [self hideViewController:self.videoDetailViewController animated:YES];
        [self hideViewController:self.filmReviewViewController animated:YES];
        self.lineUpViewController.video=self.video;
        self.lineUpViewController.actorArray=self.actorArray;
        [self showViewController:self.lineUpViewController animated:YES];

    }
}

-(void)viewDidAppear:(BOOL)animated{

}


- (void)showViewController:(UIViewController *)vc animated:(BOOL)animated
{
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


@end
