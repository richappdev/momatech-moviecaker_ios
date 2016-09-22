//
//  editViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "editViewController.h"
#import "MainVerticalScroller.h"
#import "AustinApi.h"
#import "InnerMyPageViewController.h"

@interface editViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property MainVerticalScroller *helper;
@end

@implementation editViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"編輯暱稱";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem =item;
    
    InnerMyPageViewController *temp = [self.navigationController.viewControllers objectAtIndex:1];
    self.textfield.text = temp.nickname.text;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.textfield.frame.size.height +50, self.textfield.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.textfield.layer addSublayer:bottomBorder];
}

-(void)doneClick{
    InnerMyPageViewController *temp = [self.navigationController.viewControllers objectAtIndex:1];
    temp.nickname.text = self.textfield.text;
     NSMutableDictionary *returnData = [[NSMutableDictionary alloc]initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]]];
    
    [returnData setObject:[[NSMutableDictionary alloc] initWithDictionary:[returnData objectForKey:@"Data"]] forKey:@"Data"];
    [[returnData objectForKey:@"Data"] setObject:self.textfield.text forKey:@"NickName"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returnData] forKey:@"userkey"];
    
    [[AustinApi sharedInstance]changeProfile:self.textfield.text gender:[[returnData objectForKey:@"Data"]objectForKey:@"Gender"] birthday:[[returnData objectForKey:@"Data"]objectForKey:@"BrithDay"] function:^(NSDictionary *returnData) {
    
    } error:^(NSError *error) {
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
