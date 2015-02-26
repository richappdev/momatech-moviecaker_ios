//
//  JoinTopicViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/23.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "JoinTopicViewController.h"

@interface JoinTopicViewController ()

@end

@implementation JoinTopicViewController

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
    
    self.title=@"加入專題";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"關閉" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    if (![self isRunningiOS7]) {
        [rightButton setTintColor:[UIColor blackColor]];
    }
    
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view from its nib.
}

-(void)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
