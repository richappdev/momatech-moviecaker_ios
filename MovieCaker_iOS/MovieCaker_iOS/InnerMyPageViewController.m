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
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UILabel *sex;
@property (strong, nonatomic) IBOutlet UILabel *bday;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIView *logout;
@end

@implementation InnerMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(182/255.0) blue:(172/255.0) alpha:1];
    self.title = @"我的裝置";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:(128/255.0) green:(203/255.0) blue:(196/255.0) alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]}];

    [self.view addSubview:statusView];
    
    NSDictionary *returnData = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]] objectForKey:@"Data"];
    self.nickname.text = [returnData objectForKey:@"NickName"];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[[AustinApi sharedInstance] getBaseUrl],[returnData objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    
    if([[returnData objectForKey:@"Gender"] integerValue]==1){
        self.sex.text = @"男";
    }else{
        self.sex.text = @"女";
    }
    self.location.text = [returnData objectForKey:@"LocationName"];
    self.bday.text = [[returnData objectForKey:@"BrithDay"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.bday.text = [self.bday.text substringWithRange:NSMakeRange(0,[self.bday.text rangeOfString:@"T"].location)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutClick)];
    [self.logout addGestureRecognizer:tap];
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
