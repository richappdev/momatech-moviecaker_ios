//
//  PertyContentViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/4/8.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "PertyContentViewController.h"
#import "SchoolPartyDetailViewController.h"
#import "TalkViewController.h"
#import "PartyMemberViewController.h"

@interface PertyContentViewController ()
   // @property(strong, nonatomic) SchoolPartyDetailViewController *schoolPartyDetailViewController;
    @property(strong, nonatomic) TalkViewController *talkViewController;
    @property(strong, nonatomic) PartyMemberViewController *partyMemberViewController;
@end

@implementation PertyContentViewController

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
    
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"社團介紹",@"InfoPlist",nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedStringFromTable(@"話題",@"InfoPlist",nil) forSegmentAtIndex:1];
    
    if([self isRunningiOS7]){
        [self.segmentedControl setTintColor:[UIColor whiteColor]];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    [self childPages];
    // Do any additional setup after loading the view from its nib.
    
    if (self.party) {
        self.title=self.party.name;
        self.partyMemberViewController.party=self.party;
        [self showViewController:self.partyMemberViewController animated:YES];
        
    }else{
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager clubWithId:self.partyID callback:^(SchoolPartyObj *party, NSString *errorMsg, NSError *error) {
            
            [WaitingAlert dismiss];
            
            self.party=party;
            self.title=self.party.name;
            self.partyMemberViewController.party=self.party;
            [self showViewController:self.partyMemberViewController animated:YES];
            
        }];
    }
}

-(void) childPages {
    
    //self.schoolPartyDetailViewController=[[SchoolPartyDetailViewController alloc] initWithNibName:@"SchoolPartyDetailViewController" bundle:nil];
    self.talkViewController=[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil];
    self.partyMemberViewController=[[PartyMemberViewController alloc] initWithNibName:@"PartyMemberViewController" bundle:nil];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)didChangeSegmentControl:(id)sender {
    
    UISegmentedControl *control=sender;
    NSString *title=[control titleForSegmentAtIndex:control.selectedSegmentIndex];
    
    if ([title isEqualToString:NSLocalizedStringFromTable(@"社團介紹",@"InfoPlist",nil)]){
        [self hideViewController:self.talkViewController animated:YES];
        self.self.partyMemberViewController.party=self.party;
        [self showViewController:self.partyMemberViewController animated:YES];
        //[self hideViewController:self.partyMemberViewController animated:YES];
    }else if ([title isEqualToString:NSLocalizedStringFromTable(@"話題",@"InfoPlist",nil)]){
        //[self hideViewController:self.schoolPartyDetailViewController animated:YES];
        if(self.party.isPublic.boolValue){
            self.self.talkViewController.party=self.party;
            [self showViewController:self.talkViewController animated:YES];
            [self hideViewController:self.partyMemberViewController animated:YES];
        }else{
            if (self.party.isJoined.boolValue && self.party.isPassAudit.boolValue) {
                self.self.talkViewController.party=self.party;
                [self showViewController:self.talkViewController animated:YES];
                [self hideViewController:self.partyMemberViewController animated:YES];
            }else{
                [control setSelectedSegmentIndex:0];
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [self alertShow:@"此社團性質為不公開，需加入後才能閱讀開社團話題！"];
                }else{
                    [self alertShow:@"此群组性质为不公开，需加入后才能阅读开群组话题！"];
                }
                
            }
        }

    }
}
@end
