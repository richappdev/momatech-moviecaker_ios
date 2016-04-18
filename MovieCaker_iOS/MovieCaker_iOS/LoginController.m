//
//  LoginController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/17/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "LoginController.h"

#import "WXApi.h"
#import "AFNetworking.h"


#define WECHAT_APP_ID         @"wxd0d7b13dff0c2d5e" //WXD0D7B13DFF0C2D5E
#define WECHAT_MCH_ID         @"1272035301"
#define WECHAT_KEY            @"AOGAKNHPNOJSZRA10KQDEJY5OGAYQYC5" //@"aogaknhpnojszra10kqdejy5ogayqyc5" //AOGAKNHPNOJSZRA10KQDEJY5OGAYQYC5
#define WECHAT_APP_SECRET     @"b509f23d24440efe31fff96c476d4761" //@"b509f23d24440efe31fff96c476d4761"B509F23D24440EFE31FFF96C476D4761


@interface LoginController ()
- (IBAction)Login:(id)sender;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Login:(id)sender {
    NSLog(@"was");
    [WXApi registerApp:WECHAT_APP_ID];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    [req setScope:@"snsapi_userinfo"];
    [WXApi sendAuthReq:req viewController:self delegate:self];
}
@end
