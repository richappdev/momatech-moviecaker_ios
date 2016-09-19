//
//  InnerMyPageViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/22/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "InnerMyPageViewController.h"
#import "MainVerticalScroller.h"
#import "UIImage+FontAwesome.h"
#import "AustinApi.h"
#import "UIImageView+WebCache.h"
#import "LoginController.h"

@interface InnerMyPageViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *sex;
@property (strong, nonatomic) IBOutlet UILabel *bday;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIView *logout;
@property (strong, nonatomic) IBOutlet UIView *editView;
@end

@implementation InnerMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的裝置";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    NSDictionary *returnData = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]] objectForKey:@"Data"];
    self.nickname.text = [returnData objectForKey:@"NickName"];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[[AustinApi sharedInstance] getBaseUrl],[returnData objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    if(![[returnData objectForKey:@"Gender"]isKindOfClass:[NSNull class]]&&[[returnData objectForKey:@"Gender"] integerValue]==1){
        self.sex.text = @"男";
    }else{
        self.sex.text = @"女";
    }
    self.location.text = [returnData objectForKey:@"LocationName"];
    self.bday.text = [[returnData objectForKey:@"BrithDay"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.bday.text = [self.bday.text substringWithRange:NSMakeRange(0,[self.bday.text rangeOfString:@"T"].location)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutClick)];
    [self.logout addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editClick)];
    [self.editView addGestureRecognizer:tap2];
}

-(void)editClick{
    [self performSegueWithIdentifier:@"editSegue" sender:self];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)logoutClick{
    LoginController *root = (LoginController*)[self.navigationController.viewControllers objectAtIndex:0];
    [root logout];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
